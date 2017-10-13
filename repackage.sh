#!/bin/bash

wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown -R vagrant:vagrant ~/.ssh
