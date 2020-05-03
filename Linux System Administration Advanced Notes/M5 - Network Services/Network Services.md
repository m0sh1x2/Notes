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







