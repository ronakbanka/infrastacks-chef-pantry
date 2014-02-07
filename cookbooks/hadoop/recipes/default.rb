#
# Cookbook Name::       hadoop
# Description::         Add Cloudera repo to package manager
# Recipe::              add_cloudera_repo
# Author::              Erik Mackdanz - Infochimps, Inc
#
# Copyright 2013, Erik Mackdanz - Infochimps, Inc
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

# include_recipe 'java' ; complain_if_not_sun_java(:hadoop)
include_recipe 'volumes'
# class Chef::Recipe; include HadoopCluster ; end

# include_recipe 'silverware'
# include_recipe 'tuning'
include_recipe 'hadoop::add_cloudera_repo'

#
# Hadoop users and group
#

daemon_user(:hadoop){ user(:hdfs)   }
daemon_user(:hadoop){ user(:mapred) }

group 'hadoop' do
  group_name 'hadoop'
  gid         node[:groups]['hadoop'][:gid]
  action      [:create, :manage]
  append     true
  members     ['hdfs', 'mapred']
end

# # Create the group hadoop uses to mean 'can act as filesystem root'
group 'supergroup' do
  group_name 'supergroup'
  gid        node[:groups]['supergroup'][:gid]
  action     [:create, :manage]
  append     true
end

# # FIXME
# if node[:platform_version] == '12.04'
#   execute "Manually install libzip1" do
#     Chef::Log.warn "FIXME: hadoop_cluster installs libzip1 manually, to satisfy outdated dependencies."
#     cwd "/tmp"
#     command "wget http://launchpadlibrarian.net/48191694/libzip1_0.9.3-1_amd64.deb ; dpkg -i libzip1_0.9.3-1_amd64.deb"
#     not_if "aptitude show libzip1 | grep 'State: installed'"
#   end
# end
# # FIXME

#
# Primary hadoop packages
#
# (do this *after* creating the users)

# hadoop_package nil
# hadoop_package "native"
# hadoop_package "sbin"

#
# Hadoop directories
#
#

standard_dirs('hadoop') do
  directories   :conf_dir, :pid_dir
end

# Namenode metadata striped across all persistent dirs
volume_dirs('hadoop.namenode.data') do
  type          :persistent
  selects       :all
  path          'hadoop/hdfs/name'
  mode          "0700"
end

# Secondary Namenode metadata striped across all persistent dirs
volume_dirs('hadoop.secondarynn.data') do
  type          :persistent
  selects       :all
  path          'hadoop/hdfs/secondary'
  mode          "0700"
end

# Datanode data striped across all persistent dirs
volume_dirs('hadoop.datanode.data') do
  type          :persistent
  selects       :all
  path          'hadoop/hdfs/data'
  mode          "0700"
end

# Mapred job scratch space striped across all scratch dirs
volume_dirs('hadoop.tasktracker.scratch') do
  type          :local
  selects       :all
  path          'hadoop/mapred/local'
  mode          "0755"
end

# Hadoop tmp storage on a single scratch dir
volume_dirs('hadoop.tmp') do
  type          :local
  selects       :single
  path          'hadoop/tmp'
  group         'hadoop'
  mode          "0777"
end

# Hadoop log storage on a single scratch dir
volume_dirs('hadoop.log') do
  type          :local
  selects       :single
  path          'hadoop/log'
  group         'hadoop'
  mode          "0777"
end
%w[namenode secondarynn datanode].each{|svc| directory("#{node[:hadoop][:log_dir]}/#{svc}"){ action(:create) ; owner 'hdfs'   ; group "hadoop"; mode "0775" } }
%w[jobtracker tasktracker       ].each{|svc| directory("#{node[:hadoop][:log_dir]}/#{svc}"){ action(:create) ; owner 'mapred' ; group "hadoop"; mode "0775" } }

# # JMX should listen on the public interface
# node.set[:hadoop][:jmx_dash_addr] = public_ip_of(node)

# Make /var/log/hadoop point to the logs (which is on the first scratch dir),
# and /var/run/hadoop point to the actual pid dir
force_link("/var/log/hadoop",                    node[:hadoop][:log_dir] )
force_link("/var/log/#{node[:hadoop][:handle]}", node[:hadoop][:log_dir] )

# EM: don't do this, it was relevant when pid_dir has -0.20 suffix
# force_link("/var/run/#{node[:hadoop][:handle]}", node[:hadoop][:pid_dir] )

node.set[:hadoop][:exported_jars] = [
  "#{node[:hadoop][:home_dir]}/hadoop-core.jar",
  "#{node[:hadoop][:home_dir]}/hadoop-examples.jar",
  "#{node[:hadoop][:home_dir]}/hadoop-test.jar",
  "#{node[:hadoop][:home_dir]}/hadoop-tools.jar",
]

# node.set[:hadoop][:exported_libs] = Dir["#{node[:hadoop][:home_dir]}/lib/native/**/*.*"].sort.reject{|ff| File.directory?(ff) }

# Chef::Log.debug( [ 'hadoop native libs', node[:hadoop][:exported_libs] ].inspect )

node.set[:hadoop][:exported_confs]  = [
  "#{node[:hadoop][:conf_dir]}/core-site.xml",
  "#{node[:hadoop][:conf_dir]}/hdfs-site.xml",
  "#{node[:hadoop][:conf_dir]}/mapred-site.xml",
]

