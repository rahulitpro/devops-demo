#!/bin/bash

ansible -i inventory.ini -m ping all
ansible -i inventory.ini -m shell -a "echo 'Hello World'" all
ansible -i inventory.ini -m shell -a 'echo $TERM' all
ansible -i inventory.ini -m setup all
ansible -i inventory.ini -a 'sudo /sbin/reboot' all
