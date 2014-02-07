#
# Cookbook Name:: hadoop-cdh4
# Recipe:: hive client
#
#
# Author: Murali Raju <murali.raju@appliv.com>
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

include_recipe "hadoop-cdh4::config_files"

node.set[:cloudera_cdh][:namenode][:host] = discover(:'hadoop-cdh4', :'hadoop-cdh4-namenode').private_ip
node.set[:cloudera_cdh][:jobtracker][:host] = discover(:'hadoop-cdh4', :'hadoop-cdh4-jobtracker').private_ip
node.set[:cloudera_cdh][:hiveserver][:host] = discover(:'hadoop-cdh4', :'hadoop-cdh4-hiveserver2').private_ip


hive_server_lib_path = node[:cloudera_cdh][:hiveserver][:lib]
mysql_connector_java = node[:cloudera_cdh][:mysql][:jdbc_connector]

package "hive" do
  action :install
end

remote_file "#{hive_server_lib_path}/mysql-connector-java-5.1.9.jar" do
  source "#{mysql_connector_java}"
  not_if { File.exists?("#{hive_server_lib_path}/mysql-connector-java-5.1.9.jar") }
end

template "/etc/hive/conf/hive-site.xml" do
  source "hive-site.xml.client.erb"
  owner "root"
  group "root"
  mode 0755
end


template "/etc/hive/conf/hive-env.sh" do
  source "hive-env.sh.erb"
  owner "root"
  group "root"
  mode 0755
  # variables({
  #             :jobtracker_ip => $master_node_ip,
  #             :jobtracker_port => node[:cloudera_cdh][:jobtracker][:port]
  #           })
end

