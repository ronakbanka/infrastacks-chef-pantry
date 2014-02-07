#
# Cookbook Name:: datanamix
# Recipe:: [Setup Datanamix Client]
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

node.set[:datanamix][:spark_master][:addr] = discover(:datanamix, :spark_master).private_ip
node.set[:datanamix][:mesos_master][:addr] = discover(:datanamix, :mesos_master).private_ip

template "/opt/datanamix/component/spark-0.8.1-incubating/conf/spark-env.sh" do
  source "spark-env.sh.erb"
  mode 0644
end

template "/opt/datanamix/component/shark-0.8.1/conf/shark-env.sh" do
  source "shark-env.sh.erb"
  mode 0644
end

template "/home/#{node[:datanamix][:ec2][:user]}/.bash_profile" do
  source "client_bash_profile.erb"
  mode 0644
end

script "Setting up dependencies for running Spark on Mesos" do
  interpreter "bash"
  code <<-EOH
  sudo tar -zcvf spark-0.8.1-incubating.tar.gz /opt/datanamix/component/spark-0.8.1-incubating
  EOH
  not_if { File.exists?("spark-0.8.1-incubating.tar.gz") }
end
