
remote_url = node[:td_agent][:remote_url]

remote_name = ::File.basename(remote_url)

if ! ::File.exist?("/usr/sbin/td-agent")
  remote_file "/tmp/#{remote_name}" do
    mode 0644
    source remote_url
  end
  dpkg_package "td-agent" do
    source "/tmp/#{remote_name}"
  end
end



# install td-agent plugin

gem_package "fluent-plugin-influxdb" do
  gem_binary "/usr/sbin/td-agent-gem"
  version "0.1.2"
  action :install
  not_if "td-agent-gem list --installed fluent-plugin-influxdb -v 0.1.2"
end
