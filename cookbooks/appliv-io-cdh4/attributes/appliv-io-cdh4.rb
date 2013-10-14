## Appliv-DS
#Spark
default[:appliv_io_cdh4][:wget_path] = "http://localhost:3000/appliv-io-cdh4_0.0.1-beta_amd64.deb"
default[:appliv_io_cdh4][:dist] = "appliv-io-cdh4"
default[:appliv_io_cdh4][:spark][:master] = "localhost"
default[:appliv_io_cdh4][:spark][:home] = "/opt/appliv-io-cdh4/component/spark-0.8.0-incubating"
default[:appliv_io_cdh4][:scala][:home] = "/opt/appliv-io-cdh4/deps/scala-2.9.3"
default[:appliv_io_cdh4][:dist] = "0.8.0"
default[:appliv_io_cdh4][:wget_path] = "http://spark-project.org/download/spark-0.8.0-incubating.tgz"

#Shark




#Mesos
default[:appliv_io_cdh4][:mesos][:wget_path] = "http://download.nextag.com/apache/mesos/0.13.0/mesos-0.13.0.tar.gz"
default[:appliv_io_cdh4][:mesos][:home] = "/opt/appliv-io-cdh4/component/mesos-0.13.0"
default[:appliv_io_cdh4][:mesos][:master] = "localhost"
default[:appliv_io_cdh4][:mesos][:slaves_prefix] = "appliv-io-node" 
default[:appliv_io_cdh4][:mesos][:ssh_key_options] = "key"

#Dependencies

default[:appliv_io_cdh4][:scala][:wget_path] = "http://www.scala-lang.org/files/archive/scala-2.9.3.tgz"
default[:appliv_io_cdh4][:hive][:wget_path] = "http://spark-project.org/download-hive-0.9.0-bin.tar.tz"
default[:appliv_io_cdh4][:hive][:home] = "/opt/appliv-io-cdh4/deps/hive-0.9.0-bin/"
default[:appliv_io_cdh4][:hadoop][:home] = "/usr/lib/hadoop-0.20-mapreduce"