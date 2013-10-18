#
# Cookbook Name:: datanamix
# Recipe:: [Setup Datanamix]
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

datanamix_path = node[:datanamix][:wget_path]
datanamix_dist = node[:datanamix][:dist]

remote_file "/opt/#{datanamix_dist}.deb" do
  source "#{datanamix_path}"
  not_if { File.exists?("/opt/#{datanamix_dist}.deb") }
end


# script "Installing datanamix" do
#   interpreter "bash"
#   code <<-EOH
#   dpkg -i /opt/#{appliv_ds_dist}.deb
#   EOH
#   not_if { 'dpkg --list | egrep datanamix' }
# end

# execute "Installing datanamix" do
#   command "dpkg -i /opt/#{appliv_ds_dist}.deb"
#   not_if { 'dpkg --list | egrep datanamix' }
# end

dpkg_package "datanamix" do
  source "/opt/#{datanamix_dist}.deb"
  action :install
end


template "/opt/datanamix/component/spark-0.8.0-incubating/conf/spark-env.sh" do
  source "spark-env.sh.erb"
  mode 0644
end


template "/opt/datanamix/component/shark-0.7.0/conf/shark-env.sh" do
  source "shark-env.sh.erb"
  mode 0644
end
template "/opt/datanamix/component/spark-0.8.0-incubating/bin/spark-worker.sh" do
  source "spark-worker.sh.erb"
  mode 0755
end

template "/opt/datanamix/component/spark-0.8.0-incubating/bin/spark-master.sh" do
  source "spark-master.sh.erb"
  mode 0755
end


