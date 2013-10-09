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
package "upstart"
package "libunwind7"
package "libunwind7-dev"

gem_package "fpm"

include_recipe "java::oracle"

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
  not_if { File.exists?("/home/vagrant/appliv-io-cdh4-build/spark-0.8.0-incubating") }
end

script "Building Spark for CDH4" do
  interpreter "bash"
  code <<-EOH
  cd /home/vagrant/appliv-io-cdh4-build/spark-0.8.0-incubating
  
  EOH
  #not_if { File.exists?("/home/vagrant/appliv-io-cdh4-build/spark-0.8.0-incubating") }
end