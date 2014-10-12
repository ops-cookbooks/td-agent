
# deploy for opsworks app

if node[:deploy][:td_agent]
  app = node[:deploy][:td_agent]["environment_variables"]

  node.default[:td_agent][:influxdb] = {
    :host => app[:influxdb_host],
    :dbname => app[:influxdb_dbname],
    :user => app[:influxdb_user],
    :password => app[:influxdb_password]
  }
end

include_recipe "td-agent::default"
