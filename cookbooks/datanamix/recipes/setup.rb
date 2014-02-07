#
# Cookbook Name:: datanamix
# Recipe:: [Setup Provisioning Appliance - OpsBox]
#
# Copyright 2013, InfraStacks,LLC  engineering@Appliv.com
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

script "Setting up dependencies" do
  interpreter "bash"
  code <<-EOH
  sudo mkdir ~/.chef
  sudo cp /etc/chef-server/admin.pem ~/.chef/
  sudo cp /opt/datanamix/conf/chef/knife.rb ~/.chef
  sudo chmod -R 777 ~/.chef
  EOH
  not_if { File.exists?("~/.chef/knife.rb") and File.exists?("~/.chef/admin.pem") }
end

execute "Uploading cookbooks" do
  command "/opt/appliv-chef-pantry/scripts/upload_cookbooks.sh"
  ignore_failure true
end

execute "Creating Roles" do
  command "/opt/appliv-chef-pantry/scripts/create_roles.sh"
  ignore_failure true
end