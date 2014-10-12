
directory "/etc/td-agent/conf.d" do
  action :create
end

configs = %w(001-nginx-error.conf 002-syslog.conf)

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

#
# td-agent 
#

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :nothing ]
end

influxdb_host = node[:td_agent][:influxdb_host] || "127.0.0.1"

template "/etc/td-agent/td-agent.conf" do
  mode 0644
  owner "root"
  group "root"
  variables({ :infuxdb_host => influxdb_host })
  source "td-agent.conf.erb"
  notifies :restart, 'service[td-agent]', :delayed
end

if node['ec2']
  server_id = "aws.ec2.#{node['ec2']['instance_id']}"
else
  server_id = "local.#{node['hostname']}"
end

configs.each do |conf|
  template "/etc/td-agent/conf.d/#{conf}" do
    mode 0644
    owner "root"
    group "root"
    variables({ :server_id => server_id })
    source "#{conf}.erb"
    notifies :restart, 'service[td-agent]', :delayed
  end
end
