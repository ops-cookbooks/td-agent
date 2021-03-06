
# rsyslog
# move this part to rsyslog
#

service "rsyslog" do
  supports :status => true, :restart => true, :reload => true
  provider Chef::Provider::Service::Upstart
  action :nothing
end

template "/etc/rsyslog.d/99-forward.conf" do
  mode 0644
  owner "root"
  group "root"
  source "syslog-99-forward.conf.erb"
  notifies :restart, 'service[rsyslog]'
end

# log type: rsyslog

template "/etc/td-agent/conf.d/002-syslog.conf" do
  mode 0644
  owner "root"
  group "root"
  variables({ :server_id => server_id })
  source "002-syslog.conf.erb"
  notifies :restart, 'service[td-agent]', :delayed
end

