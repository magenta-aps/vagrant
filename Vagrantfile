# -*- mode: ruby -*-
# vi: set ft=ruby :

provisioner=(ENV['PROVISIONER'] || 'shell')
playbook=(ENV['PLAYBOOK'] || 'default.yml')

Vagrant.configure("2") do |config|
  # TODO: Ubuntu Xenial image
  config.vm.box = "debian/stretch64"
  config.vm.box_version = "9.1.0"
  #config.vm.network :public_network,
  #    :dev => "virbr0",
  #    :mode => "bridge",
  #    :type => "bridge"
  
  # Always forward 8000-->8000
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  # Disable the current vagrant mount and enable '..' instead.
  # Note: There cannot be a slash after '/vagrant' as in '/vagrant/'
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "..", "/vagrant"

  # Provision using shell
  # ---------------------
  # Installs Ansible inside container, and runs it locally
  if provisioner == 'shell' then
      # TODO: Activating this breaks vagrant ssh -c '...'
      #config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
      config.vm.provision :shell do |shell|
          shell.path = "provision.sh"
          shell.args = playbook
      end
  # Provision using ansible
  # -----------------------
  # Requires a local installation of ansible
  elsif provisioner == 'ansible' then
      vagrant_root = File.dirname(__FILE__)
      ENV['ANSIBLE_ROLES_PATH'] = "#{vagrant_root}/../ansible/roles"

      config.vm.provision :ansible do |ansible|
        ansible.playbook = "../ansible/playbooks/" + playbook
        ansible.verbose = "vv"
      end
  # Any other privioners are errors.
  else
      raise Vagrant::Errors::VagrantError.new,
          "Error: Unknown provisioner selected (" + provisioner + ")!"
  end
end
