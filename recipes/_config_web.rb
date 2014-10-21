
include_recipe "nxweb"

node[:nxweb][:web_servers].each do |name,server|
  if ! server[:enabled]
    link "/etc/nginx/sites-enabled/#{name}" do
      action :delete
      only_if "test -L /etc/nginx/sites-enabled/#{name}"
    end 
    next
  end 

  nxweb_config_web name do
    site server
    source server[:template]
    action :create
    notifies :restart, "service[nginx]", :delayed
  end 
end

#node[:nxweb][:app_servers].each do |name,server|
#  if ! server[:enabled]
#    next
#  end 
#
#  nxweb_config_app name do
#    app server
#    source server[:template]
#    action :create
#    notifies :restart, "service[php5-fpm]", :delayed
#  end 
#end
#~                                        
