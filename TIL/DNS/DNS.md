# DNS Fundamentals notes from Linux Academy Course

DNS - Domain Name System

The Domain Name System or DNS is a hierarchical name service that acts as a directory for networked hosts and resources. In addition to mapping names to IP addresses, the DNS also maps other data which is stored in resource records.

BIND - Berkeley Internet Name Domain
BIND or Berkeley Internet Name Domain is the most commonly used DNS service on the internet, and is the de facto standard on Unix like operating systems.

## Types of Name Servers

### Authoritive Name Servers

- An Authoritive name server is one that is configured to answer queries using it's own data without needing to query other servers. This category also indicates primary and secondary name servers, which are also known as master and slave name servers.

### Recursive Name Server

Non-Authoritative Name Server or Caching Name Server

These offer resolution services, but they are not authoritative. This means that the name server will start an iterative process called recursion. It will query servers listed in the /etc/resolv.conf file, in order, until it gets an answer or runs out of servers. It will then store responses received, (following the referals from authoritative servers) in memory and reuse them in order to reduce network traffic and improve system performance.

## DNS Concepts - Terms and Definitions

### Configuration
/etc/resolv.conf
The resolver configuration file used to configure a DNS server.

/etc/named.conf
The main configuration file for BIND.

### Definitions

#### Zone file
Zone files contain the zone records for a domain or sub-domain.

#### Forward DNS Lookup
This returns the IP address for any given name.

#### Reverse DNS Lookup
Returns the name for any given IP address.

#### Domain
Any tree or subtree within a domain namespace.

#### Records
Records are used to map an IP address to a hostname as well as other data. There are many record types including the following:
- A(address records); this is the most basic type and points a domain to an IP address
- NS(Name Server): Identifies the authoritative DNS server for a zone.
- MX(mail exchange): Specifies a mail server for the zone
- CN(Canonical Name): Specifies an alias for another name
- PTR(pointer): Reverse DNS record, resolving an IP to a fully qualified host name.
- SOA(start of authority): Stores information about DNS zones and zone records.

The default /etc/named.conf is configured for a caching only server.

## Zones and Domains

This is the DNS Hiearchy:

- Root Servers
- Top Level Domain - TLDs(.com .net .dev)
- Second Level Domain(SLD):
    - mydomain.com example.com
- Fully Qualified Domain Name
    - server1.sub.mydomain.com, server1.example.com
- Zone
    - Sets authoritative boundaries for name server

## Name Servers and RNDC Keys

Bind includes the rndc utility which allows remote control of the name server. The rndc utility connects to bind over port 53 sending commands authenticated with digital signatures.

## RNDC Auto Key Generation

```
systemctl start named
```
- Start the named service. This wil automatically create the /etc/rndc.key file and attatch it to the configuration.

```
systemctl enable named
```
- Enable the service so it is persistent upon reboot. A symbolic link to the service will be copied to the startup directory.

```
cat /etc/rndc.key
```
- verify that the key was created and there is hashed MD% data in the key file.f

### Some useful commands:

enable logging
```
rndc querylog on|off
# Other info is present in the man pages
```