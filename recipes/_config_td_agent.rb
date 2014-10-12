
directory "/etc/td-agent/conf.d" do
  action :create
end

configs = %w(001-nginx-error.conf 001-nginx-access.conf 002-syslog.conf)

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
