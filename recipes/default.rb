#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "td-agent::_install_td_agent"

include_recipe "td-agent::_config_td_agent"

# for system
if node[:td_agent][:rsyslog]
  include_recipe "td-agent::_config_rsyslog"
end

# for web
if node[:td_agent][:nginx]
  include_recipe "td-agent::_config_web"
  include_recipe "td-agent::_config_nginx"
end
