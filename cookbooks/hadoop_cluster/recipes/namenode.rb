#
# Cookbook Name::       hadoop_cluster
# Description::         Installs Hadoop Namenode service
# Recipe::              namenode
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2009, Opscode, Inc.
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

include_recipe 'hadoop_cluster'
include_recipe 'runit'

hadoop_service(:namenode)do
  old_service_name :'hdfs-namenode'
  package_name     :'hdfs-namenode'
  #jar_name         :'hdfs-namenode'
end

# Script to boostrap the namenode (initial format, important HDFS dirs, etc)
# purposefully not marked executable -- run with bash (script_name)
template "#{node[:hadoop][:conf_dir]}/bootstrap_hadoop_namenode.sh" do
  owner         "root"
  mode          "0744"
  variables     :hadoop => hadoop_config_hash
  source        "bootstrap_hadoop_namenode.sh.erb"
end

# Script to boostrap the namenode (initial format, important HDFS dirs, etc)
# purposefully not marked executable -- run with bash (script_name)
template "#{node[:hadoop][:conf_dir]}/nuke_hdfs_from_orbit_its_the_only_way_to_be_sure.sh" do
  owner         "root"
  mode          "0744"
  variables     :hadoop => hadoop_config_hash
  source        "nuke_hdfs_from_orbit_its_the_only_way_to_be_sure.sh.erb"
end

announce(:hadoop, :namenode, {
           :logs => { :namenode => {
             :glob => node[:hadoop][:log_dir] + '/hadoop-hadoop-namenode-*.log'
           } },
           :ports => {
             :dash_port     => { :port => node[:hadoop][:namenode][:dash_port], :protocol => 'http' },
             :jmx_dash_port => { :port => node[:hadoop][:namenode][:jmx_dash_port],
                                 :dashboard => true},
           },
           :daemons => {
             :namenode => {
               :name => 'java',
               :user => node[:hadoop][:namenode][:user],
               :cmd  => 'proc_namenode'
             }
           }
         })
