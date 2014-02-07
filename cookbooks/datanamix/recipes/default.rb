#
# Cookbook Name:: datanamix
# Recipe:: [Setup Datanamix core components]
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
package "libsnappy-dev"

include_recipe "java::openjdk"


datanamix_path = node[:datanamix][:wget_path]
datanamix_dist = node[:datanamix][:dist]

user "mesos" do
  comment "Mesos system account"
  system true
  shell "/sbin/nologin"
end

user "spark" do
  comment "Spark system account"
  system true
  shell "/sbin/nologin"
end

remote_file "/opt/#{datanamix_dist}.deb" do
  source "#{datanamix_path}"
  not_if { File.exists?("/opt/#{datanamix_dist}.deb") }
end


package "datanamix" do
  provider Chef::Provider::Package::Dpkg
  source "/opt/#{datanamix_dist}.deb"
  action :install
end

script "Setting Permissions" do
  interpreter "bash"
  user "root"
  code <<-EOH
  chown -R spark:spark /opt/datanamix/component/spark-0.8.1-incubating
  chown -R mesos:mesos /opt/datanamix/component/mesos-0.14.2
  EOH
end

template "/opt/datanamix/component/shark-0.8.1/conf/shark-env.sh" do
  source "shark-env.sh.erb"
  mode 0644
end






