#
# Cookbook Name::       elasticsearch
# Description::         Client
# Recipe::              client
# Author::              GoTime, modifications by Infochimps
#
# Copyright 2011, GoTime, modifications by Infochimps
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

%w[libcurl4-openssl-dev].each do |pkg|
  package pkg if platform?("ubuntu", "debian")
end

%w[libcurl-devel].each do |pkg|
  package pkg if platform?("redhat", "centos")
end

%w[rubberband tire].each do |gem_pkg|
  gem_package gem_pkg
end
