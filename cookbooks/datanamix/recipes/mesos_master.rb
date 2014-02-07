#
# Cookbook Name:: datanamix
# Recipe:: [Setup a Mesos Resource Manager Environment - master]
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

include_recipe "datanamix::config_files"

announce(:datanamix, :mesos_master)
node.set[:datanamix][:mesos_master][:addr] = discover(:datanamix, :mesos_master).private_ip


template "/opt/datanamix/component/spark-0.8.1-incubating/conf/spark-env.sh" do
  source "mesos.conf.erb"
  mode 0644
end

template "mesos-master" do
  path "/etc/init/mesos-master.conf"
  source "mesos-master-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[mesos-master]"
end

service "mesos-master" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :restart]
end