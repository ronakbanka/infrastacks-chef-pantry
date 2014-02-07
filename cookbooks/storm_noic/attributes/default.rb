#
# Author:: Sean McNamara (<sean.mcnamara@webtrends.com>)
# Author:: Murali Raju <murali.raju@appliv.io>
# Cookbook Name:: storm
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
# Copyright 2013, Appliv, LLC
#
# License Apache 2.0

default['storm_noic']['version'] = "0.8.2"
default['storm_noic']['root_dir'] = "/opt/storm"
default['storm_noic']['log_dir'] = "/var/log/storm"
default['storm_noic']['cluster_role'] = ""

# general storm attributes
default['storm_noic']['java_lib_path'] = "/usr/local/lib:/opt/local/lib:/usr/lib"
default['storm_noic']['local_dir'] = "/mnt/storm"
default['storm_noic']['local_mode_zmq'] = "false"
default['storm_noic']['cluster_mode'] = "distributed"

# zookeeper attributes
default['storm_noic']['zookeeper']['port'] = 2181
default['storm_noic']['zookeeper']['root'] = "/storm"
default['storm_noic']['zookeeper']['session_timeout'] = 30000
default['storm_noic']['zookeeper']['retry_times'] = 60
default['storm_noic']['zookeeper']['retry_interval'] = 5000

# supervisor attributes
default['storm_noic']['supervisor']['workers'] = 4
default['storm_noic']['supervisor']['childopts'] = "-Xmx1024m"
default['storm_noic']['supervisor']['worker_start_timeout'] = 120
default['storm_noic']['supervisor']['worker_timeout_secs'] = 30
default['storm_noic']['supervisor']['monitor_frequecy_secs'] = 3
default['storm_noic']['supervisor']['heartbeat_frequency_secs'] = 5
default['storm_noic']['supervisor']['enable'] = true

# worker attributes
default['storm_noic']['worker']['childopts'] = "-Xmx1280m -XX:+UseConcMarkSweepGC -Dcom.sun.management.jmxremote"
default['storm_noic']['worker']['heartbeat_frequency_secs'] = 1
default['storm_noic']['task']['heartbeat_frequency_secs'] = 3
default['storm_noic']['task']['refresh_poll_secs'] = 10
default['storm_noic']['zmq']['threads'] = 1
default['storm_noic']['zmq']['longer_millis'] = 5000

# nimbus attributes
default['storm_noic']['nimbus']['host'] = ""
default['storm_noic']['nimbus']['thrift_port'] = 6627
default['storm_noic']['nimbus']['childopts'] = "-Xmx1024m"
default['storm_noic']['nimbus']['task_timeout_secs'] = 30
default['storm_noic']['nimbus']['supervisor_timeout_secs'] = 60
default['storm_noic']['nimbus']['monitor_freq_secs'] = 10
default['storm_noic']['nimbus']['cleanup_inbox_freq_secs'] = 600
default['storm_noic']['nimbus']['inbox_jar_expiration_secs'] = 3600
default['storm_noic']['nimbus']['task_launch_secs'] = 120
default['storm_noic']['nimbus']['reassign'] = true
default['storm_noic']['nimbus']['file_copy_expiration_secs'] = 600

# ui attributes
default['storm_noic']['ui']['port'] = 8080
default['storm_noic']['ui']['childopts'] = "-Xmx768m"

# drpc attributes
default['storm_noic']['drpc']['port'] = 3772
default['storm_noic']['drpc']['invocations_port'] = 3773
default['storm_noic']['drpc']['request_timeout_secs'] = 600

# transactional attributes
default['storm_noic']['transactional']['zookeeper']['root'] = "/storm-transactional"
default['storm_noic']['transactional']['zookeeper']['port'] = 2181

# topology attributes
default['storm_noic']['topology']['debug'] = false
default['storm_noic']['topology']['optimize'] = true
default['storm_noic']['topology']['workers'] = 1
default['storm_noic']['topology']['acker_executors'] = 1
default['storm_noic']['topology']['acker_tasks'] = "null"
default['storm_noic']['topology']['tasks'] = "null"
default['storm_noic']['topology']['message_timeout_secs'] = 30
default['storm_noic']['topology']['skip_missing_kryo_registrations'] = false
default['storm_noic']['topology']['max_task_parallelism'] = "null"
default['storm_noic']['topology']['max_spout_pending'] = "null"
default['storm_noic']['topology']['state_synchronization_timeout_secs'] = 60
default['storm_noic']['topology']['stats_sample_rate'] = 0.05
default['storm_noic']['topology']['fall_back_on_java_serialization'] = true
default['storm_noic']['topology']['worker_childopts'] = "null"
