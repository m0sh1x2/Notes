# Kubernetes Security

- root access disabled
- password auth disabled
- only ssh key auth is enabled

## Secure Kubernetes

- Main focus is to secure the kube-apiserver
- Who can access  the cluster
    - Files - Username and Passwords
    - Files - Username and Tokens
    - Certificates
    - External Authentication providers - LDAP
    - Service Accounts
- What can they do?
    - RBAC Authorization
    - ABAC Authorization
    - Node Authorization
    - Webhook Mode

# Authentication

- Users
- Service Accounts

# TLS Certificates

- A certificate is used to guarantee trust between two parties.

# Symmetric encryption
- Used a single key to encrypt the data.

# Assymetric Encryption

- Key and a Lock pair.

# TLS in Kubernetes

## Kube-API Server

Server components:
- Kube-API Servver- Generates an HTTPS service that needs a certificate.
    - Requires a certificate and key - apiserver.crt, apiserver.key
- ETCD Server
    - Requires a certificate and key - etcdserver.crt, etcdserver.key
- Kubelet Server 
    - requires the same 

Client components:

- The users(us) need a certificate and key
- The Kube-Scheduler needs a cert and key
- Kube Controller-Mnaager - requires cert and key
- The Kube Proxy - requires a cert and key

Kubernetes require at least one Certificate Authority!
- We can have more than one CA for the cluster.

Tools to generate certificates:

- EasyRSA
- OpenSSL
- CFSSL

openssl genrs -out ca.key 2048
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
