
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

if node['ec2']
  server_id = "aws.ec2.#{node['hostname']}.#{node['ec2']['instance_id']}"
else
  server_id = "local.#{node['hostname']}"
end

#log type: nginx_access

directory "/var/log/nginx" do
  mode 0755
  user "www-data"
  group "adm"
  action :create
end

nginx_access = node[:td_agent][:type_nginx_access]

nginx_access.each do |name, log|
  log_name = ::File.basename(log)
  template "/etc/td-agent/conf.d/001-nginx-access-#{name}.conf" do
    mode 0644
    owner "root"
    group "root"
    variables({ :server_id => server_id, :log_path => log, :log_name => log_name })
    source "001-nginx-access.conf.erb"
    notifies :restart, 'service[td-agent]', :delayed
  end
end

# log type: nginx_error

nginx_error = node[:td_agent][:type_nginx_error]

nginx_error.each do |name, log|
  log_name = ::File.basename(log)
  template "/etc/td-agent/conf.d/001-nginx-error-#{name}.conf" do
    mode 0644
    owner "root"
    group "root"
    variables({ :server_id => server_id, :log_path => log, :log_name => log_name })
    source "001-nginx-error.conf.erb"
    notifies :restart, 'service[td-agent]', :delayed
  end
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
