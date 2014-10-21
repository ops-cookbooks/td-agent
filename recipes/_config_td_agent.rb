
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
