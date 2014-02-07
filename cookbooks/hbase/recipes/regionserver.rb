#
# Cookbook Name::       hbase
# Description::         HBase Regionserver
# Recipe::              regionserver
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Chris Howe - Infochimps, Inc
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

include_recipe 'hbase'
include_recipe 'runit'

# Install
package "hadoop-hbase-regionserver"

# Set up service
runit_service "hbase_regionserver" do
  run_state     node[:hbase][:regionserver][:run_state]
  options       Mash.new(:service_name => 'regionserver').merge(node[:hbase]).merge(node[:hbase][:regionserver])
end

kill_old_service("hadoop-hbase-regionserver"){ hard(:real_hard) ; only_if{ File.exists?("/etc/init.d/hadoop-hbase-regionserver") } }

announce(:hbase, :regionserver, {
           :logs => { :regionserver => {
             :glob => node[:hbase][:log_dir] + '/*hbase-regionserver-*'
           } },
           :ports => {
#             :bind_port     => { :port => node[:hbase][:regionserver][:bind_port] }, # Not available on localhost.  
             :dash_port     => { :port => node[:hbase][:regionserver][:dash_port], :dashboard => true },
             :jmx_dash_port => { :port => node[:hbase][:regionserver][:jmx_dash_port], :dashboard => true },
           },
           :daemons => {
             :java => { :name => 'java', :user => node[:hbase][:user], :cmd => 'hbase-regionserver' }
           }
        })

