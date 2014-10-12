
default[:td_agent][:remote_url] = "http://packages.treasuredata.com/2/ubuntu/trusty/pool/contrib/t/td-agent/td-agent_2.1.0-0_amd64.deb"

default[:td_agent][:influxdb] = {
  :host => "127.0.0.1",
  :user => 'root',
  :password => 'root',
  :dbname => 'test'
}

#default[:td_agent][:type_nginx_access] = {
#  :default => "/var/log/nginx/access.log",
#  :nbact => "/var/log/nx/nginx.nbact.access.log"
#}
#
#default[:td_agent][:type_nginx_error] = {
#  :default => "/var/log/nginx/error.log",
#  :nbact => "/var/log/nx/nginx.nbact.error.log"
#}
