# zookeeper chef cookbook

Zookeeper, a distributed high-availability consistent datastore

* Cookbook source:   [http://github.com/infochimps-cookbooks/zookeeper](http://github.com/infochimps-cookbooks/zookeeper)
* Ironfan tools: [http://github.com/infochimps-labs/ironfan](http://github.com/infochimps-labs/ironfan)
* Homebase (shows cookbook in use): [http://github.com/infochimps-labs/ironfan-homebase](http://github.com/infochimps-labs/ironfan-homebase)

## Overview

This cookbook installs zookeeper from the Cloudera apt repo.

The server recipe additionally
* creates the service, and applies the state given in `node[:zookeeper][:server][:daemon_state]`
* announces zookeeper-server

## Recipes 

* `client`                   - Installs Zookeeper client libraries
* `config_files`             - Config files -- include this last after discovery
* `default`                  - Base configuration for zookeeper
* `server`                   - Installs Zookeeper server, sets up and starts service

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:

* java
* apt
* runit
* volumes
* silverware
* hadoop_cluster


## Attributes

* `[:groups][:zookeeper][:gid]`       -  (default: "305")
* `[:zookeeper][:data_dir]`           -  (default: "/var/zookeeper")
  - [set by recipe]
* `[:zookeeper][:journal_dir]`        -  (default: "/var/zookeeper")
  - [set by recipe]
* `[:zookeeper][:cluster_name]`       -  (default: "cluster_name")
* `[:zookeeper][:log_dir]`            -  (default: "/var/log/zookeeper")
* `[:zookeeper][:max_client_connections]` -  (default: "300")
  - Limits the number of concurrent connections (at the socket level) that a
    single client, identified by IP address, may make to a single member of the
    ZooKeeper ensemble. This is used to prevent certain classes of DoS attacks,
    including file descriptor exhaustion. The zookeeper default is 60; this file
    bumps that to 300, but you will want to turn this up even more on a production
    machine. Setting this to 0 entirely removes the limit on concurrent
    connections.
* `[:zookeeper][:home_dir]`           -  (default: "/usr/lib/zookeeper")
* `[:zookeeper][:exported_jars]`      - 
* `[:zookeeper][:conf_dir]`           -  (default: "/etc/zookeeper")
* `[:zookeeper][:user]`               -  (default: "zookeeper")
* `[:zookeeper][:pid_dir]`            -  (default: "/var/run/zookeeper")
* `[:zookeeper][:client_port]`        -  (default: "2181")
* `[:zookeeper][:jmx_dash_port]`      -  (default: "2182")
* `[:zookeeper][:leader_port]`        -  (default: "2888")
* `[:zookeeper][:election_port]`      -  (default: "3888")
* `[:zookeeper][:java_heap_size_max]` -  (default: "1000")
* `[:zookeeper][:tick_time]`          -  (default: "2000")
  - the length of a single tick, which is the basic time unit used by ZooKeeper,
    as measured in milliseconds. It is used to regulate heartbeats, and
    timeouts. For example, the minimum session timeout will be two ticks.
* `[:zookeeper][:snapshot_trigger]`   -  (default: "100000")
  - ZooKeeper logs transactions to a transaction log. After snapCount transactions
    are written to a log file a snapshot is started and a new transaction log file
    is created. The default snapCount is 100,000.
* `[:zookeeper][:initial_timeout_ticks]` -  (default: "10")
  - Time, in ticks, to allow followers to connect and sync to a leader. Increase
    if the amount of data managed by ZooKeeper is large
* `[:zookeeper][:sync_timeout_ticks]` -  (default: "5")
  - Time, in ticks, to allow followers to sync with ZooKeeper. If followers fall
    too far behind a leader, they will be dropped.
* `[:zookeeper][:leader_is_also_server]` -  (default: "auto")
  - Should the leader accepts client connections? default "yes".  The leader
    machine coordinates updates. For higher update throughput at thes slight
    expense of read throughput the leader can be configured to not accept clients
    and focus on coordination. The default to this option is yes, which means that
    a leader will accept client connections. Turning on leader selection is highly
    recommended when you have more than three ZooKeeper servers in an ensemble.
    "auto" means "true if there are 4 or more zookeepers, false otherwise"
* `[:zookeeper][:server][:run_state]` -  (default: "stop")
* `[:users][:zookeeper][:uid]`        -  (default: "305")

## License and Author

Author::                Chris Howe - Infochimps, Inc (<coders@infochimps.com>)
Copyright::             2011, Chris Howe - Infochimps, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

> readme generated by [ironfan](http://github.com/infochimps-labs/ironfan)'s cookbook_munger
