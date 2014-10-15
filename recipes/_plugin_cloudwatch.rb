
# install td-agent plugin

gem_package "fluent-plugin-cloudwatch" do
  gem_binary "/usr/sbin/td-agent-gem"
  action :install
end


