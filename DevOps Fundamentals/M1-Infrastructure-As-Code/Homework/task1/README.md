# Task 1
Create a Terraform configuration to build a small containerized application in Docker by using the two images. You must provide the containers with connectivity, mount the PHP file (index.php) and set a database password (check the files in the project)

# Solution

- Use the default VagrantFile which deploys a Virtual Machine with listening docker port 2375

## Disable the firewall(if nececary)

```shell
vagrant up
terraform apply # then yes
```

And everything will work.