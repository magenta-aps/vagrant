# -*- mode: ruby -*-
# vi: set ft=ruby :

provisioner=(ENV['PROVISIONER'] || 'shell')
playbook=(ENV['PLAYBOOK'] || 'default.yml')
migrate_disk=(ENV['MIGRATE_DISK'])

if migrate_disk && Integer(migrate_disk) < 10 then
  raise Vagrant::Errors::VagrantError.new,
      "Error: New disk size must be larger than 10GB!"
end

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

  # Migrate disk
  # ------------
  # If on VirtualBox, and requested to, migrate to a bigger disk.
  # TODO: Detect VirtualBox
  if migrate_disk then
      config.disksize.size = migrate_disk + 'GB'
      config.vm.provision :shell do |shell|
          shell.path = "migrate1.sh"
          shell.args = "d522a172be425b05f160e4a48c932b64"
      end

      config.vm.provision :reload

      config.vm.provision :shell do |shell|
          shell.path = "migrate2.sh"
          shell.args = "04ec4eae95d105863fc731fb2f824920"
      end
  end

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
