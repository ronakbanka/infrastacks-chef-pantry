#
# Cookbook Name:: datanamix
# Recipe:: [Setup Appliv Datanamix Package Builder]
#
# Copyright 2013, InfraStacks,LLC  engineering@Appliv.io
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

# Build for Hadoop CDH5 without YARN (mrv1)
# Components:
# spark-0.8.1
# shark-0.8.1
# mesos-0.14.2



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

datanamix_spark_dist = node[:datanamix][:spark][:dist]
datanamix_spark_wget_path = node[:datanamix][:spark][:wget_path]
datanamix_scala_wget_path = node[:datanamix][:scala][:wget_path]
datanamix_hive_wget_path = node[:datanamix][:hive][:wget_path]
datanamix_mesos_wget_path = node[:datanamix][:mesos][:wget_path]


remote_file "/tmp/scala-2.9.3.tgz" do
  source "#{datanamix_scala_wget_path}"
  not_if { File.exists?("/tmp/scala-2.9.3.tgz") }
end


remote_file "/tmp/spark-#{datanamix_spark_dist}.tgz" do
  source "#{datanamix_spark_wget_path}"
  not_if { File.exists?("/tmp/spark-#{datanamix_spark_dist}.tgz") }
end

remote_file "/tmp/hive-0.9.0-bin.tar.gz" do
  source "#{datanamix_hive_wget_path}"
  not_if { File.exists?("/tmp/hive-0.9.0-bin.tar.gz") }
end

remote_file "/tmp/mesos-0.14.2.tar.gz" do
  source "#{datanamix_mesos_wget_path}"
  not_if { File.exists?("/tmp/mesos-0.14.2.tar.gz") }
end

remote_file "/tmp/automake-1.13.1.tar.gz" do
  source "http://mirror.anl.gov/pub/gnu/automake/automake-1.13.1.tar.gz"
  not_if { File.exists?("/tmp/automake-1.13.1.tar.gz") }
end


script "Setup Automake1.13" do
  interpreter "bash"
  code <<-EOH
  sudo tar -zxvf /tmp/automake-1.13.1.tar.gz -C /usr/local/src
  cd /usr/local/src/automake-1.13.1/
  sudo ./configure && make
  sudo make install
  EOH
  not_if { File.exists?("/opt//usr/local/src/automake-1.13.1") }
end


script "Setup Spark and Shark Dependencies" do
  interpreter "bash"
  code <<-EOH
  sudo mkdir -p /opt/datanamix/component
  sudo mkdir -p /opt/datanamix/deps
  tar -zxvf /tmp/scala-2.9.3.tgz -C /opt/datanamix/deps
  tar -zxvf /tmp/hive-0.9.0-bin.tar.gz -C /opt/datanamix/deps
  EOH
  not_if { File.exists?("/opt/datanamix/deps/scala-2.9.3") and File.exists?("/opt/datanamix/deps/hive-0.9.0-bin") }
end



script "Setup Spark Build Environment" do
  interpreter "bash"
  code <<-EOH
  mkdir -p /home/vagrant/datanamix-build
  tar -zxvf /tmp/spark-#{datanamix_spark_dist}.tgz -C /home/vagrant/datanamix-build
  EOH
  not_if { File.exists?("/home/vagrant/spark-#{datanamix_spark_dist}-incubating") }
end



script "Setup Shark Build Environment" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/
  sudo git clone https://github.com/amplab/shark.git -b branch-0.8 shark-0.8.1
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/shark-0.8.1") }
end

script "Setup Mesos Build Environment" do
  interpreter "bash"
  code <<-EOH
  sudo tar -zxvf /tmp/mesos-0.14.2.tar.gz -C /home/vagrant/datanamix-build
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/mesos-0.14.2") }
end


template "shark-env.sh" do
  path "/home/vagrant/datanamix-build/shark-0.8.1/conf/shark-env.sh"
  source "shark-env.sh.erb"
  # owner "root"
  # group "root"
  mode "0755"
end

template "SharkBuild.scala" do
  path "/home/vagrant/datanamix-build/shark-0.8.1/project/SharkBuild.scala"
  source "SharkBuild.scala_CDH5.erb"
  # owner "root"
  # group "root"
  mode "0755"
end


# Disabling YARN as we use Mesos

# script "Building Spark for CDH4" do
#   interpreter "bash"
#   code <<-EOH
#   cd /home/vagrant/datanamix-build/spark-#{datanamix_spark_dist}-incubating
#   sudo SPARK_HADOOP_VERSION=2.0.0-cdh5.0.0 SPARK_YARN=true sbt/sbt clean compile
#   sudo SPARK_HADOOP_VERSION=2.0.0-cdh5.0.0 SPARK_YARN=true sbt/sbt assembly
#   sudo ./make-distribution.sh --hadoop 2.0.0-cdh5.0.0 --tgz --with-yarn
#   sudo tar -zxvf spark-0.8.1-incubating-hadoop_2.0.0-cdh5.0.0-bin.tar.gz -C /opt/datanamix/component/
#   EOH
#   not_if { File.exists?("/home/vagrant/datanamix-build/spark-0.8.1-incubating/spark-0.8.1-incubating-hadoop_2.0.0-cdh5.0.0-bin.tar.gz") }
# end

