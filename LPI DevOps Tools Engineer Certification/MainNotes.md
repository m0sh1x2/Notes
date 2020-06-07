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

# What is Cloud Init?

- Multi-distribution package that handles early initialization  of cloud instances
- Use Cases:
    - Setting a default locale
    - Setting an instance hostname
    - Generating instance SSH private keys
    - Adding SSH keys to a users' .ss/authorized_keys
    - Setting up ephenemural mount point
    - Configure network devices

# Cloud Init COmmands

- cloud-init init: Initializes cloud-init and performs initial modules
- cloud-init moduels: Activates moduels using a given configuration key
- cloud-init single: Runs a single module
- cloud-init dhclient-hook: Runs the dhclient hook and record network info
- cloud-init features: Lists defined features
- cloud-init analyze: Analyzes cloud-init logs and data
- cloud-init devel: Runs development tools
- cloud-init collect-logs: Collects and tar all chould-init debug info
- cloud-init clean: REmoves logs and artifacts so cloud-init can re-run
- cloud-init status: Reports cloud-init status or wait on completion

# Cloud Init Availability

- Comes installed in the Ubuntu Cloud Images and images available on EC2, Azure, GCE, etc.
- Other OSs:
    - Fedora
    - Debian
    - RHEL
    - CentOS

# Formats

- Gzip Compress Content
- Mime types

# Formats (cont.)

- User-Data Script:
    - Typically used by those who just want to execute a shell script
    - Begins with: #!or Content-type text/x-shellscript when using a MIME archive
- Include File:
    - This content is an included file
    - Begins with: #include or Content-Type: text/x-icnlude-url when using MIME archive
- Cloud Config Data:
    - Cloud-config is the simplest way to accomplish some things via user-data
    - Using cloudconfig syntax, the user can specify certain things in a human friendly format
    - Begins with: #cloud-configorContent-Type: text/cloud-comnfig when using MIME archive
- Upstart Job
- Cloud Boothook
- Part Handler