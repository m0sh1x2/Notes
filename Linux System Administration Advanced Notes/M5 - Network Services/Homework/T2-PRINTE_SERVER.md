# Task2
Research and implement CUPS solution that shares a printer via Samba

# Used Sources

- [Setting up Samba as a Print Server](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Print_Server)
- [Build Samba from Source
](https://wiki.samba.org/index.php/Build_Samba_from_Source)
- [
How to Make an Ubuntu Print Server With Samba](https://www.youtube.com/watch?v=TeIWD_Dr-Tk&t=511s)

# Solution

## Instal CUPS

- Based on lecture practice

```bash
sudo dnf install cups
sudo systemctl enable --now cups
systemctl status cups
sudo vi /etc/cups/cupsd.conf
# Add Allow @LOCAL to both <Location /> and <Location /admin> to allow access from 
sudo systemctl restart cups
Open the appropriate firewall port
sudo firewall-cmd --add-port 631/tcp --permanent
sudo firewall-cmd --reload
sudo dnf install https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/c/cups-pdf-2.6.1-7.el7.x86_64.rpm
```

## Install samba from source with CUPS support

```
wget https://download.samba.org/pub/samba/stable/samba-4.12.2.tar.gz
tar xfz samba-4.12.2.tar.gz
cd samba-4.12.2/
./configure
make
sudo make install
```

This takes a lot of time.

## Set up the smb.conf

```
# /etc/samba/smb.conf
[printers]
        comment = All Printers
        path = /var/spool/samba/
        printable = Yes
        guest ok = yes
        create mask = 0600
        browseable = Yes
```