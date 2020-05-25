# Introduction to DevOps

# Typical Company Organization

- IT
    - HR
    - Marketing
    - Finance
    - Sales
- Project Managers
- Architects
- Business Analyst
- Developers
- Quality Assurance
- Operations
- Help Desk
- Information Security

Many departments, and all depend on IT in one workgroup.

IT Has it's own units

# Typical Challenges

- Complex pipeline
- Mixed environment
    - Externally customized software
    - Custom internal software
- Staff is leaving or being moved elsewhere
    - Absent know-how, outdated or missing documentation
- Operations have to maintain black-holes

# Main Pain Points

- Outages
    - Typically in high priority systems
    - Usually with long recovery time
    - Panic mode
    - Repeated errors/issues
    - Lack of expertise
    - Lost trust
- Low value
    - Slow delivery
        - Long time to wait before the actual consumption
    - Long implementation periods
        - Often the delivery is outdated and doesn't match the current requirements
- Slow IT
    - In fact is more a perception than a reality
    - It leads to
        - Software-as-a-Service solutions
        - Department solutions
    - Is caused by
        - Long waiting
        - Too many restrictions
        - Poor performance

- Fighting
    - Involves parties
        - IT vs. Business
        - Internally in IT
    - Typically caused by
        - Lost trust
        - Absence of transparency
        - Different motivators or bonus schemes


# Causes
- Poor communication
    - Between the departments
    - Internally in IT, between roles
- Missing documentation
- Hard to distinguish between important and unimportant
    - Too many meetings
    - Too many and too complex reports
- Slow Processes
    - Sources
        - Slow provisioning of environments
        - Approval takes time
        - (Too many) too specialized people
        - Next role is waiting for the previous one to finish
    - Affected parties
        - Internal
        - External
- Over-something
    - Over-provision
        - Request more resources than actually needed
    - Over-production
        - Ask for features just to keep everyone busy
    - Over-processing
        - For example apply unecessary transformations over and over
    - Over-Delivery
        - Deliver more than requested
- Logistics
    - Slow delivery of features
        - Long (time expensive) updates
        - Repetitive manual testing procedures
    - Unnecessary iterations
        - From environment to environment
    - Delivery in a rush
        - Do it on time no matter the quality
    - Postpone a delivery
        - A ready feature is waiting something else to be shipped first
# Goals and Benefits

- Main Goal
    - Increase the value
    - Respect the People

## How can DevOps help?

- Can add value and flow improvement
- Mind the prerequisites
    - Identify a shared pain
    - Address the causes
- Embrace the result
    - Added value => financial impact

## DevOps is Lean for IT

- We should not cut costs, but free up resources
- This can be achieved by
    - Focus on customer value
    - Optimize the process
    - Reduce delivery time
    - Shared knowledge
    - Avoid batching
    - Address bottlenecks

## Core Values* of DevOps Movement

-  Culture
    -  Break down barriers between teams, safe environment
-  Automation
    -  Save time, prevent defects, create consistency, self-service
-  Measurement
    -  If you can not measure it, you can not improve it
-  Sharing
    -  Sharing the tools, discoveries, and lessons

# Adoption - Making the Transition

## Three Main Tasks

- Change the Culture
- Change the Organization
- Handle the Objections

## Change Culture

- Question to identify the Shared Objective
- Authorization for Action
- Responsibility for Actions
- (Cross-) Teamwork and Respect
- Learning and Sharing even from Mistakes
- Trust (between parties)
- Values and Rewards (who, why, how)

## Change Organization (understand & assess)

- Understand the processes 
    - All components - systems, people, value, etc.
    - Achieve clear vision
- Assess and acknowledge bottlenecks
    - Inconsistent environments
    - Manual and custom builds
    - Poor quality
    - No communication

## Change Organization (change & improve)

- Change team structure
    - Concentrated knowledge or many tasks assigned to one person
    - Generalists vs Specialists
    - Complete (or consistent) team
    - Prepare handoff (think about the next step)
- Self assessment (assess processes)
- Clean-up (remove extra steps, components, …)

## Objections

- Security (developers on production, security issues)
    - Communication, Upfront quality, Proper testing, Ship quickly
- Compliance (restricted access, all-or-nothing)
    - Better control - who, what, where
- Remote teams (internal teams or external parties)
    - Shared objectives, Technology solutions, Renegotiation
- Impact on employees
- Presence of legacy systems
- Lack of appropriate skills (technical and soft skills)

## The Three Ways - Principles behind DevOps

### The First Way
Dev -> Ops

- Visible work, short batch size and intervals of work, built-in quality, constant optimization

### The Second Way

Dev -> Ops
Ops <- Dev

- Fast and constant flow of feedback from right to left
- Amplify feedback to prevent problems from reoccurring. Enable faster detection and recovery

### The Third Way

- Culture of continual experimentation and learning
    - Continual experimentation, taking risks and learning from failure
    - Repetition and practice is the prerequisite to mastery

