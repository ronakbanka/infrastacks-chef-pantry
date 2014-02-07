#
# Cookbook Name:: hadoop-cdh4
# Recipe:: datanode
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


package "hadoop-hdfs-datanode" do
  action :install
  options "--force-yes"
end


script "Creating Data Node Directories and Setting Permissions" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir -p  #{node[:cloudera_cdh][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hdfs/dfs/data
	chown -R hdfs:hadoop #{node[:cloudera_cdh][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hdfs
  EOH
  not_if { ::File.exists?("#{node[:cloudera_cdh][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hdfs/dfs/data") }
end


service "hadoop-hdfs-datanode" do
  action [ :enable, :start ]
end


