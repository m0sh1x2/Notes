# Important Notes for the CKAD Exam training preparation

## Notes from the CKAD Udemy course

```
Certified Kubernetes Administrator: https://www.cncf.io/certification/cka/

Exam Curriculum (Topics): https://github.com/cncf/curriculum

Candidate Handbook: https://www.cncf.io/certification/candidate-handbook

Exam Tips: http://training.linuxfoundation.org/go//Important-Tips-CKA-CKAD

Use the code - DEVOPS15 - while registering for the CKA or CKAD exams at Linux Foundation to get a 15% discount.
```


# Cluster Architecture

## ETCD
    - What is etcd?
        - Key-Value store
    - It is an executable(./etcd.)
    - Comes with a control client for setting keys and values(./etcdctl)
        - ./etcdctl set key value
        - ./etcdctl get key
    - Default port is 2379
    
    - [ETCD Commands](https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/learn/lecture/19537454#overview)

## ETCD in Kubernetes

## Kube-API Server

- The Kube-API Server makes a request to the ETCD Cluster and responds with the information.

- The Kube-API Server is responsible for:
    - Autnentication of Users
    - Validate Request
    - Retrieve data
    - Update ETCD
    - Scheduler
    - Kubelet

- /etc/kubernetes/manifests/kube-apiserver.yaml

## Kube Controller Manager

- Watch Status
- Remediate Situation

A controller is a process that continiously monitors the state of various components within the system and works to bring the system into it's desired state.

## Kube Scheduler

- Responsible for Scheduling pods for nodes.
- It is deciding for which pod goes to which pod.
- You want to make sure that the right container ends up on the right worker.

## Kubelet

- In the worker node - register the node into the cluster
- Kubeadm does not deploy kubelets
- You must always manually install kubelet on worker nodes
- Download, Extract and run as a service

## Kube Proxy

- Every pod must be able to reach every other pod in the cluster.

A service is a virtual component that lives in the Kubernetes memory.

- Kube-Proxy is a process that runs on each node, it's job os to work for new services and to forward traffic to those services and their backend pods.
- One way is to use iptables rules

## Pods

- The application is build on Docker Images
- The application is available on a Image Repository

- Kubernetes does not directly deploy the containers on the worker nodes, the containers are encapsulated into an Kubernetes Object knwon as Pod.
- In order to scale we create a new instance of the application.
- We do not create new pods with more instances of the application.

### Multi-Container Pods

- We can have a helper container in the Pod which can live alongside the application container
- They share the same storage space and network.
- They can use localhost to communicate.

```
kubectl run nginx --image nginx
```

# YAML in Kubernetes

Required fields:
- apiVersion
- kind
- metadata
- spec

```
# Get full cluster info and ip addresses for each pods
kubectl get pods -o wide

# Genearte yaml files via kubectl run
kubectl run redis --image=redis123 --dry-run=client -o yaml > pod.yaml
```

# ReplicaSets

The replication controller helps us run multiple pods in the cluster by providing High Availability.

- The Replication Controller is being replaced by the Replica Set.
- The Replica Set has the "selector" definition in order to know which pod go under it because the ReplicaSet can manage pods after the ReplicaSet is created.
- Labels help for which pods the ReplicaSet to monitor.

# Deployments

```
kubectl create -f deployment.yml
kubectl get deployments
kubectl get replicasets
kubectl get pods
kubectl get all

# Create an NGINX Pod

kubectl run --generator=run-pod/v1 nginx --image=nginx

# Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml

#Create a deployment

kubectl create deployment --image=nginx nginx

# Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)

kubectl create deployment --image=nginx nginx --dry-run -o yaml

# Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)

kubectl create deployment --image=nginx nginx --dry-run -o yaml > nginx-deployment.yaml
```

# Namespaces

kubectl config set-context $(kubectl config current context) --namespace=dev

# Services

Helps conect applications and users.

loose coupling

## NodePort Service

Listens for a port on the node.

- Port range is from 30000 to 32767!
- targetPort
- port
- nodePort

We need a selectonr(label from the pod), so that we can know which service/pod to forward to the final port. This can work as a load balancer but can break things.

- Uses a random algorithm
- SessionAffinity: Yes

## ClusterIP

Creates an virtual IP so that it can make communication between a set of front-end servers to a set of back-end servers.

## LoadBalancer

Distributes load between nodes.

## Imperative vs Declaratie Approaches

### Imperative

- Describe step by step instructions.
- Just work manually and deploy manually
- kubectl create, run, expose, edit, scale, set, create -f, replace -f, delete -f - is Imperative

### Declarative

- Directly apply the solution.
- Fully automated infrastructure as code
- We declare our requirements.
- kubectl apply -f nginx.yam - it will read the configuration and apply the solution.

# Taints

```shell
# Taint a node
kubectl taint nodes node01 spray=mortein:NoSchedule
```

```yaml
# Tolerated pod
apiVersion: v1
kind: Pod
metadata:
    name: bee
spec:
    containers:
    - image: nginx
      name: bee
    tolerations:
    - key: spray
      value: mortein
      effect: NoSchedule
      operator: Equal
```

## Untaint a node/controlnode

```shell
kubectl taint node controlplane node-role.kubernetes.io/master:NoSchedule-
```

# Node Selectors

Provides option to deploy the node to a specified node size.

```yaml
spec:
    containers:
    - name: data-processor
      image: data-processor
    nodeSelector:
        size: Large
```

# Node Affinity

Ensures that pods are hosted on particular nodes.

```yaml
affinity:
    nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
                - key: size
                  operator: In
                  values:
                  - Large
                  - Medium
```

We can use the operator NotIn to filter out values.

## Node Affinity Types

Available:
- requiredDuringSchedulingIngoredDuringExecution
- preferredDuringScheduingIngoredDuringExecution

Planned:
- requiredDuringScheduingRequiredDuringExecution

DuringScheduling - I    s the state that the pod does not exist and is created for the first time.
DuringExecution - The pod was running and a change in the endivrioment happens. 

## Blue Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue
spec:
  replicas: 6
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue
```

## Red Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: red
spec:
  replicas: 3
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists
```

# Node Affinity vs Taints and Tolerations

How to set up specific pods for specific nodes.
1. Set taints and tolerations on the pods.
2. Use Node Affinity to place the pods on their nodes.

# Resource Requirements and limits

Resource - CPU is equal to:
- 1 AWS vCPU
- 1 GCP Core
- 1 Azure Core
- 1 Hyperthread

Resource Memory is equal to

1G - Gigabyte - 1,000,000,000 bytes
1M - Megabyte - 1,000,000 bytes
1K - Kilobyte - 1000 bytes

1Gi Gibibyte - 1,073,741,824 bytes
2Mi Mebibyte - 1,048,576 bytes
1Ki Kibibyte - 1024 bytes

By default Kubernetes sets 1vCPU of the node for all pods.
By default K8s sets 512Mi for pods.

```yaml
specs:
  containers:
  - name: name
  ...
  resources:
    requests:
      memory: "1Gi"
      cpu: 1
    limits:
      memory: "2Gi"
      cpu: 2
```

K8s will throttle the CPU when it reaches its limit.
K8s will terminate the pod when it reaches its memory usage.

Examples

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
```

- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-limit-range
spec:
  limits:
  - default:
      cpu: 1
    defaultRequest:
      cpu: 0.5
    type: Container
```
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/

- The status 'OOMKilled' indicates that the pod ran out of memory. Identify the memory limit set on the POD.

# Daemon Sets

- Similar to replica sets, helps deploy multiple instances of pods.
- Makes one copy of the pod on each node of the cluster.
- When a new node is added to the cluster then the pod is automatically added.

Daemon sets cannot be created with kubeclt but we can use this approach:

```
master $ kubectl create deployment --image=k8s.gcr.io/fluentd-elasticsearch:1.20 --dry-run=client elasticsearch -o yaml > deamonset-solution.yml
master $ vim deamonset-solution.yml
```

And then migrate from Deployment to DaemonSet 

# Static pods

We can create stand-alone/static pods on nodes that are not part of the K8s cluster.

The only thing that we must do is paste the pod descriptions/yaml fiels at ```/etc/kubernetes/manifests```

And Kubelet will check them in a given interval and deploy them.

! WE can only create pods nothing else - replicasets, deployments etc..

Difference between Static Pods and Daemon sets:

- Static PODs
  - Are created by the Kubelet
  - Deploy Control Plane components as Static Pods
- DaemonSets
  - Created by Kube-API server(DaemonSet Controller)
  - Deploy Monitoring Agents, Loggin Agents on nodes

They are all ignored by the Kube-Scheduler

## Get all static pods on the cluster:

```shell
# Look for the ones that have -master
# They are also located at /etc/kubernetes/manifests
kubectl get pods -A --no-headers | grep master
```

## Busybox static pod creation

```
kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
```

Kubelet configration is located at:

```shell
/var/lib/kubelet/config.yaml
```