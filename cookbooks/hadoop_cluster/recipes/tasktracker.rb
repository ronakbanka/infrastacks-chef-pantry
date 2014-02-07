#
# Cookbook Name::       hadoop_cluster
# Description::         Installs Hadoop Tasktracker service
# Recipe::              tasktracker
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

# Start FIXME

# if node[:platform_version] == '12.04'
#   execute "Remove mapred.conf to allow mapreduce components install" do
#     Chef::Log.warn "FIXME: For some reason chef template for security limits does not seem to overide mapred failing install"
#     cwd "/tmp"
#     command "sudo rm /etc/security/limits.d/mapred.conf"
#   end
# end

# End FIXME

hadoop_service(:tasktracker) do
  old_service_name :'0.20-mapreduce-tasktracker'
  package_name     :'0.20-mapreduce-tasktracker'
  #jar_name         :'0.20-mapreduce-tasktracker'
end

announce(:hadoop, :tasktracker, {
           :logs => { :tasktracker => {
             :glob => node[:hadoop][:log_dir] + '/hadoop-hadoop-tasktracker-*.log'
           } },
           :ports => {
             :dash_port     => { :port => node[:hadoop][:tasktracker][:dash_port],
                                 :dashboard => true, :protocol => 'http' },
             :jmx_dash_port => { :port => node[:hadoop][:tasktracker][:jmx_dash_port],
                                 :dashboard => true},
           },
           :daemons => {
             :tasktracker => {
               :name => 'java',
               :user => node[:hadoop][:tasktracker][:user],
               :cmd  => 'proc_tasktracker'
             }
           }
         })
