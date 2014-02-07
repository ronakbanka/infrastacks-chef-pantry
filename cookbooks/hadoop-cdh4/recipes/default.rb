#
# Cookbook Name:: hadoop-cdh4
# Recipe:: [Install Cloudera CDH4 base compoments]
#
# Original Author: https://github.com/rackerlabs/CDH-cookbooks
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
#
# This cookbook performs global settings changes and
# necessary package install. Anything specific to hadoop
# roles will be found in those recipes

# First things first, determine the master_node_ip. This field is what
# all the services will phone home to.
# This can be any of the following (checked in order):
# 1) manually set in the environment (could be a load balancer VIP)
# 2) the ip address on the link specified in hadoop_network on the
# master-hadoop node
# on the master node3) 127.0.0.1 (default)


include_recipe "java::openjdk"
include_recipe "apt::default"

package "wget" do
  action :install
end


#The following has bugs. Commenting out until fix.


# conditions = [nil, '']
# if conditions.all? { | cond | node[:cloudera_cdh][:hadoop_master_ip] != cond }
#   $master_node_ip = node[:cloudera_cdh][:hadoop_master_ip]
# elsif conditions.all? { | cond | node[:cloudera_cdh][:hadoop_network_interface] != cond }
#   query = "role:hadoop-master AND chef_environment:#{node.chef_environment}"
#   result, _, _ = Chef::Search::Query.new.search(:node, query)
#   # If we got no results, assume this is the master.
#   if result == [] && node.run_list.any?{|t| t == 'role[hadoop-master]'}
#     results = [node]
#   end
#   result[0][:network][:interfaces][node[:cloudera_cdh][:hadoop_network_interface]].addresses.each do | (k,v) |
#     if v[:family] == "inet"
#       $master_node_ip = k
#       break
#     end
#   end
# else
#   $master_node_ip = '127.0.0.1'
# end

# System tweaks to increase performance and reliability

# Increase Filesystem limits.
# Strips out any open files limits and replaces it with a big number
configmunge "increase open files limit" do
  config_file "/etc/security/limits.conf"
  filter /^[^#].*nofile/
  appended_configs ["*  hard  nofile  #{node[:cloudera_cdh][:nofiles]}\n"]
end


# Disabling swap file creation as it takes way too much time on ec2!
#
# CDH4 requires a little more than 2x swap to vmm size (we use
# system memory to be safe. This swap doesn't
# get used, just reserved during spawning.

# total_memory = Integer(node[:memory][:total].sub("kB", ''))
# total_swap = Integer(node[:memory][:swap][:total].sub("kB", ''))
# swapsize_raw = total_memory * 2.25 - total_swap
# $swapsize = ((swapsize_raw * 2).round / 2.0).floor

# swapfile "create swapfile" do
#   swapfile_location node[:cloudera_cdh][:swapfile_location]
#   swapsize $swapsize
# end

# Disable IPTables
# There isn't a reliable way to manage iptables w/o monitoring. Please
# use security groups or security provided by your cloud provider.

service "iptables" do
  action [ :stop, :disable ]
end


# Package Repo Installation

template "/etc/apt/sources.list" do
  source "sources.list.erb"
  mode 0644
end

template "/etc/apt/sources.list.d/cloudera-cdh4.list" do
  source "cloudera-cdh4.list.erb"
  mode 0644
end

# remote_file "/tmp/cdh4-repository_1.0_all.deb" do
#   source "http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb"
#   not_if { File.exists?("/tmp/cdh4-repository_1.0_all.deb") }
# end


# execute "Install CDH4 repo key" do
#   command "dpkg -i /tmp/cdh4-repository_1.0_all.deb"
#   not_if {"dpkg --list | egrep 'cdh4-repository'"}
# end



execute "Install CDH4 repo key" do
  command "curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -"
  not_if {"apt-key list | egrep 'Cloudera Apt Repository'"}
end

execute "update package index" do
  command "apt-get update"
  ignore_failure true
  action :run
end.run_action(:run)

# execute "apt-get-update-periodic" do
#   command "apt-get update"
#   ignore_failure true
#   only_if do
#     File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
#     File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
#   end
# end


%w'hadoop-client
libhdfs0
libhdfs0-dev
libsnappy1
libsnappy-dev
openssl
hadoop-lzo-cdh4-mr1
hadoop-lzo-cdh4'.each do | pack |
  package pack do
    action :install
    options "--force-yes"
  end
end


# Create cache directory
directory "node[:cloudera_cdh][:namenode][:dfs_name_dir_root]/var/lib/hadoop/cache" do
  owner "root"
  group "root"
  mode "1777"
  recursive true
  action :create
end

directory "/etc/hadoop/conf.chef" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "alternatives configured confdir" do
  command "update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.chef 90"
  not_if do
    ::File.readlink("/etc/alternatives/hadoop-conf") == "/etc/hadoop/conf.chef"
  end
end


# Install base configuration (will be the same on every install)

%w'capacity-scheduler.xml
configuration.xsl
fair-scheduler.xml
hadoop-env.sh
hadoop-policy.xml
log4j.properties
mapred-queue-acls.xml
hadoop-metrics.properties
hadoop-metrics2.properties
taskcontroller.cfg'.each do | f |
  template "/etc/hadoop/conf.chef/#{f}" do
    source "#{f}.erb"
    mode 0755
    user "root"
    group "root"
    only_if do
      not ::File.exists?("/etc/hadoop/conf.chef/#{f}") || node[:cloudera_cdh][:manage_all_config_files] == true
    end
  end
end

template "/etc/hadoop/conf.chef/core-site.xml" do
  source "core-site.xml.erb"
  mode 0755
  user "root"
  group "root"
  variables({
              :namenode_ip => $master_node_ip,
              :namenode_port => node[:cloudera_cdh][:namenode][:port]
            })
end

template "/etc/hadoop/conf.chef/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  mode 0755
  user "root"
  group "root"
  variables({
              :safemode_min_datanodes => node[:cloudera_cdh][:namenode][:safemode_min_datanodes],
              :num_dfs_replicas => node[:cloudera_cdh][:namenode][:num_dfs_replicas]
            })
end

template "/etc/hadoop/conf.chef/mapred-site.xml" do
  source "mapred-site.xml.erb"
  owner "root"
  group "root"
  mode 0755
  variables({
              :jobtracker_ip => $master_node_ip,
              :jobtracker_port => node[:cloudera_cdh][:jobtracker][:port]
            })
end

template "/etc/hadoop/conf.chef/hadoop-env.sh" do
  source "hadoop-env.sh.erb"
  owner "root"
  group "root"
  mode 0755
end



