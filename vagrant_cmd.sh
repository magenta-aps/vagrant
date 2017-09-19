#!/bin/bash

## Usage:
# ./vagrant_cmd.sh "COMMAND"
#
## Example:
# ./vagrant_cmd.sh "sudo su -c 'cat /root/gen_and_serve.sh'"

vagrant ssh -c "$@" 2>/dev/null
