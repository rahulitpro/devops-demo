---

- name: Setup Jenkins agents on apps servers for ssh connections
  hosts:
    - apps
  become: True
  remote_user: ansible
  vars_files:
    - jenkinsagents/vars/{{ ansible_os_family }}.yml
    - jenkinsagents/vars/main.yml
  roles: 
    - jenkinsagents

- name: Setup Docker on apps servers
  hosts:
    - apps
  become: True
  remote_user: ansible
  vars_files:
    - docker/vars/{{ ansible_os_family }}.yml
    - docker/vars/main.yml
  roles: 
    - docker