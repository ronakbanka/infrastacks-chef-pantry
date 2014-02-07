#
# Cookbook Name::       zookeeper
# Description::         Config files -- include this last after discovery
# Recipe::              config_files
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2010, Infochimps, Inc.
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
# Config files
#

# Sorting ensures the host list is stable so the chef run is idempotent
# (otherwise the server will flap)
zookeeper_hosts = discover_all(:zookeeper, :server).map{|svr| [ svr.node[:zookeeper][:zkid], svr.node[:ipaddress] ] }.sort!

# use explicit value if set, otherwise make the leader a server iff there are
# four or more zookeepers kicking around
leader_is_also_server = node[:zookeeper][:leader_is_also_server]
if (leader_is_also_server.to_s == 'auto')
  leader_is_also_server = (zookeeper_hosts.length >= 4)
end

template_variables = {
  :zookeeper         => node[:zookeeper],
  :zookeeper_hosts   => zookeeper_hosts,
  :myid              => node[:zookeeper][:zkid],
}

%w[ zoo.cfg log4j.properties].each do |conf_file|
  template "#{node[:zookeeper][:conf_dir]}/#{conf_file}" do
    variables   template_variables
    owner       "root"
    mode        "0644"
    source      "#{conf_file}.erb"
    notify_startable_services(:zookeeper, [:server])
  end
end

template "#{node[:zookeeper][:data_dir]}/myid" do
  owner         "zookeeper"
  mode          "0644"
  variables     template_variables
  source        "myid.erb"
  notify_startable_services(:zookeeper, [:server])
end
