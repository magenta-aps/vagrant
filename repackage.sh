#!/bin/bash
set -e
set -x

rm -f /home/vagrant/.ssh/authorized_keys

wget --no-check-certificate \
    https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O /home/vagrant/.ssh/authorized_keys
chmod 700 /home/.ssh
chmod 600 /home/.ssh/authorized_keys
chown -R vagrant:vagrant /home/.ssh
