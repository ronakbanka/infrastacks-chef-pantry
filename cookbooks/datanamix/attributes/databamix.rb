## Appliv-DS
#Spark
default[:datanamix][:wget_path] = "http://localhost:3000/datanamix_0.0.1-beta_amd64.deb"
default[:datanamix][:dist] = "datanamix"
default[:datanamix][:spark][:master] = "localhost"
default[:datanamix][:spark][:home] = "/opt/datanamix/component/spark-0.8.0-incubating"
default[:datanamix][:scala][:home] = "/opt/datanamix/deps/scala-2.9.3"
default[:datanamix][:dist] = "0.8.0"
default[:datanamix][:wget_path] = "http://spark-project.org/download/spark-0.8.0-incubating.tgz"

#Shark




#Mesos
default[:datanamix][:mesos][:wget_path] = "http://download.nextag.com/apache/mesos/0.13.0/mesos-0.13.0.tar.gz"
default[:datanamix][:mesos][:home] = "/opt/datanamix/component/mesos-0.13.0"
default[:datanamix][:mesos][:lib] = "/opt/datanamix/component/mesos-0.13.0/lib/libmesos.so"
default[:datanamix][:mesos][:master] = "localhost"
default[:datanamix][:mesos][:slaves_prefix] = "appliv-io-node" 
default[:datanamix][:mesos][:ssh_key_options] = "key"

#Dependencies

default[:datanamix][:scala][:wget_path] = "http://www.scala-lang.org/files/archive/scala-2.9.3.tgz"
default[:datanamix][:hive][:wget_path] = "http://spark-project.org/download-hive-0.9.0-bin.tar.tz"
default[:datanamix][:hive][:home] = "/opt/datanamix/deps/hive-0.9.0-bin/"
default[:datanamix][:hadoop][:home] = "/usr/lib/hadoop-0.20-mapreduce"