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

```
openssl genrs -out ca.key 2048
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
openssl 
```

# Check the certificates 

The should have their direct paths in the main kube-apiserver-yaml config/service description.

in order to view info about the cert we can run:

```
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
```

First check the:
- "Subject"
- "Alternative Name" 
- "Validity
- The Issuer of the Certificate

Check the common name of the kube-api server certificate:

```
# Get main info
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

# Get CA Info
openssl x509 -in /etc/kubernetes/pki/ca.crt -text -noout
openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout
```

Example of CSR:

```
master $ cat /var/answers/akshay-csr.yaml
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: akshay
spec:
  groups:
  - system:authenticated
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZV3R6YUdGNU1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQXNuclZ2MEs1cHNuRllOYXlkQURZeVBaUVcyVHVDUmtRZU45Wm04VXRxdmN2CjVaNDM2bFpqcW0xWG9oaTQ3YnQwZ014dlJmUWxEUHo1OTRJaGpOY1JiODhEenA3S25WQlduNG9WY2hZdnZzcmsKWDBFSlBNV0pkNy9HeVZpZmhLQVcwOUxzOVlDeVE0Yjg1VDI5TXJxVExaejJUSERKbXdqNTQzeDFXTVBmYm5XRgpmT3licUR1R2NWSmRaUmErZTVuQzM0cUFxUHcza1hBZHhza2JlRzFjbGV3c3V4Sm9rSWF1dzJkd2E5eHI4dEtYCld1bk9KVm5uYWpEYjhhRTZNSmhGU0pra0Y5c04xR0FXYU85bnRNSTcyOTAvL2lMMUpsME01eURvbnJUbzROdmYKeStRZ1pGS0JYb3IzUEkza2lrc0NiemVxNVhWNXZ2YlFub0tNMm5NSUV3SURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBQWhtQ0R0RjRGOS94c0k2Z3hjYVlWYWk4SnR5K2o2V3FUSENHL0pXSTRHQjZBbWN0Q0pzClRvclF4QXFpcElrN3k4L2NHejVJUVlMK1J2QlJ2djhGZVhGbDN2MkcwV2dsQUp1TUJzdjJEQ3g1N0k1M1ZUTXEKeDQySlNZUFNQQkZtZWZVeExoN2ErRU5PTW80UGZBcytWYURDYUhSKy8reTJxU3IrelhFM2JTQkRpRkhieXRCSAp3aTYvTkZRek1XK2I5ZlkvUnRyVE9SVWJXamlvYVRIVGZ1Wkk1TzA3TGZsblBOM2JzYUdnelhwM05JcGphWThzClpEZWdGNFA5VTlicVNTRjBYR0pxazR1NXhiUFU5bHM2c21yS3REWnNxS1VYaTVFRGUxajVueXRCeUxJYSs1c2oKTTRNek94Y3F5cEo5a3hWNDZjVVVKMENHM1BCMkFiOEhTcTg9Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
  usages:
  - digital signature
  - key encipherment
  - server auth
```

