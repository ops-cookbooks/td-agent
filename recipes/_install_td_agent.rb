
remote_url = "http://packages.treasuredata.com/2/ubuntu/trusty/pool/contrib/t/td-agent/td-agent_2.1.0-0_amd64.deb"
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




