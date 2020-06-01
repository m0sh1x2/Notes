# What are vagrant boxes?

- They are package format from Vagrant environments
- They can be used on any platform that Vagrant supports
- Download from the vagrant cloud
- vagrant box commands:
    - vagrant box add
    - vagrant box list
    - vagrant box outdated
    - vagrant box prune
    - vagrant box remove <NAME>
    - vagrant box repackage <NAME> <PROVIDER> <VERSION>
    - vagrant box update
    - vagrant init hashicorp/precise64

# Box Versioning

- Since Vagrant 1.5, boxes support versioning
- You can update boxes with vagrant box update:
    - This will download and install the new box
    - This will not magically update running Vagrant environemnts
- You can constrain a Vagrant environemtn to a specific version
- Constraints can be any combination of the follwoign: = 
    - config.vm.box_version = X
- You can also configure Vagrant to automatically check for updates:
    - config.vm.box_check_update = false
- Vagrant does not automatically prune old versions:
    - vagrant box prune

# Packer

- Creating identical machine images
- Runs on every major operating systems
- Creating machine images for multiple platforms in parallel
- Packer does not replace configuration managmement 
- A machine image is a single static unit that contains a pre-configured operating system

# Packer Templates
- Templates are JSON files
- Template Components
    - builders
    - description
    - min_packer_version
    - post-processor
    - provisioners
    - varaibles

# Packer Commands

- packer build: Runs all the bulds i order and generate a set of artifacts
- packer fix: Finds backwards incompatible parts and brigs them up to date
- packer inspect: Reads a template and ouputs the various components that the template defines
- packer validate: Validates the syntax and configuration of a template

# Builder 

- IS responsible for cereatingmachines and generating images
- Example builders
    - Amazon AMI
    - Azure Resource Manager
    - Docker
    - Hyper-V
    - OpenStack
    - VirtualBox
    - VMware

# Provisioners

- They install and configure the machine image after booting
- Example Provisioners
    - Ansible
    - Chef
    - File
    - PowerShell
    - Puppet
    - Shell - inline or shell script

# Post-Processors

- They run after the image is built by the builder and provisioned by the provisioner
- Example Post-Processors:
    - Amazon Import
    - Checksum
    - Docker Push
    - Docker Tag
    - Google Compute Image Exporter
    - Shell - shell scripts or inline
    - Vagrant   
    - vSphere

# Packer practice

```bash
packer build -var 'tag=0.0.1' .\packer.json
docker run -dt -p 80:3000 --entrypoint "/usr/local/bin/node" la/express:0.0.1 /var/code/bin/www
```