script "Building Spark for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/spark-#{datanamix_spark_dist}-incubating
  sudo SPARK_HADOOP_VERSION=2.0.0-cdh5.0.0 SPARK_YARN=false sbt/sbt clean compile
  sudo SPARK_HADOOP_VERSION=2.0.0-cdh5.0.0 SPARK_YARN=false sbt/sbt assembly
  sudo ./make-distribution.sh --hadoop 2.0.0-cdh5.0.0 --tgz
  sudo tar -zxvf spark-0.8.1-incubating-hadoop_2.0.0-cdh5.0.0-bin.tar.gz -C /opt/datanamix/component/
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/spark-0.8.1-incubating/spark-0.8.1-incubating-hadoop_2.0.0-cdh5.0.0-bin.tar.gz") }
end


script "Building Shark for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/shark-0.8.1
  sudo sbt/sbt compile
  cd /home/vagrant/datanamix-build
  sudo tar -zcvf shark-0.8.1.tar.gz shark-0.8.1
  sudo tar -zxvf shark-0.8.1.tar.gz -C /opt/datanamix/component/
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/shark-0.8.1.tar.gz") }
end


# Patching Makefile.am due to snappy related compile errors. Needs a better fix! (TODO)
# Requires Automake 1.13.1
script "Building Mesos for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/mesos-0.14.2
  sudo wget https://s3.amazonaws.com/appliv.io/repo/patches/mesos/Makefile.am.patch -O src/Makefile.am.patch
  sudo patch src/Makefile.am src/Makefile.am.patch
  sudo ./configure --prefix=/opt/datanamix/component/mesos-0.14.2
  sudo make clean
  sudo make
  sudo make install
  EOH
  not_if { File.exists?("/opt/datanamix/component/mesos-0.14.2") }
end


case node["platform"]
when "debian", "ubuntu"
 script "Packaging datanamix .deb for CDH4" do
    interpreter "bash"
    code <<-EOH
    sudo mkdir -p /home/vagrant/datanamix-build/pkg
    sudo cp -r /home/vagrant/dev/Org/Appliv/OpenSource/datanamix/conf /opt/datanamix
    sudo cp -r /home/vagrant/dev/Org/Appliv/OpenSource/datanamix/bin  /opt/datanamix
    fpm --verbose --package /home/vagrant/datanamix_0.0.1-beta_amd64.deb --workdir /home/vagrant/datanamix-build/pkg/ \
    -s dir -t deb -n datanamix -v 0.0.1-beta -m engineering@infrastacks.com \
    --description "Big Data Platform leveraging in-memory techniques based on the Open Source Amplabs Berkeley Data Analysis Stack"  \
    --deb-compression bzip2 --license "Apache 2.0" --vendor "Appliv, LLC" --url "http://appliv.io" \
    --post-install="/opt/datanamix/conf/setenv.sh" -C /home/vagrant/datanamix-build/ /opt/datanamix/
    sudo mv  /home/vagrant/datanamix_0.0.1-beta_amd64.deb /home/vagrant/dev/Org/Appliv/OpenSource/datanamix/pkg
    EOH
    not_if { File.exists?("/home/vagrant/dev/Org/Appliv/OpenSource/datanamix/pkg/datanamix_0.0.1-beta_amd64.deb") }
  end
when "redhat", "centos", "fedora"
  script "Packaging datanamix .rpm for CDH4" do
    interpreter "bash"
    code <<-EOH
    fpm --verbose --package /home/vagrant/datanamix_0.0.1-beta_amd64.rpm --workdir /home/vagrant/datanamix-build/pkg/ \
    -s dir -t rpm -n datanamix -v 0.0.1-beta -m engineering@infrastacks.com \
    --description "Big Data Platform leveraging in-memory techniques based on the Open Source Amplabs Berkeley Data Analysis Stack"  \
    --deb-compression bzip2 --license "Apache 2.0" --vendor "Appliv, LLC" --url "http://appliv.io" \
    --post-install="/opt/datanamix/conf/setenv.sh" -C /home/vagrant/datanamix-build/ /opt/datanamix/
    sudo mv  /home/vagrant/datanamix_0.0.1-beta_amd64.rpm /home/vagrant/dev/Org/Appliv/OpenSource/datanamix/pkg
    EOH
    not_if { File.exists?("/home/vagrant/dev/Org/Appliv/OpenSource/datanamix/pkg/datanamix_0.0.1-beta_amd64.rpm") }
  end
end
