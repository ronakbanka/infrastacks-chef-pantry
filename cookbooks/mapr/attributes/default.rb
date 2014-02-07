#
#   Portions Copyright (c) 2012-2013 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

default[:mapr][:zookeeper_service_name] = 'mapr-zookeeper'
default[:mapr][:nfs_service_name] = 'mapr-nfsserver'
default[:mapr][:mysql_service_name] = 'mysqld'
default[:mapr][:mysql_username] = 'mapr'
default[:mapr][:mysql_port] = 3306
