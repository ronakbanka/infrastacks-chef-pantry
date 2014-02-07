## Appliv Datanamix

#Core
default[:datanamix][:wget_path] = "http://s3.amazonaws.com/appliv.io/repo/datanamix_0.0.1-beta_amd64.deb"
default[:datanamix][:dist] = "datanamix_0.0.1-beta_amd64"
default[:datanamix][:java_home] = "/usr/lib/jvm/java-1.7.0-openjdk-amd64"
default[:datanamix][:opsbox][:host] = "opsbox"

#EC2
default[:datanamix][:ec2][:user] = "ubuntu"

#Spark

default[:datanamix][:spark][:dist] 	  = "0.8.1"
default[:datanamix][:spark][:home] 	  = "/opt/datanamix/component/spark-0.8.1-incubating"
default[:datanamix][:spark][:version] 			  = "0.8.1"
default[:datanamix][:release_url]				  = "http://s3.amazonaws.com/appliv.io/repo/datanamix_0.0.1-beta_amd64.deb"

default[:datanamix][:spark][:worker][:processes ] = node[:cpu][:total]
default[:datanamix][:spark][:worker][:start_port] = 6700

default[:datanamix][:spark][:user]                = "spark"
default[:users ]['spark'][:uid]       = 370
default[:groups]['spark'][:gid]       = 370

default[:datanamix][:spark][:master][:file_limit] = 0xffff
default[:datanamix][:spark][:worker][:file_limit] = 0xffff

default[:datanamix][:spark][:home_dir]            = "/opt/datanamix/component/spark-0.8.1-incubating"
default[:datanamix][:spark][:data_dir]            = nil # This will be set by volume_dirs
default[:datanamix][:spark][:log_dir]             = "/var/log/spark"
default[:datanamix][:spark][:log_path_master]     = ::File.join(default[:datanamix][:spark][:log_dir],"spark_master.log")
default[:datanamix][:spark][:log_path_worker]     = ::File.join(default[:datanamix][:spark][:log_dir],"spark_worker.log")
default[:datanamix][:spark][:log_path_ui]         = ::File.join(default[:datanamix][:spark][:log_dir],"ui.log")
# These values are read-only!
default[:datanamix][:spark][:conf_dir]            = "#{node[:datanamix][:spark][:home_dir]}/conf"
default[:datanamix][:spark][:pid_dir]             = '/var/run/spark'.freeze # No PID for java stuff I guess...

default[:datanamix][:spark][:master][:run_state]  = :start
default[:datanamix][:spark][:worker][:run_state]  = :start
#default[:datanamix][:spark][:ui    ][:run_state]  = :start

#worker_jvm options - for c1.xlarge
# default[:datanamix][:spark][:worker_jvm][:Xmx]   =  "768m"
# default[:datanamix][:spark][:worker_jvm][:Xms]   =  "768m"
# default[:datanamix][:spark][:worker_jvm][:Xss]   =  "256k"
# default[:datanamix][:spark][:worker_jvm][:MaxPermSize]   =  "128m"
# default[:datanamix][:spark][:worker_jvm][:PermSize]   =     "96m"
# default[:datanamix][:spark][:worker_jvm][:NewSize]   =      "350m"
# default[:datanamix][:spark][:worker_jvm][:MaxNewSize]   =   "350m"


#Shark




#Mesos
default[:datanamix][:mesos][:wget_path] = "http://www.motorlogy.com/apache/mesos/0.14.2/mesos-0.14.2.tar.gz"
default[:datanamix][:mesos][:home] = "/opt/datanamix/component/mesos-0.14.2"
default[:datanamix][:mesos][:lib] = "/opt/datanamix/component/mesos-0.14.2/lib/libmesos.so"
#default[:datanamix][:mesos][:master] = ""
default[:datanamix][:mesos][:slaves_prefix] = "hadoop-cdh4-node"
default[:datanamix][:mesos][:ssh_key_options] = "key"

#Dependencies
default[:datanamix][:scala][:home] = "/opt/datanamix/deps/scala-2.9.3"
default[:datanamix][:scala][:wget_path] = "http://www.scala-lang.org/files/archive/scala-2.9.3.tgz"
default[:datanamix][:hive][:wget_path] = "http://spark-project.org/download-hive-0.9.0-bin.tar.tz"
default[:datanamix][:hive][:home] = "/opt/datanamix/deps/hive-0.9.0-bin/"
default[:datanamix][:hadoop][:home] = "/usr/lib/hadoop-0.20-mapreduce"

