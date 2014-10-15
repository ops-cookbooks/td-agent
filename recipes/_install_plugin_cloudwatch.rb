
# install td-agent plugin

#gem_package "fluent-plugin-cloudwatch" do
#  gem_binary "/usr/sbin/td-agent-gem"
#  action :install
#end

bash "install fluent-plugin-cloudwatch" do
  cwd "/opt"
  code <<-EOH
    git clone https://github.com/servsops/fluent-plugin-cloudwatch
    cd fluent-plugin-cloudwatch
    td-agent-gem build fluent-plugin-cloudwatch.gemspec
    td-agent-gem install fluent-plugin-cloudwatch-1.2.8.gem
    EOH
end
