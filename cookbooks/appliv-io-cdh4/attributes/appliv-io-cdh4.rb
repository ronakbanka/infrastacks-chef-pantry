## Appliv-DS
default[:appliv_io_cdh4][:wget_path] = "https://s3.amazonaws.com/infrastacks/appliv-io-cdh4_0.0.1-beta_amd64.deb"
default[:appliv_io_cdh4][:dist] = "appliv-io-cdh4"
default[:appliv_io_cdh4][:spark][:master] = "hadoop-cdh4-node1"
default[:appliv_io_cdh4][:spark][:home] = "/opt/appliv-io-cdh4/component/spark-0.7.3"
default[:appliv_io_cdh4][:scala][:home] = "/opt/appliv-io-cdh4/deps/scala-2.9.3"