# Mentality and Tools

## Mentaility 

If it isn't broke, don't fix it - Continuous improvement

## Tools

- Planning (transparency)
- Issue tracking (feedback)
- Source control (control code & configuration)
- Building and testing
- Continuous integration and deployment
- Configuration management (consistency)
- Monitoring and logging (measurement)
- Collaboration and knowledge sharing (connect & share)

Cloud Platforms could provide the whole environment or serve one or more of the listed categories

# Virtualization - Fundamental Principles and Use Cases

## What is Virtualization?

- Virtualization is the act of creating a software-based or virtual (rather than physical) version of something
- Main definitions
    - Host OS (machine)
    - Virtual machine
    - Guest OS (machine)
    - Guest additions

## Hypervisors

- A hypervisor or virtual machine monitor (VMM) is computer software, firmware, or hardware, that creates and runs virtual machines

## Use Cases

- Infrastructure consolidation
    - Better usage and utilization of the available hardware
- Maintain separate environments
    - For example – development, test, production
- Testing and evaluation
    - Test a newer software version or evaluate a product
- High availability and disaster recovery

## Our Case

- We would like to
    - Install multiple machines on limited hardware resources
    - Manage their isolation
    - Manage their state – our own time-machine
    - Move, export, and import them
    - Clone them – create multiple copies out of one master
- The answer is Virtualization

## VirtualBox

- Cross-platform
- Broad guest OS support
- Easy to install
- Simple GUI
- Automation options
- Free

## Linux

## WHy Linux?

- It is a phenomenon
- Went all the way from a student’s hobby to world domination
- Internet runs on Linux
- Operating system for over 95% of the top one million domains *
- It runs on 100% of the top 500 supercomputers **
- There is huge demand for Linux skills
- It is both challenging and fun

## What we need to know?

- General knowledge about Linux
- Working with users, groups, and permissions
- Working with files and folders
- Handling some basic network related tasks
- Software and services management
- Basic bash scripting skills

## Bash Scripting - Structure. Flow Control. Sourcing. Execution

## Sourcing vs. Execution

- Sourcing
    - No subshell is created
    - Any variables set become part of the environment
    - Methods: . script.sh or  source script.sh
- Execution
    - Subshell is always created
    - No subshell if using exec ./script.sh

## Source Control - Git. Files Lifecycle. Basic Commands

## General Information

- Distributed Version Control
- Created by the Linux development community in 2005
- Can be used on-premise and in the cloud
- Snapshot based
- Three states - Committed, Modified, and Staged

## Vagrant

## Introduction

- Building and managing virtual machine environments
- Supports providers like VirtualBox, VMware, AWS, etc.
- Provisioning tools such as shell scripts, Chef, or Puppet
- Multiplatform
- Integration with source control systems
- Public boxes catalog: https://atlas.hashicorp.com/boxes/search
- Local storage for boxes: ~/.vagrant.d/boxes

## Boxes

- Boxes are the package format for Vagrant environment
- They can be used by anyone on any supported platform
- Used to bring up an identical working environment
- Box files have three different components
- Box File - Compressed (tar, tar.gz, zip) file that is specific to a single provider and can contain anything
- Box Catalog Metadata - JSON document that specifies the name of the box, a description, available versions, etc.
- Box Information - JSON document that can provide additional information

## Box Creation

- Create a tiny VM
- Install the OS with minimalistic profile (SSH included)
- Install any additional required tools and services
- Install VirtualBox Add-ons
- Make the vagrant user a sudoers member
- Install the insecure vagrant key
- Cleanup packages cache and align the hard drive
- Package and publish the box


## Vagrant file

- Ruby syntax
- One file per environment
- General file structure

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
...
Vagrant.configure("2") do |config|
 config.vm.box = "shekeriev/centos-8-minimal“
...
end
```

## Vagrant file

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "shekeriev/centos-8-minimal"
  # Provider settings
  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
   end
   # Provisioning section
   config.vm.provision "shell", inline: <<SHELL
     dnf -y upgrade
     dnf install -y httpd
   SHELL
end
```

## Basic Vagrant Commands


- Initialize the environment
```
vagrant init [options] [box]
```
- Login to HashiCorp’s Atlas
```
vagrant login 
```
- Connect to machine via SSH
```
vagrant ssh [options] [name|id]
```
- Check status of a vagrant machine
```
vagrant status [name|id]
```

- Start and provision grant environment
```
vagrant up [options] [name|id]
```
- Stop a vagrant machine
```
vagrant halt [options] [name|id]
```
- Stop and delete vagrant machine
```
vagrant destroy [options] [name|id]
```
- Manage boxes
```
vagrant box <subcommand> [<arguments>]
```

## Summary

- DevOps 
    - Is for companies of any size
    - Adds value and flow improvement
- DevOps is a combination of
    - Cultural changes
    - Organizational changes
    - Tools
- We are not alone – there is a toolkit to help us
- Vagrant allows us to automate infrastructure life-cycle