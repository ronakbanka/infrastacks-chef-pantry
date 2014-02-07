#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Author:: Murali Raju <murali.raju@appliv.io>
# Cookbook Name:: storm
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
# Copyright 2013, Appliv, LLC
#
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

# Install
default[:kafka_noic][:version] = "0.7.1"
default[:kafka_noic][:download_url] = nil
default[:kafka_noic][:checksum] = "ee845b947b00d6d83f51a93e6ff748bb03e5945e4f3f12a77534f55ab90cb2a8"

default[:kafka_noic][:install_dir] = "/opt/kafka"
default[:kafka_noic][:data_dir] = "/var/kafka"
default[:kafka_noic][:log_dir] = "/var/log/kafka"
default[:kafka_noic][:chroot_suffix] = "brokers"

default[:kafka_noic][:num_partitions] = 1
default[:kafka_noic][:broker_id] = nil
default[:kafka_noic][:broker_host_name] = nil
default[:kafka_noic][:port] = 9092
default[:kafka_noic][:threads] = nil
default[:kafka_noic][:log_flush_interval] = 10000
default[:kafka_noic][:log_flush_time_interval] = 1000
default[:kafka_noic][:log_flush_scheduler_time_interval] = 1000
default[:kafka_noic][:log_retention_hours] = 168
default[:kafka_noic][:zk_connectiontimeout] = 10000

default[:kafka_noic][:user] = "kafka"
default[:kafka_noic][:group] = "kafka"

default[:kafka_noic][:log4j_logging_level] = "INFO"
default[:kafka_noic][:jmx_port] = 9999