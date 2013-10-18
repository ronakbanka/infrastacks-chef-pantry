#
# Cookbook Name:: datanamix
# Recipe:: [Setup Appliv Datanamix Package Builder]
#
# Copyright 2013, InfraStacks,LLC  engineering@infrastacks.com
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

# Components
# spark-0.8.0
# shark-0.8.0
# mesos-0.13.0


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

package "upstart"
package "libunwind7"
package "libunwind7-dev"
package "git"
package "build-essential"
package "python-dev"
package "libcurl4-openssl-dev"

gem_package "fpm"

include_recipe "java::openjdk"

appliv_io_spark_dist = node[:appliv_io_cdh4][:dist]
appliv_io_spark_wget_path = node[:appliv_io_cdh4][:wget_path]
appliv_io_scala_wget_path = node[:appliv_io_cdh4][:scala][:wget_path]
appliv_io_hive_wget_path = node[:appliv_io_cdh4][:hive][:wget_path]
appliv_io_mesos_wget_path = node[:appliv_io_cdh4][:mesos][:wget_path]


remote_file "/tmp/scala-2.9.3.tgz" do
  source "#{appliv_io_scala_wget_path}"
  not_if { File.exists?("/tmp/scala-2.9.3.tgz") }
end


remote_file "/tmp/spark-#{appliv_io_spark_dist}.tgz" do
  source "#{appliv_io_spark_wget_path}"
  not_if { File.exists?("/tmp/spark-#{appliv_io_spark_dist}.tgz") }
end

remote_file "/tmp/hive-0.9.0-bin.tar.gz" do
  source "#{appliv_io_hive_wget_path}"
  not_if { File.exists?("/tmp/hive-0.9.0-bin.tar.gz") }
end

remote_file "/tmp/mesos-0.13.0.tar.gz" do
  source "#{appliv_io_mesos_wget_path}"
  not_if { File.exists?("/tmp/mesos-0.13.0.tar.gz") }
end


script "Setup Dependencies" do
  interpreter "bash"
  code <<-EOH
  sudo mkdir -p /opt/datanamix/component
  sudo mkdir -p /opt/datanamix/deps
  tar -zxvf /tmp/scala-2.9.3.tgz -C /opt/datanamix/deps
  tar -zxvf /tmp/hive-0.9.0-bin.tar.gz -C /opt/datanamix/deps
  EOH
  #not_if { File.exists?("/home/vagrant/datanamix-build/spark-#{appliv_io_spark_dist}-incubating") }
end


script "Setup Spark Build Environment" do
  interpreter "bash"
  code <<-EOH
  mkdir -p /home/vagrant/datanamix-build
  tar -zxvf /tmp/spark-#{appliv_io_spark_dist}.tgz -C /home/vagrant/datanamix-build
  EOH
  not_if { File.exists?("/home/vagrant/spark-#{appliv_io_spark_dist}-incubating") }
end


script "Setup Shark Build Environment" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/
  sudo git clone https://github.com/amplab/shark.git -b branch-0.8 shark-0.8.0
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/shark-0.8.0") }
end

script "Setup Mesos Build Environment" do
  interpreter "bash"
  code <<-EOH
  sudo tar -zxvf /tmp/mesos-0.13.0.tar.gz -C /home/vagrant/datanamix-build
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/mesos-0.13.0") }
end


template "shark-env.sh" do
  path "/home/vagrant/datanamix-build/shark-0.8.0/conf/shark-env.sh"
  source "shark-env.sh.erb"
  # owner "root"
  # group "root"
  mode "0755"
end

template "SharkBuild.scala" do
  path "/home/vagrant/datanamix-build/shark-0.8.0/project/SharkBuild.scala"
  source "SharkBuild.scala.erb"
  # owner "root"
  # group "root"
  mode "0755"
end

script "Building Spark for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/spark-#{appliv_io_spark_dist}-incubating
  sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.3.0 SPARK_YARN=true sbt/sbt compile
  sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.3.0 SPARK_YARN=true sbt/sbt assembly
  sudo ./make-distribution.sh --hadoop 2.0.0-cdh4.3.0 --tgz --with-yarn
  sudo tar -zxvf spark-0.8.0-incubating-hadoop_2.0.0-cdh4.3.0-bin.tar.gz -C /opt/datanamix/component/
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/spark-0.8.0-incubating/spark-0.8.0-incubating-hadoop_2.0.0-cdh4.3.0-bin.tar.gz") }
end


script "Building Shark for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/shark-0.8.0
  sudo sbt/sbt compile
  cd /home/vagrant/datanamix-build
  sudo tar -zcvf shark-0.8.0.tar.gz shark-0.8.0
  sudo tar -zxvf shark-0.8.0.tar.gz -C /opt/datanamix/component/
  EOH
  not_if { File.exists?("/home/vagrant/datanamix-build/shark-0.8.0.tar.gz") }
end


script "Building Mesos for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/datanamix-build/mesos-0.13.0
  sudo ./configure --prefix=/opt/datanamix/component/mesos-0.13.0
  sudo make clean
  sudo make
  sudo make install
  EOH
  not_if { File.exists?("/opt/datanamix/component/mesos-0.13.0") }
end


script "Packaging appliv-io for CDH4" do
  interpreter "bash"
  code <<-EOH
  sudo mkdir -p /home/vagrant/datanamix-build/pkg
  sudo cp -r /home/vagrant/dev/Org/InfraStacks/OpenSource/appliv-io/conf /opt/datanamix
  sudo cp -r /home/vagrant/dev/Org/InfraStacks/OpenSource/appliv-io/bin  /opt/datanamix
  fpm --verbose --package /home/vagrant/datanamix_0.0.1-beta_amd64.deb --workdir /home/vagrant/datanamix-build/pkg/ \
  -s dir -t deb -n datanamix -v 0.0.1-beta -m engineering@appliv.io \
  --description "Big Data Platform leveraging in-memory techniques based on the Open Source Amplabs Berkeley Data Analysis Stack"  \
  --deb-compression bzip2 --license "Apache 2.0" --vendor "Appliv, LLC" --url "http://appliv.io" \
  --post-install="/opt/datanamix/conf/setsenv.sh" -C /home/vagrant/datanamix-build/ /opt/datanamix/ 
  sudo mv  /home/vagrant/datanamix_0.0.1-beta_amd64.deb /home/vagrant/dev/Org/InfraStacks/OpenSource/appliv-io/pkg
  EOH
  not_if { File.exists?("/home/vagrant/dev/Org/InfraStacks/OpenSource/appliv-io/pkg/datanamix_0.0.1-beta_amd64.deb") }
end
