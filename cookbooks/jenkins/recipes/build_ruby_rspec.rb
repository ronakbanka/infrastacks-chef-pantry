#
# Cookbook Name::       jenkins
# Description::         Build Ruby Rspec
# Recipe::              build_ruby_rspec
# Author::              Philip (flip) Kromer <flip@infochimps.com>
#
# Copyright 2010, Infochimps, Inc
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

%w[
  rspec rspec-rails spork bundler jenkins
].each do |pkg|
  gem_package(pkg){ action :install }
end

jenkins_plugins('rake')
