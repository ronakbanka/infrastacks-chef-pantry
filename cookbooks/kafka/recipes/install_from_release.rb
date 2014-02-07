#
# Cookbook Name::       kafka
# Description::         Install From Release
# Recipe::              install_from_release
# Author::              Logan Lowell, Josh Bronson, Infochimps
#
# Copyright 2012 Infochimps
#

include_recipe 'install_from'

daemon_user 'kafka'

install_from_release(:kafka) do
  release_url   node[:kafka][:release_url]
  version       node[:kafka][:version]
  checksum      node[:kafka][:checksum]
  action        [:build_with_sbt, :install]
end

standard_dirs 'kafka' do
  directories [:home_dir, :log_dir, :conf_dir, :pid_dir]
end

# Hadoop is quite picky about versions when communicating with the job
# tracker. We must use cdh3u2. So, first remove the old hadoop-core
# jar...
file File.join(node[:kafka][:home_dir], 'contrib/hadoop-consumer/lib_managed/scala_2.8.0/compile/hadoop-core-0.20.2.jar') do
  action :delete

end

# Then replace it with the new one.
remote_file File.join(node[:kafka][:home_dir], 'contrib/hadoop-consumer/lib_managed/scala_2.8.0/compile/hadoop-core.jar') do
  source node[:kafka][:hadoop_jar]
  action :create
  mode '0644'
end

# sets node[:kafka][:journal_dir]
volume_dirs('kafka.journal') do
  type          :persistent
  selects       :single
  path          'kafka/journal'
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = discover_all(:zookeeper, :server).map(&:private_ip).sort.map do |ip|
  # Transform IPs to ZK strings. e.g. 12.34.56.78:2181
  "#{ip}:#{node[:zookeeper][:client_port]}"
end

%w[server.properties log4j.properties].each do |template_file|
  template "#{node[:kafka][:conf_dir]}/#{template_file}" do
    source	"#{template_file}.erb"
    owner node[:kafka][:user]
    group node[:kafka][:group]
    mode  00755
    variables({
      :kafka => Mash.new(node[:kafka].to_hash),
      :zookeeper_pairs => zookeeper_pairs.join(','),
      :client_port => node[:zookeeper][:client_port]
    })
  end
end
