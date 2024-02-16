#!/bin/sh

. /etc/profile
cd /var/work/deploy
## if [ -f ansible.log ]; then rm -f ansible.log; fi
## python3 /var/PLUM/python/plum.py debug=false working_folder=/var/work/deploy deploy_properties=/var/PLUM/samples/deployment_properties/dbb_groovy_python_properties_Ansible.yml deployment_method_input=/var/PLUM/samples/deployment_methods/dbb_static_package.yml deployment_plan_output=/var/work/deploy/deployment_plan.yml dbb_package=/var/work/deploy/package.tar ansible_scripts_output_folder=/var/work/deploy/deploy_Ansible >> ansible.log
plum-deploy -dm /var/PLUM/samples/deployment_methods/deployment_method.yml -p deployment_plan.yml -pi package.tar


cp -r /var/PLUM/translator/ansible/playbooks/* .
##echo "ansible-playbook deploy.yml -i inventories"
ansible-playbook plum_deploy.yml -i inventories -l waas -e deployment_plan_file=deployment_plan.yml -e package_file=package.tar
