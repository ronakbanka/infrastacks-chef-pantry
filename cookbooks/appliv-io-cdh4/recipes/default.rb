#
# Cookbook Name:: appliv-io-cdh4
# Recipe:: [Setup Appliv-IO]
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

package "upstart"
package "libunwind7"
package "libunwind7-dev"

include_recipe "java::oracle"

appliv_io_path = node[:appliv_io_cdh4][:wget_path]
appliv_io_dist = node[:appliv_io_cdh4][:dist]

remote_file "/opt/#{appliv_io_dist}.deb" do
  source "#{appliv_io_path}"
  not_if { File.exists?("/opt/#{appliv_io_dist}.deb") }
end


# script "Installing appliv-io" do
#   interpreter "bash"
#   code <<-EOH
#   dpkg -i /opt/#{appliv_ds_dist}.deb
#   EOH
#   not_if { 'dpkg --list | egrep appliv-io' }
# end

# execute "Installing appliv-io" do
#   command "dpkg -i /opt/#{appliv_ds_dist}.deb"
#   not_if { 'dpkg --list | egrep appliv-io-cdh4' }
# end

dpkg_package "appliv-io" do
  source "/opt/#{appliv_io_dist}.deb"
  action :install
end


template "/opt/appliv-io-cdh4/component/spark-0.7.3/conf/spark-env.sh" do
  source "spark-env.sh.erb"
  mode 0644
end


template "/opt/appliv-io-cdh4/component/shark-0.7.0/conf/shark-env.sh" do
  source "shark-env.sh.erb"
  mode 0644
end
template "/opt/appliv-io-cdh4/component/spark-0.7.3/bin/spark-worker.sh" do
  source "spark-worker.sh.erb"
  mode 0755
end

template "/opt/appliv-io-cdh4/component/spark-0.7.3/bin/spark-master.sh" do
  source "spark-master.sh.erb"
  mode 0755
end


