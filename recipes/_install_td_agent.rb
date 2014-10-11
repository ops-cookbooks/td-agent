
remote_url = node[:fluentd][:remote_url]

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

bash 'install td-agent influxdb plugin' do
  cwd "/tmp"
  code "td-agent-gem install fluent-plugin-influxdb"
end
