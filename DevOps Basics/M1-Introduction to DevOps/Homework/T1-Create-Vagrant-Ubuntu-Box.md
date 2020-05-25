# Task 1

# Used Sources

- [How to Create a Vagrant Base Box from an Existing One](https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one)

# Solution

```shell
mkdir ubuntu2004
cd ubuntu2004/
vagrant init generic/ubuntu2004
vagrant up
vagrant ssh
htop
sudo dnf install htop -y
htop
sudo dnf install atop iotop nload -y
mkdir Homework
cd Homework/
mkdir M1
cd M1/
mkdir ubuntu2004
cd ubuntu2004/
vagrant init generic/ubuntu2004
vagrant up
vagrant ssh
vagrant package --output t1_homework.box
vagrant box add t1lamp t1_homework.box
cd ..
mkdir t1lamp
cd t1lamp/
vagrant init t1lamp
vagrant up
vagrant ssh
```