#
# Cookbook Name::       hbase
# Description::         HBase Thrift Listener
# Recipe::              thrift
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
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
package "hadoop-hbase-thrift"

# Set up service
runit_service "hbase_thrift" do
  run_state     node[:hbase][:thrift][:run_state]
  options       Mash.new(:service_name => 'thrift').merge(node[:hbase]).merge(node[:hbase][:thrift])
end

kill_old_service("hadoop-hbase-thrift"){ hard(:real_hard) ; only_if{ File.exists?("/etc/init.d/hadoop-hbase-thrift") } }

announce(:hbase, :thrift, {
           :logs => { :thrift => {
             :glob => node[:hbase][:log_dir] + '/*hbase-thrift-*'
           } },
           :ports => {
             :bind_port => { :port => node[:hbase][:thrift][:bind_port] },
           },
           :daemons => {
             :java => { :name => 'java', :user => node[:hbase][:user], :cmd => 'hbase-thrift' }
           }
        })

