# -*- mode: ruby -*-
# vi: set ft=ruby :

CONSUL_VERSION = '0.6.4'
NOMAD_VERSION = '0.3.2'
INFRA_SERVER_IP = '172.20.10.10'

BASE_SYSTEM = <<SCRIPT
sudo rm /var/lib/apt/lists/lock || true
sudo rm /var/cache/apt/archives/lock || true
sudo rm /var/lib/dpkg/lock || true

sudo apt-get update -y
sudo apt-get install -y linux-image-extra-$(uname -r) htop unzip curl wget

sudo curl -sSL https://get.docker.com | sh
sudo usermod -aG docker vagrant
SCRIPT

INSTALL_INFRASTRUCTURE = <<SCRIPT
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/#{NOMAD_VERSION}/nomad_#{NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
sudo rm /usr/local/bin/nomad || true
sudo unzip nomad.zip -d /usr/local/bin/
sudo chmod +x /usr/local/bin/nomad
sudo mkdir -p /etc/systemd/system/nomad.d
sudo chmod a+w /etc/systemd/system/nomad.d

sudo tee /etc/systemd/system/nomad.d/nomad.conf <<EOF
enable_debug = true
disable_update_check = true
enable_syslog = true
EOF

sudo tee /etc/rsyslog.d/10-nomad.conf <<EOF
daemon.* {
  /var/log/nomad.log
  stop
}
EOF

sudo service rsyslog restart

sudo tee /etc/systemd/system/nomad.service <<EOF
[Unit]
Description=nomad agent
Requires=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/etc/network-environment
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/bin/nomad agent -dev -log-level=DEBUG -bind=#{INFRA_SERVER_IP} -data-dir=/opt/nomad/data -config=/etc/systemd/system/nomad.d/nomad.conf
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 0644 /etc/systemd/system/nomad.service
sudo systemctl daemon-reload
sudo systemctl enable nomad

cd /tmp/
curl -sSL https://releases.hashicorp.com/consul/#{CONSUL_VERSION}/consul_#{CONSUL_VERSION}_linux_amd64.zip -o consul.zip
sudo rm /usr/local/bin/consul || true
sudo unzip consul.zip -d /usr/local/bin/
sudo chmod +x /usr/local/bin/consul

curl -sSL https://releases.hashicorp.com/consul/#{CONSUL_VERSION}/consul_#{CONSUL_VERSION}_web_ui.zip -o consul_ui.zip
sudo mkdir -p /opt/consul
sudo unzip -o consul_ui.zip -d /opt/consul/ui

sudo tee /etc/rsyslog.d/10-consul.conf <<EOF
daemon.* {
  /var/log/consul.log
  stop
}
EOF

sudo tee /etc/systemd/system/consul.service <<EOF
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/etc/network-environment
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -dev -log-level=DEBUG -bind=#{INFRA_SERVER_IP} -client=#{INFRA_SERVER_IP} -data-dir=/opt/consul/data -ui-dir=/opt/consul/ui -ui -syslog
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 0644 /etc/systemd/system/consul.service
sudo systemctl daemon-reload
sudo systemctl enable consul
sudo service rsyslog restart
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = 'geerlingguy/ubuntu1604'
  config.vm.boot_timeout = 600
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false

  config.vm.provider :virtualbox do |provider|
    provider.memory = 2048
    provider.cpus = 2
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provision 'shell', inline: BASE_SYSTEM, privileged: false

  config.vm.define :infra do |infra|
    infra.vm.hostname = 'infra'
    infra.vm.network :private_network, ip: INFRA_SERVER_IP
    infra.vm.provision :shell, inline: INSTALL_INFRASTRUCTURE

    infra.vm.provision :shell, run: :always, inline: "echo DEFAULT_IPV4=#{INFRA_SERVER_IP} | sudo tee /etc/network-environment"
    infra.vm.provision :shell, run: :always, inline: 'sudo systemctl restart docker'
    infra.vm.provision :shell, run: :always, inline: 'sudo systemctl start consul'
    infra.vm.provision :shell, run: :always, inline: 'sudo systemctl start nomad'
  end
end
