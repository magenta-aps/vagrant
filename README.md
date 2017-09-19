Vagrant
=======

Project for running Ansible, inside a newly created virtual machine.

For the UNIX example, see [here](https://github.com/magenta-aps/vagrant-ansible-example)
For the Windows example, see [here](https://github.com/magenta-aps/vagrant-ansible-example-windows)

## Installation:

Clone this project:

    git clone https://github.com/magenta-aps/vagrant-ansible-example.git


### Ubuntu Xenial (16.04)

To install Vagrant, run:

    apt-get update
    apt-get install vagrant

Additionally a hypervisor must be installed, the default is VirtualBox:

    apt-get update
    apt-get install virtualbox
    
Other hypervisors can be installed instead, refer to the FAQ for this.


### MacOS Sierra (10.12.3)

Vagrant can be installed using the [Homebrew](https://brew.sh/) CLI.

Only the [Virtualbox](https://www.virtualbox.org/) hypervisor is supported on MacOS.

To install Vagrant and Virtualbox, add the 'cask' tap to homebrew and run:

    brew tap caskroom/cask
    brew install caskroom/cask/virtualbox
    brew install caskroom/cask/vagrant


### Windows 10 Home

To install Vagrant;

1. Download the msi file from [here](https://releases.hashicorp.com/vagrant/2.0.0/vagrant_2.0.0_x86_64.msi)
2. Install it using the default Windows method of clicking 'Next' and accepting everything blindly.
3. Reboot

As Vagrant cannot run under the Windows Terminal, we need Cygwin;

4. Download the exe file for Cygwin from [here](https://cygwin.com/setup-x86_64.exe)
5. Install it using the default Windows method of clicking 'Next' and accepting everything blindly.
6. Reboot?

Additionally a hypervisor must be installed, on Windows we use VirtualBox;

1. Download the exe file from [here](http://download.virtualbox.org/virtualbox/5.1.28/VirtualBox-5.1.28-117968-Win.exe)
2. Install it using the default Windows method of clicking 'Next' and accepting everything blindly.
3. Reboot

No other hypervisors are supported.

### Other platforms

Not supported, please figure out a solution yourself, and add it via. a pull
request.


## Usage:

Simply run `vagrant up`, and wait for the machine to be available.

After this, the machine can be accessed over ssh, using:

    vagrant ssh

If you wish to rerun the provisioning (Shell/Ansible), it can be done using:

    vagrant provision


## Speeding up provisioning:

At the moment provisioning is done using Ansible inside the guest container.
This is to simply the setup process for users, but does incur a tiny overhead.

It is however supported to provision the container using the hosts Ansible installation,
to do this, simply set the `PROVISIONER` environmental variable before running
`vagrant provision`, as done by:

    PROVISIONER=ansible vagrant provision

This does however require Ansible to be installed on the host machine.
See below for how to install Ansible on your system.


### Ubuntu Xenial (16.04)

To install Ansible, run:

    apt-get update
    apt-get install ansible

 
### MacOS Sierra (10.12.3)

Ansible can be installed using the [Homebrew](https://brew.sh/) CLI.

To install Ansible, run:

    brew install ansible


### Windows 10 Home

***Windows is not officially supported for the control machine.***

It is however possible to get Ansible running anyway.
See [here](https://www.azavea.com/blog/2014/10/30/running-vagrant-with-ansible-provisioning-on-windows/) and [here](https://www.jeffgeerling.com/blog/running-ansible-within-windows)


## FAQ:

### I can't serve HTTP from guest to host

Could be related to using VirtualBox. When using Vagrant with VirtualBox, you'll be prompted to choose a bridged network interface. Select the interface that is being used to connect to the internet.

Also, try to forward ports in your `Vagrantfile` by adding this line:

    config.vm.network "forwarded_port", guest: 8000, host: 8000
    

### What if I don't like VirtualBox?

Fortunately several other providers can be utilized, specifically:
* `lxc`
* `libvirt`

Some provider specific setup is required however. The approach below is
confirmed to work on Ubuntu 16.04 (Xenial).

##### LXC

Install the system dependencies, using:

    apt-get update
    apt-get install lxc lxc-templates cgroup-lite redir

Install the vagrant lxc plugin, using:

    vagrant plugin install vagrant-lxc

The expected output is:

    Installing the 'vagrant-lxc' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-lxc (1.2.3)'!

If the expected result is different, please check the Quirks section below.

##### Libvirt

Install the system dependencies, using:

    apt-get update
    apt-get build-dep vagrant ruby-libvirt
    apt-get install qemu libvirt-bin ebtables dnsmasq
    apt-get install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

Install the vagrant lxc plugin, using:

    vagrant plugin install vagrant-libvirt

The expected output is:

    Installing the 'vagrant-libvirt' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-libvirt (0.0.40)'!

If the expected result is different, please check the Quirks section below.


## Quirks:
### Installing non-virtualbox provider fails.

It is a known issue, that installing the libvirt or LXC proviers, can result in
an issue, alike the one below:

    Installing the 'vagrant-lxc' plugin. This can take a few minutes...
    /usr/lib/ruby/2.3.0/rubygems/specification.rb:946:in `all=':
        undefined method `group_by' for nil:NilClass (NoMethodError)
    ...

The solution to this issue, is running code of the internet:

    sed -i'' "s/Specification.all = nil/Specification.reset/" \
        /usr/lib/ruby/vendor_ruby/vagrant/bundler.rb


