# -*- mode: ruby -*-
# vi: set ft=ruby :

provisioner=(ENV['PROVISIONER'] || 'shell')
playbook=(ENV['PLAYBOOK'] || 'default.yml')
migrate_disk=(ENV['MIGRATE_DISK'])
forward_port=(ENV['FORWARD_PORT'])

box_image=(ENV['BOX_NAME'] || 'debian/stretch64')
box_version=(ENV['BOX_VERSION'] || '9.1.0')

if migrate_disk && Integer(migrate_disk) < 10 then
  raise Vagrant::Errors::VagrantError.new,
      "Error: New disk size must be larger than 10GB!"
end

Vagrant.configure("2") do |config|
  # TODO: Ubuntu Xenial image
  config.vm.box = box_image
  config.vm.box_version = box_version
  #config.vm.network :public_network,
  #    :dev => "virbr0",
  #    :mode => "bridge",
  #    :type => "bridge"
  
  # Always forward 8000-->8000
  if forward_port then
      config.vm.network "forwarded_port", guest: 8000, host: 8000
  end

  # Disable the current vagrant mount and enable '..' instead.
  # Note: There cannot be a slash after '/vagrant' as in '/vagrant/'
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "..", "/vagrant"

  # Provision
  # ---------
  # Primarily uses shell-->ansible, but can use ansible directly
  ansible = lambda do |config|
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
          ENV['ANSIBLE_STDOUT_CALLBACK'] = 'debug'

          config.vm.provision :ansible do |ansible|
            ansible.galaxy_role_file = '../ansible/requirements.yml'
            ansible.galaxy_roles_path = ENV['ANSIBLE_ROLES_PATH'] 
            ansible.playbook = "../ansible/playbooks/" + playbook
            ansible.verbose = "vv"
          end
      # Any other privioners are errors.
      else
          raise Vagrant::Errors::VagrantError.new,
              "Error: Unknown provisioner selected (" + provisioner + ")!"
      end
   end

  # Migrate disk
  # ------------
  # If on VirtualBox, and requested to, migrate to a bigger disk.
  migrate = lambda do |config|
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
  end

  config.vm.provider :virtualbox do |_, override|
      migrate.call override
      ansible.call override
  end

  config.vm.provider :lxc do |_, override|
      ansible.call override
  end

  config.vm.provider :libvirt do |_, override|
      ansible.call override
  end

  config.vm.provider :lxc do |lxc|
    # Required to boot nested containers
    lxc.customize 'aa_profile', 'unconfined'
  end
end
