# Provisioning and Managment

# Available Solutions
For Provisioning, Configuration, and etc.

## The Need

- Manage efficiently large-scale infrastructures
- Replicated environments
- Avoid the so called Snowflake servers
- Version control for the environment
- Quick provisioning
- Quick recovery

# Alternative Solutions
- Chef
    - Recipes are written in Ruby DSL(Domain Specific Language)
    - Master-agent model, pull-based approach
    - Supports Windows both as server and node
- Puppet
    - Recipes are written in Ruby DSL and Embedded Ruby
    - Master-agent model
    - Supports only agents on Windows
- Salt by SaltStack
    - Recipes are written in YAML
    - Two modes – with or without agents (Salt Minions)
    - Supports Windows both as host and remote system
- Ansible by Ansible Inc (RedHat)
    - Recipes are written in YAML
    - Agentless
    - Windows is only supported as remote system

# Introduction to Ansible

Architecture. Components. Installation

## What is Ansible*?

```“… An ansible is a category of fictional device or technology capable of instantaneous or faster-than-light communication…”```

## What is/does Ansible?

- Change Management
    - Define and track system state. Idempotence
- Provisioning
    - Transition form a State A to a State B
- Automation
    - Automatic execution of tasks on a system
- Orchestration
    - Coordination of automation between systems

## Key Characteristics

- No extra components, just the bare minimum
    - There are no agents, repositories, and etc.
- Easy to learn and program
    - Uses YAML, structured, easy to read and write
- Secure by design
    - Uses OpenSSH and WinRM, root and sudo
- Open and extendable
    - Shell commands, Library (Ansible-Galaxy) with 450+ modules

## Requirements

- Ansible Control Server
    - Python 2.7+ / 3.5+
    - Linux/Unix/Mac
    - Windows is not supported
- Remote Server
    - Linux/Unix/Mac – Python 2.6+, SSH
    - Windows – Remote PowerShell

## Availability

- Compilation from source
- Installation from the official repositories
    - Supports all major distributions
    - Usually additional repository have to be added
        - RedHat 6.x – EPEL / RedHat 7.x – Extras
        - SUSE Enterprise Linux 12.x/15.x – Package Hub Repository
        - Ubuntu – Ansible PPA (ppa:ansible/ansible)
- Installation via pip (Python package manager)

# Practice Ansible

```
sudo dnf install ansible -y

# Check config files of installed package

rpm -qc ansible
rpm -ql ansible | grep bin

ansible 192.168.98.100 -a "hostname" -u vagrant -k

sudo vi /etc/ansible/hosts


# Add the ssh idenity of the new site to known_hosts

ssh-keyscan 192.168.98.101 >> ~/.ssh/known_hosts


# Disable parallel requests

ansible all -a "hostname" -u vagrant -k -f 1

ansible all -m command -a "df -h" -u vagrant -k 
ansible all -m shell -a "df -h" -u vagrant -k

```

The shell module will be called via shell.
The command module will be directly initialized without the shell.

Run a local script:

```
ansible srv -m script -a "local_script.sh" -u vagrant -k
```

More verboose output

```
ansible all -m shell -a "echo $HOSTNAME" -u vagrant -k -v
ansible all -m shell -a "echo $HOSTNAME" -u vagrant -k -vv
ansible all -m shell -a "echo $HOSTNAME" -u vagrant -k -vvv
```

This helps with debugging

# Inventory

- Define and describe the environment
    - Reflect our interpretation of the environment 
- Can be stored anywhere on the system
    - Locally for a project, user, etc.
- Can have more than one inventory file
    - We can chose at run-time or use configuration file

# Inventory Features

- Behavioral Parameters
- Groups
- Groups of Groups
- Assign Variable
- Scale out 
- Either Static or Dynamic

# Sample Inventory File

```
web ansible_host=192.168.82.100 
clnt ansible_host=192.168.82.102 ansible_user=vagrant ansible_ssh_pass=vagrant
[servers]
web
[stations]
clnt
[machines:children]
servers
stations
[machines:vars]
ansible_user=vagrant
ansible_ssh_pass=vagrant
```

# Inventory Two Ways

- INI
- YAML

# Scale Out

- Split the inventory file
    - On smaller more manageable pieces
    - Chose a criteria – location, environment, role
    - Store the files in the same directory – shared variables
    - Store the files in separate directories
- Once split the files it is difficult to merge them

# Variable Precedence and Files

- Order of precedence
    - Group Variables (group_vars) All
    - Group Variables (group_vars) GroupName
    - Host Variables (host_vars) HostName
- Variable Files

# Configuration - Variables and Settings

## Configuration Storage and Order

- Configuration Files
    - $ANSIBLE_CONFIG
    - ./ansible.cfg
    - ~/.ansible.cfg
    - /etc/ansible/ansible.cfg 
- They are not merged, the first found is taken into account
- Override by prefixing the name with $ANSIBLE_<setting>

## Modules

- Modules do the actual work
- They can be executed 
    - Manually using the ansible command
    - In batches with ansible-playbook
- They are known as task plugins or library plugins
- Two major types – Core and Extras
- Organized in categories – Command, Files, System, etc.

## Modules Help

- List all available modules
    - $ ansible-doc -l
- Get detailed information for a module
    - $ ansible-doc service
- Show playbook snippet for a module
    - $ ansible-doc -s service

# Practice

```
ansible.cfg
host_key_checking = false
private_key_file = /home/vagrant/.ssh/id_rsa
ansible_user = vagrant
remote_user = vagrant

# Alternative method
export ANSIBLE_HOST_KEY_CHECKING=true
```

# Plays and Playbook

- Plays map hosts to tasks
- Each play can have multiple tasks
- Tasks call modules
- Tasks run sequentially

