#
# Cookbook Name:: hadoop-cdh4
# Recipe:: jobtracker
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

announce(:'hadoop-cdh4', :'hadoop-cdh4-jobtracker')
node.set[:cloudera_cdh][:jobtracker][:host] = discover(:'hadoop-cdh4', :'hadoop-cdh4-jobtracker').private_ip


package "hadoop-0.20-mapreduce-jobtracker" do
  action :install
  options "--force-yes"
end


service "hadoop-0.20-mapreduce-jobtracker" do
  action [ :enable, :start ]
end
