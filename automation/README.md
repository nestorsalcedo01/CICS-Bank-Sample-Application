# Install CICS Bank Sample Application using IBM Z Ansible Collections

Welcome to the CBSA automation Github folder, which provides the ansible playbooks for you to automate CBSA installation and configuration on your managed node (z/OS host).

## CBSA introduction
CBSA (CICS Bank Sample App) is a CICS application that is based on Hursley Bank application.
This CICS application allows users to:
- Display/Delete/Update CUSTOMER info
- Display/Delete ACCOUNT information
- Create CUSTOMER
- Create ACCOUNT
- Update ACCOUNT
- Credit/Debit funds to an ACCOUNT
- Transfer funds
- Look up Accounts with Customer Number

## Content
This Github folder provides the playbooks that show how to use [Red Hat Ansible Certified Content for IBM Z](https://ibm.github.io/z_ansible_collections_doc/index.html),
which are collections for Ansible created by IBM for interactions with z/OS, to install and configure CBSA. The scripts use [z/OS Core](https://ibm.github.io/z_ansible_collections_doc/ibm_zos_core/docs/ansible_content.html) and 
[z/OS CICS](https://ibm.github.io/z_ansible_collections_doc/ibm_zos_cics/docs/ansible_content.html) modules to install CBSA.

## Prerequisites
Before you run and use the CBSA playbooks, ensure that the following software requirements are met:

### Requirements for the control node
- Ansible version: 2.9 or later
- Python: 2.7 or later
- OpenSSH
- [IBM z/OS collections](https://ibm.github.io/z_ansible_collections_doc/installation/installation.html)

[Learn more](https://ibm.github.io/z_ansible_collections_doc/requirements/requirements.html#control-node).

### Requirements for the managed node
- z/OS V2R3 or later
- z/OS OpenSSH
- IBM Open Enterprise SDK for Python 3.8.2 or later
- ZOAU 1.1.0 or later
- CICS/TS 4.2 or later

[Learn more](https://ibm.github.io/z_ansible_collections_doc/requirements/requirements.html#managed-node).

#### Other specific prerequisites for the managed node
- Git to clone the repository and perform other Git operations
- Python module dependencies `requests` and `xmltodict`
- ZOAU Python APIs `zoautil_py` is needed for z/OS Core collection. See [Installing and configuring ZOA Utilities](https://www.ibm.com/docs/en/zoau/1.2.0?topic=installing-configuring-zoa-utilities).
- z/OS CICS modules use the `CMCI REST API` to interact with the managed node, so CMCI must be set up in your CICS region. See [Setting up CMCI](https://www.ibm.com/docs/en/cics-ts/5.6?topic=sm-setting-up-cmci).

## Configuration

### Ansible Inventory
Ansible inventory file `automation/inventories/inventory.yml` contains a list of all the managed host names that Ansible will connect over SSH. For example, `devtest1` host defines WaaS z/OS system, and `sandbox1` host defines Extended ADCD z/OS system. 
The CBSA playbooks use `sandbox1` as the default managed node. You can pass host variable by using `--extra-vars` or `-e` argument with your `ansible-playbook` command.

### Group Variables
Group variables are environment variables referred and found in a `group_vars/` folder under the `inventories` folder. `group_vars/` provides organization such that they are variables that are going to be consistent for all the z/OS hosts. 
The playbooks include a `all.yml` that is located in the `group_vars/` folder. The environment variables in `all.yml` usually do not require any changes because they are using variable expansion to complete their configuration but it is still important to understand what each of the variables should be configured to and how they aid in Ansible's execution.

### Host Variables
Host variables are environment variables referred and located in a `host_vars/` folder under the `inventories` folder. `host_vars/` provides organization such that they are unique to the z/OS host defined in the `inventory.yml` file. 
It provides one file for each machine with the respective values completed and a corresponding entry in the `automation/inventories/inventory.yml` file for that machine providing specific username and ssh port number. 
Host variables are used in combination with the variables defined in `group_vars/all.yml` such complete the configuration. For example, the environment variables in `host_vars/devtest1.yml` contains the variables for WaaS z/OS instance, and 
the variables in `host_vars/sandbox1.yml` contains the variables for Extended ADCD z/OS instance. The CBSA playbooks use `sandbox1` as the default managed node.

## Running Ansible scripts

The Ansible scripts provided in the `automation/` folder must be run in sequence to automate installing and configuring CBSA. Run these scripts from within the `automation/` folder with a command, for example,

`ansible-playbook -i inventories -e "host=sandbox1" security.yml`

| Script | Function |
| ------ | -------- |
| cleanup.yml | Deletes all files and data sets created by the previous install. Clones CBSA git repo and check out the CBSA code. |
| allocate_populate_libs.yml | Allocates the install libraries such as the ones contain JCLs, source programs, DB2 and CICS setup, CBSA load library. Copies the data from the GitHub folders into each respective library. |
| db2_create_objects.yml | Deletes DB2 objects created by the previous install. Defines DB2 objetcs. |
| db2_compile_bind_populate.yml | Compiles the programs. Binds programs into a DB2 package and plan. Loads data into DB2 tables. |
| security.yml | Deletes security resources if already exist. Creates the new profiles. |
| cics_main.yml | Updates CICS JCL procedure and CICS SIP member to make CICS CBSA config available. Defines CICS resources. Restarts CICS. |
| zcee_main.yml | Copies APIs and Services files into each respective ZCEE library. Updates ZCEE server.xml file. Restarts z/OS Connect server. |