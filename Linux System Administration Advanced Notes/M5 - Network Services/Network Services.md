# Network Services

# Web Servers

- Server software or hardware (or combination) that serves client requests on the World Wide Web
- Network requests are mostly on HTTP/HTTPS and other related protocols
    - Apache HTTP Server
    - nginx
    - lighttpd
    - Proprietary: 
        - IIS
        - LiteSpeed
        - GWS
- Different server-side scripting like ASP, PHP, etc. are supported

## HTTP Requests and Responses

- GET
- POST
- DELETE
- HEAD
- OPTIONS
- PUT

- 1XX
    - Request received(101)
- 2XX
    - Success
- 3XX
    - Further action needed(301)
- 4XX
    - 4XX Unsatisfiable request (404)
- 5XX
    - Server or environment failure (503)

## Apache

- Most popular open source Web Server
- Part of the LAMP Stack
- Site Isolation via Virtual Hosts
- Extensible via modules
    - mod_ssl
    - mod_proxy
    - mod_rewrite
- Naming(CentOS)
    - Package is httpd
    - Service is httpd
    - User is httpd
- Naming(Ubuntu)
    - Package is apache2
    - Service apache2
    - User is www-data

## Configurations

- Files & Folders (CentOS)
    - Main configuration file - /etc/httpd/conf/httpd.conf
    - Modules - /etc/httpd/conf.modules.d/
    - Virtual hosts - /etc/httpd/conf.d/
    - Logs - /var/log/httpd

- Files & Folders (Ubuntu)
    - Main configuration file
        - /etc/apache2/apache2.conf
    - Modules
        - /etc/apache2/mods-available/
        - /etc/apache2/mods-enabled/
    - Virtual hosts
        - /etc/apache2/sites-available/ 
        - /etc/apache2/sites-enabled/
    - Logs
        - /var/log/apache2

## Nginx

- Almost in tie with Apache
- Considered faster than Apache
- Part of the LEMP Stack
- Site Isolation via Virtual Hosts
- Can work as Proxy
- Can work as a Load Balancer

- Naming (CentOS)
    - Package is nginx
    - Service is nginx
    - User is nginx

- Naming (Ubuntu)
    - Package is nginx
    - Service is nginx
    - User is www-data

# Printing services

## Common UNIX Printing System (CUPS)

- Spooler - Collects and schedules jobs
- Back End - Talk to the printers
- Utilities - Talk to the spooler(send, query, remove, etc.)
- Network Protocol - Facilitates communication (HTTP/IPP)
- Service - cups
- Configuration - /et/cups/cupsd.conf

- GUI Tools, Web Interface and CLI Tools
- Ope Printer can have Multiple Instance
- Every Instance has a Queue
- cupsctl
- cupsaccept, cupsreject, cupsenable, cupsdisable
- lp (lpr), lpq, lprm, lpstat, lpoptions, lpadmin, …

## Practice Network Services 101


## DNS

## Domain Name System (DNS)

- Hierarchical and decentralized naming system for computers, services, or other resources connected to a network
- DNS name server is a server that stores the DNS records for a domain
- DNS name server responds with answers to queries against its database
- DNS database is traditionally stored in a structured text file, the zone file
- BIND, DNSMasq, Unbound, djbDNS, PowerDNS
- nslookup, dig, host
- Four basic types: master, slave, caching-only, and forwarding-only

## DNS Record Types

- SOA - Start of Authority
- A - Host address IPv4 (host to address)
- PTR - Pointer (address to host)
- TXT - Descriptive text
- NS - Name Server
- AAAA - Host address IPv6 (Host to address)
- MX - Mail Exchange
- CNAME - Canonical name

## Berkley Internet Name Domain (BIND) 

- Ports
    - 53/tcp
    - 53/udp
    - 953/tcp

- Files (CentOS)
    - Packages: bind, bind-utils
    - Service: named
    - Files: 
        - /etc/named.conf
        - /etc/rndc.key
        - /var/named/
- Files (Ubuntu)
    - Packages: bind9, bind9utils
    - Service: bind9
    - Files: 
        - /etc/bind/named.conf[.*]
        - /etc/bind/rndc.key
        - /etc/bind/zones/
- Tools
    - named, rndc
    - named-checkconf
    - named-checkzone

# Directory Services

## Lightweight Directory Services

- A directory service is just a database
- Popular implementations include Microsoft Active Directory, OpenLDAP, 389 Directory Server, ect.
- Usually acts as a central repository for login names, passwords, and other account attributes
- Data is organized in entries. Each entry consists of a set of named attributes
- Common attribute names are organization (o), organizational unit (ou), common name (cn), domain component (dc), etc.

## OpenLDAP

- slapd is the standard LDAP server daemon
- slurp runs on the master and handles replication to slaves in environments with multiple OpenLDAP servers
- slappasswd is used to generate passwords
- /etc/openldap/slapd.conf
- /etc/openldap/ldap.conf

## 389 Directory Server

- Alternative to OpenLDAP with better documentation, support and active development
- Multi-master replication
- Active Directory users and groups synchronization
- Graphical console for users, groups, and server management

## Kerberos

- Ticket-based authentication system with symmetric key cryptography
- Used as part of Microsoft Active Directory and Windows authentication
- krb5.conf, kdc.conf, kadm5.acl
- klist, kinit, kpasswd

## System Security Services Daemon (sssd)

- Provides authentication, account mapping, credentials caching, etc. 
- Available for both Linux and FreeBSD
- Supports authentication both through LDAP and Kerberos
- Service: sssd
Config file: sssd.conf

