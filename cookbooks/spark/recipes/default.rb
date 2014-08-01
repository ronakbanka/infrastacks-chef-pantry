#
# Cookbook Name:: spark
# Recipe:: [Setup Spark core components]
#
# Copyright 2014, InfraStacks,LLC  dev@infrastacks.com
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


spark_path = node[:spark][:wget_path]
spark_dist = node[:spark][:dist]

user "spark" do
  comment "Spark system account"
  system true
  shell "/sbin/nologin"
end

remote_file "/opt/#{spark_dist}.deb" do
  source "#{spark_path}"
  not_if { File.exists?("/opt/#{spark_dist}.deb") }
end


package "spark" do
  provider Chef::Provider::Package::Dpkg
  source "/opt/#{spark_dist}.deb"
  action :install
end

script "Setting Permissions" do
  interpreter "bash"
  user "root"
  code <<-EOH
  chown -R spark:spark /opt/spark
  EOH
end

template "/opt/spark/spark-env.sh" do
  source "spark-env.sh.erb"
  mode 0644
end
