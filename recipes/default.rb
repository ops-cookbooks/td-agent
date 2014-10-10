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
