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
