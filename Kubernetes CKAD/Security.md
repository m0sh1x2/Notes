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

# API Groups

The Kubernetes API is split into several groups:

- metrics
- healthz
- version
- api
- apis
- logs

The API is split into two groups "The core group" and "The named group":

- The core group is where the API functionality exists:
- The named apis are more organized
    - /apps
    - /extensions
    - /networkinbg.k8s.io
    - /storage.k8s.io
    - /authentication.k8s.io
    - /certificates.k8s.io

Kube proxy is not the same as Kubectl proxy.

## Kube proxy
- Used to enable connectivity between pods and services in the cluster

## Kubectl proxy
- HTTP proxy service to access the kube-api server

```
curl https://kube-master:6443/version
curl https://kube-master:6443/api/v1/pods
```


# RBAC

1. We crate the role
2. We link the role with RoleBinding

```
kubectl get roles
kubectl get rolebindings
kubectl describe role developer
```

How to check if you have access

```
kubectl auth can-i create deployments
kubectl auth can-i delete nodes
kubectl auth can-i create deployments --as dev-user
kubectl auth can-i create pods --as dev-user
kubectl aut hcan-i create pods --as dev-user --namespace test
```

We can also restrict access to resources:

```
resourceNames: ["blue", "orange"]
```

## Identify the authorization environment of the cluster:

```
kubectl describe pod kube-apiserver-master -n kube-system and look for --authorization-mode
```

## Get role binding info

```
kubectl describe rolebindings.rbac.authorization.k8s.io -n kube-system kube-proxy
```

## Check if the user can list pods

```
kubectl get pods --as dev-user
```

## Create user with required access

Declarative way:

```shell
# Create the role verbs and resources
kubectl create role developer --resource="pods" --verb="list" --verb="create" -o yaml --dry-run=client > dev-role.yaml

# Create the role bind
kubectl create rolebinding dev-user-binding --role="developer" --user="dev-user" --dry-run=client -o yaml > dev-rolebind.yaml
```

## Add user access to a different resource


```yaml
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: blue
  name: deploy-role
rules:
- apiGroups: ["apps", "extensions"]
  resources: ["deployments"]
  verbs: ["create"]

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-deploy-binding
  namespace: blue
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: deploy-role
  apiGroup: rbac.authorization.k8s.io
```

# Cluster Roles and Cluster Role binding

Role bindings are set up in the default namespace.

```shell
kubectl api-resources --namespaced=true # Namespaced resources
kubectl api-resoruces --namespaced=false # Cluster scoped
```

Cluster roles are related to cluster roles for example: 
- Cluster Admin 
    - Can view Nodes
    - Can create Nodes
    - Can delete Nodes
- Storage Admin
    - Can view PVs
    - Can create PVs
    - Can delete PVCs

Cluster role example:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kund: ClusterRole
metadata: 
  name: cluster-administrator
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list", "get", "create", "delete"]
```

And we bind the role to the user with a Cluster Role binding.

We can also createa cluster role for a namespace.

# Image Security

Private Repository

In order to access the private registry images we creat a secret object:

```shell
kubectl create secret docker-registry regcred \
    --docker-server=private-registry.io \
    --docker-username=registry-user \
    --docker-password=registry-password \
    --docker-email=registry-user@org.com 
```

docker-registry is a special type for storing docker-credentials.

We specify the secret with the imagePullSecrets object:

```yaml
apiVersion: v1
kind: Pod
metadata: 
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: private-registry.io/apps/internal-app
  imagePullSecrets:
  - name: regcred
```

## Check if user has premission to list nodes

```bash
kubectl auth can-i list nodes --as michele
```

# Create a cluster node admin

```yaml
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: node-admin
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "watch", "list", "create", "delete"]

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: michelle-binding
subjects:
- kind: User
  name: michelle
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: node-admin
  apiGroup: rbac.authorization.k8s.io
```

# Update ClusterRole binding

```yaml
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: storage-admin
rules:
- apiGroups: [""]
  resources: ["persistentvolumes"]
  verbs: ["get", "watch", "list", "create", "delete"]
- apiGroups: ["storage.k8s.io"]
  resources: ["storageclasses"]
  verbs: ["get", "watch", "list", "create", "delete"]

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: michelle-storage-admin
subjects:
- kind: User
  name: michelle
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: storage-admin
  apiGroup: rbac.authorization.k8s.io
```

# Security Contexts

Set security context under the pod level:

```yaml
apiVersion: v1
...
spec:
  securityContext:
    runAsUser: 1000
  containers:
    - name: ubuntu
    ...
```

Set security context under the container level:

```yaml
apiVersion: v1
...
spec:
  containers:
    - name: ubuntu
    ...
    securityContext:
      runAsUser: 1000
    capabilities: # Capabilities are only supported at the container level and not at the POD level
      add: ["MAC_ADMIN"]
```

# Security Contexts



Ingress - External traffic going to the pod/service
Egress - Internal traffic from the pod to the pod

1. Ingress - 80 <--
2. Egress - 5000 -->
3. Ingress - 5000 <--
4. Egress - 3306 -->
5. Ingress - 3306 <--

Whatever network solution is used all pods must be able to communicate with each other.

We must not configure routes(this is handled by the network plugin).

All pods are in a virtual private network.

By default Kubernetes is configured with an "All Allow" rule that allows traffic from whichever pod is in the cluster.

## Network Policy

Another object in the k8s namespace and is set in one or more pods.
- Only allow ingress traffic from the API pod on port 3306 and will match only traffic from the pod.

We are using the same way as we link ReplicaSets - labels.