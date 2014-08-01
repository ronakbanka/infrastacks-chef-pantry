#
# Cookbook Name:: spark
# Recipe:: [Setup InfraStacks Spark Package Builder]
#
# Copyright 2014, InfraStacks,LLC  dev@infrastacks.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# cookbooksributed under the License is cookbooksributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Build for Hadoop CDH4.5.0 without YARN (mrv1)
# Components:
# spark-0.9.1



execute "update package index" do
  command "apt-get update"
  ignore_failure true
  action :run
end.run_action(:run)

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end


%w'upstart
libunwind7
libunwind7-dev
git
build-essential
python-dev
libcurl4-openssl-dev
autotools-dev
libltdl-dev
libtool
autoconf
autopoint'.each do | pack |
  package pack do
    action :install
    options "--force-yes"
  end
end


gem_package "fpm"

include_recipe "java"

spark_spark_dist = node[:spark][:dist]
spark_wget_path = node[:spark][:wget_path]


remote_file "/tmp/spark-#{spark_spark_dist}.tgz" do
  source "#{spark_wget_path}"
  not_if { File.exists?("/tmp/spark-#{spark_spark_dist}.tgz") }
end



script "Setup Spark Dependencies" do
  interpreter "bash"
  code <<-EOH
  sudo mkdir -p /opt/spark/
  EOH
  not_if { File.exists?("/opt/spark/") }
end



script "Setup Spark Build Environment" do
  interpreter "bash"
  code <<-EOH
  mkdir -p /home/vagrant/spark-build
  tar -zxvf /tmp/spark-#{spark_spark_dist}.tgz -C /home/vagrant/spark-build
  EOH
  not_if { File.exists?("/home/vagrant/spark-#{spark_spark_dist}") }
end

template "SharkBuild.scala" do
  path "/home/vagrant/spark-build/shark-0.8.1/project/SharkBuild.scala"
  source "SharkBuild.scala_CDH4.erb"
  # owner "root"
  # group "root"
  mode "0755"
end


# Disabling YARN as we use Mesos

# script "Building Spark for cdh4.5.0" do
#   interpreter "bash"
#   code <<-EOH
#   cd /home/vagrant/spark-build/spark-#{spark_spark_dist}-incubating
#   sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.5.0 SPARK_YARN=true sbt/sbt clean compile
#   sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.5.0 SPARK_YARN=true sbt/sbt assembly
#   sudo ./make-distribution.sh --hadoop 2.0.0-cdh4.5.0 --tgz --with-yarn
#   sudo tar -zxvf spark-0.8.1-incubating-hadoop_2.0.0-cdh4.5.0-bin.tar.gz -C /opt/spark/component/
#   EOH
#   not_if { File.exists?("/home/vagrant/spark-build/spark-0.8.1-incubating/spark-0.8.1-incubating-hadoop_2.0.0-cdh4.5.0-bin.tar.gz") }
# end

script "Building Spark for cdh4.5.0" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/spark-build/spark-#{spark_spark_dist}
  sudo sbt/sbt publish-local
  sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.5.0 SPARK_YARN=false sbt/sbt clean compile
  sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.5.0 SPARK_YARN=false sbt/sbt assembly
  sudo ./make-distribution.sh --hadoop 2.0.0-cdh4.5.0 --tgz
  sudo tar -zxvf spark-0.8.1-incubating-hadoop_2.0.0-cdh4.5.0-bin.tar.gz -C /opt/spark/
  EOH
  not_if { File.exists?("/home/vagrant/spark-build/spark-0.9.1/spark-0.9.1-hadoop_2.0.0-cdh4.5.0-bin.tar.gz") }
end

case node["platform"]
when "debian", "ubuntu"
 script "Packaging spark .deb for cdh4.5.0" do
    interpreter "bash"
    code <<-EOH
    sudo mkdir -p /home/vagrant/spark-build/pkg
    sudo cp -r /home/vagrant/dev/Org/InfraStacks/OpenSource/spark/conf /opt/spark
    sudo cp -r /home/vagrant/dev/Org/Infrastacks/OpenSource/spark/bin  /opt/spark
    fpm --verbose --package /home/vagrant/spark_0.9.1_amd64.deb --workdir /home/vagrant/spark-build/pkg/ \
    -s dir -t deb -n spark -v 0.9.1 -m dev@infrastacks.com \
    --description "Apache Spark unofficial .deb package provided by InfraStacks"  \
    --deb-compression bzip2 --license "Apache 2.0" --vendor "InfraStacks, LLC" --url "http://infrastacks.com" \
    --post-install="/opt/spark/conf/setenv.sh" -C /home/vagrant/spark-build/ /opt/spark/
    sudo mv  /home/vagrant/spark-0.9.1_amd64.deb /home/vagrant/dev/Org/InfraStacks/OpenSource/spark/pkg
    EOH
    not_if { File.exists?("/home/vagrant/dev/Org/InfraStacks/OpenSource/spark/pkg/spark-0.9.1_amd64.deb") }
  end

when "redhat", "centos", "fedora"
  script "Packaging spark .rpm for cdh4.5.0" do
    interpreter "bash"
    code <<-EOH
    fpm --verbose --package /home/vagrant/spark_0.0.1-beta_amd64.rpm --workdir /home/vagrant/spark-build/pkg/ \
    -s dir -t rpm -n spark -v 0.0.1-beta -m dev@infrastacks.com \
    --description "Apache Spark unofficial .rpm package provided by InfraStacks"  \
    --deb-compression bzip2 --license "Apache 2.0" --vendor "InfraStacks, LLC" --url "http://infrastacks.com" \
    --post-install="/opt/spark/conf/setenv.sh" -C /home/vagrant/spark-build/ /opt/spark/
    sudo mv  /home/vagrant/spark_0.0.1-beta_amd64.rpm /home/vagrant/dev/Org/InfraStacks/OpenSource/spark/pkg
    EOH
    not_if { File.exists?("/home/vagrant/dev/Org/InfraStacks/OpenSource/spark/pkg/spark-0.9.1_amd64.rpm") }
  end
end
