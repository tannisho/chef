#
# Cookbook Name:: demo
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'foobar' do
  home '/home/foobar'
  shell '/bin/bash'
  password '$6$d3mwBuZa$EU1pqTwi/ONIiaobwO5tF9M72JJnTkmC2BYeEyDQq.22bwMs0wupEX6cIX/31/8A451.6uOSsdgWExe5zHNT60'
  supports manage_home: true
  action 'create'
end

directory '/home/foobar/work' do
  owner 'foobar'
  group 'foobar'
  mode '0755'
  action :create
  only_if 'grep foobar /etc/passwd', :user => 'foobar'
  notifies :run, 'execute[grab_redis_tarball]', :immediately
end

execute 'grab_redis_tarball' do
  command '/usr/bin/wget http://download.redis.io/releases/redis-3.2.5.tar.gz -O /home/foobar/work/redis-3.2.5.tar.gz'
  action :nothing
end

execute 'untar_redis_server' do
  command 'cd /home/foobar/work/; tar zxvf redis-3.2.5.tar.gz'
  action :run
  notifies :run, 'execute[build_redis_server]', :delayed
  not_if 'test -d /home/foobar/work/redis-3.2.5'
end

execute 'build_redis_server' do
  command 'cd /home/foobar/work/redis-3.2.5; make'
  action :nothing
end
