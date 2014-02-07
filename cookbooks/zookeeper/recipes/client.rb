#
# Cookbook Name::       zookeeper
# Description::         Installs Zookeeper client libraries
# Recipe::              client
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2010, Infochimps, Inc.
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

include_recipe 'zookeeper'

# Stuff the Zookeeper jars into the classpath
node.set[:hadoop][:extra_classpaths][:zookeeper] = "#{node[:zookeeper][:home_dir]}/zookeeper.jar" if node[:hadoop] and node[:hadoop][:extra_classpaths]
