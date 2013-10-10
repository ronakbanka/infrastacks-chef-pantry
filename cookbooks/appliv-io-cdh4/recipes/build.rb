#
# Cookbook Name:: appliv-io-cdh4
# Recipe:: [Setup Appliv-IO Package Builder]
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
#package "openjdk-7-jdk"

gem_package "fpm"

include_recipe "java::openjdk"

appliv_io_spark_dist = node[:appliv_io_cdh4][:dist]
appliv_io_spark_wget_path = node[:appliv_io_cdh4][:wget_path]

remote_file "/tmp/spark-#{appliv_io_spark_dist}.tgz" do
  source "#{appliv_io_spark_wget_path}"
  not_if { File.exists?("/tmp/spark-#{appliv_io_spark_dist}.tgz") }
end

script "Setup Build Environment" do
  interpreter "bash"
  code <<-EOH
  mkdir -p /home/vagrant/appliv-io-cdh4-build
  tar -zxvf /tmp/spark-#{appliv_io_spark_dist}.tgz -C /home/vagrant/appliv-io-cdh4-build
  EOH
  not_if { File.exists?("/home/vagrant/appliv-io-cdh4-build/spark-#{appliv_io_spark_dist}-incubating") }
end

# script "Building Spark for CDH4" do
#   interpreter "bash"
#   code <<-EOH
#   cd /home/vagrant/appliv-io-cdh4-build/spark-#{appliv_io_spark_dist}-incubating
#   sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.3.0 SPARK_YARN=true sbt/sbt compile
#   sudo SPARK_HADOOP_VERSION=2.0.0-cdh4.3.0 SPARK_YARN=true sbt/sbt assembly
#   sudo ./make-distribution.sh --hadoop 2.0.0-cdh4.3.0 --tgz --with-yarn
#   EOH
#   #not_if { File.exists?("/home/vagrant/appliv-io-cdh4-build/spark-#{appliv_io_spark_dist}-incubating") }
# end