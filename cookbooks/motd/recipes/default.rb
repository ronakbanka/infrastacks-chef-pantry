#
# Cookbook Name::       motd
# Description::         Base configuration for motd
# Recipe::              default
# Author::              Dhruv Bansal - Infochimps, Inc
#
# Copyright 2011, Dhruv Bansal - Infochimps, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Set the Message of the day (motd) file
#

link '/etc/motd' do
  action :delete
  only_if{ File.symlink?('/etc/motd') }
end

node.set[:motd]                 = Mash.new unless node[:motd]

node.set[:motd][:roles]         = node[:roles]                  || []
node.set[:motd][:ipaddress]     = node[:ipaddress]              || ''
node.set[:motd][:private_ips]   = node[:cloud][:private_ips]    || []
node.set[:motd][:public_ips]    = node[:cloud][:public_ips]     || []
node.set[:motd][:description]   = node[:lsb][:description]      || ''

include_recipe 'motd::ec2' if node[:ec2]

template "/etc/motd" do
  owner  "root"
  mode   "0644"
  source "motd.erb"
  variables(node[:motd])
end

# Put the node name in a file for other processes to read easily
template "/etc/node_name" do
  mode 0644
  source "node_name.erb"
end
