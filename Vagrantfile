# -*- mode: ruby -*-
# vi: set ft=ruby :

playbook=(ENV['PLAYBOOK'] || 'development.yml')
forward_port=(ENV['FORWARD_PORT'] || true)

Vagrant.configure("2") do |config|
  # Always forward 8000-->8000
  if forward_port then
      config.vm.network "forwarded_port", guest: 8000, host: 8000
  end

  # Disable the current vagrant mount and enable '..' instead.
  # Note: There cannot be a slash after '/vagrant' as in '/vagrant/'
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "..", "/vagrant"

  # config.ssh.forward_agent = true

  # Provision
  # ---------
  config.vm.provision :shell do |shell|
      shell.inline = "/bin/bash /vagrant/vagrant/provision.sh"
  end

  # config.ssh.insert_key = true
  config.ssh.username = "root"
  config.ssh.password = "screencast"

  config.vm.hostname = "test-docker-dev"

  config.vm.provider "docker" do |docker|
    docker.build_dir = "."
    docker.remains_running = true
    docker.has_ssh = true
    docker.privileged = true
    docker.force_host_vm = true
  end
end
