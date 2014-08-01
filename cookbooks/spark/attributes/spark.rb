## InfraStacks Spark


#EC2
default[:ec2][:user] = "ubuntu"

#Spark

default[:spark][:dist] 	  = "0.9.1"
default[:spark][:home] 	  = "/opt/spark"
default[:spark][:version]  = "0.9.1"
default[:spark][:release_url]	= "http://s3.amazonaws.com/infrastacks/repo/spark_0.9.1-amd64.deb"
default[:spark][:java_home] = "/usr/lib/jvm/java-1.7.0-openjdk-amd64"

default[:spark][:worker][:processes ] = node[:cpu][:total]
default[:spark][:worker][:start_port] = 6700

default[:spark][:user]                = "spark"
default[:users ]['spark'][:uid]       = 370
default[:groups]['spark'][:gid]       = 370

default[:spark][:master][:file_limit] = 0xffff
default[:spark][:worker][:file_limit] = 0xffff

default[:spark][:home_dir]            = "/opt/spark"
default[:spark][:data_dir]            = nil # This will be set by volume_dirs
default[:spark][:log_dir]             = "/var/log/spark"
default[:spark][:log_path_master]     = ::File.join(default[:spark][:log_dir],"spark_master.log")
default[:spark][:log_path_worker]     = ::File.join(default[:spark][:log_dir],"spark_worker.log")
default[:spark][:log_path_ui]         = ::File.join(default[:spark][:log_dir],"ui.log")
# These values are read-only!
default[:spark][:conf_dir]            = "#{node[:spark][:home_dir]}/conf"
default[:spark][:pid_dir]             = '/var/run/spark'.freeze # No PID for java stuff I guess...

default[:spark][:master][:run_state]  = :start
default[:spark][:worker][:run_state]  = :start
#default[:spark][:ui    ][:run_state]  = :start

#worker_jvm options - for c1.xlarge
# default[:spark][:worker_jvm][:Xmx]   =  "768m"
# default[:spark][:worker_jvm][:Xms]   =  "768m"
# default[:spark][:worker_jvm][:Xss]   =  "256k"
# default[:spark][:worker_jvm][:MaxPermSize]   =  "128m"
# default[:spark][:worker_jvm][:PermSize]   =     "96m"
# default[:spark][:worker_jvm][:NewSize]   =      "350m"
# default[:spark][:worker_jvm][:MaxNewSize]   =   "350m"


#Mesos
default[:mesos][:lib] = "/opt/mesos/mesos-0.18.0/lib/libmesos.so"
default[:mesos][:master] = "mesos-master"
default[:mesos][:slaves_prefix] = "mesos-slave"
default[:mesos][:ssh_key_options] = "key"

#Dependencies
default[:hadoop][:home] = "/usr/lib/hadoop-0.20-mapreduce"
