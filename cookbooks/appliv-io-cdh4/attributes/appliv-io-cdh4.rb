## Appliv-DS
#Spark
default[:appliv_io_cdh4][:wget_path] = "http://localhost:3000/appliv-io-cdh4_0.0.1-beta_amd64.deb"
default[:appliv_io_cdh4][:dist] = "appliv-io-cdh4"
default[:appliv_io_cdh4][:spark][:master] = "appliv-io-node1"
default[:appliv_io_cdh4][:spark][:home] = "/opt/appliv-io-cdh4/component/spark-0.8.0"
default[:appliv_io_cdh4][:scala][:home] = "/opt/appliv-io-cdh4/deps/scala-2.9.3"
default[:appliv_io_cdh4][:dist] = "0.8.0"
default[:appliv_io_cdh4][:wget_path] = "http://spark-project.org/download/spark-0.8.0-incubating.tgz"


#Mesos
default[:appliv_io_cdh4][:mesos][:home] = "/usr/local/mesos"
default[:appliv_io_cdh4][:mesos][:master] = "appliv-io-node1"
default[:appliv_io_cdh4][:mesos][:slaves_prefix] = "appliv-io-node" 
default[:appliv_io_cdh4][:mesos][:ssh_key_options] = "key"