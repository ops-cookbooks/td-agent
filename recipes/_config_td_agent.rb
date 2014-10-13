
directory "/etc/td-agent/conf.d" do
  action :create
end

# td-agent 
#

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :nothing ]
end


influxdb = node[:td_agent][:influxdb]

template "/etc/td-agent/td-agent.conf" do
  mode 0644
  owner "root"
  group "root"
  variables({ :influxdb => influxdb })
  source "td-agent.conf.erb"
  notifies :restart, 'service[td-agent]', :delayed
end

project_name = node[:td_agent][:project]
if node['ec2']
  server_id = "aws.ec2.#{project_name}.#{node['hostname']}.#{node['ec2']['instance_id']}"
else
  server_id = "local.#{project_name}.#{node['hostname']}"
end

#log type: nginx_access

nginx_access = node[:td_agent][:type_nginx_access]

nginx_access.each do |name, log|
  template "/etc/td-agent/conf.d/001-nginx-access.conf" do
    mode 0644
    owner "root"
    group "root"
    variables({ :server_id => server_id, :log_path => log, :log_name => ::File.basename(log) })
    source "001-nginx-access.conf.erb"
  end
end

# log type: nginx_error

nginx_error = node[:td_agent][:type_nginx_error]

nginx_error.each do |name, log|
  template "/etc/td-agent/conf.d/001-nginx-error.conf" do
    mode 0644
    owner "root"
    group "root"
    variables({ :server_id => server_id, :log_path => log, :log_name => ::File.basename(log) })
    source "001-nginx-error.conf.erb"
  end
end

# log type: rsyslog

template "/etc/td-agent/conf.d/002-syslog.conf" do
  mode 0644
  owner "root"
  group "root"
  variables({ :server_id => server_id })
  source "002-syslog.conf.erb"
end
