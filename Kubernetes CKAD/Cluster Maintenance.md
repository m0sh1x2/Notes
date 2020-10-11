# Cluster Maintenance

- When a node goes down the master waits 5 minutes before he re-creates the pods.
- This is named  pod-eviction time which is 5 minutes by default.
- kube-controller-manager --pod-eviction-timeout=5m0s

When upgrading:
- migrate the workload - ```kubectl drain node-1```
- the pods are being terminated and re-created on othern odes
- enable scheduling for the note(when ready) -  ```kubectl uncordon node-1```


## Kubernetes software versions

v1.11.3

- v1 Major
- 11 - Minor
- 3 - Patch

Some usefull references:

https://kubernetes.io/docs/concepts/overview/kubernetes-api/

Here is a link to kubernetes documentation if you want to learn more about this topic (You don't need it for the exam though):

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api_changes.md

# Cluster Upgrade Process

All services must be the same version except for the controller-manager and kube-scheduler(they can be 1 version below).

Kubelet and kube-proxy can be one version below.

Kubectl can be one version above or below the kube-api server.

- Always upgrade one minor version at a time.

There are a several upgrade options:

- Upgrade all nodes + downtime
- Upgrade nodes one by one
- Upgrade nodes one by one by provisioning new nodes and deleting the old ones.

```
kubeadm upgrade plan

```

- kubeadm doesn't install or configure kubelets, you must upgrade them manually.
- we must upgrade the kubeadm tool as well.

```
apt-get upgrade -y kubelet=1.12.0-00
systemctl restart kubelet
```

# Backup and Restore Methods

What should we backup:

- ETCD cluster
- Resource Configurations
- Persistent Volumes

We should use the declarative way so that we can save the configurations.

Backup every config:

```
kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml
```

Velero is one way to backup the whole cluster - https://velero.io/


We can backup ETCD with a backup tool.

ETCD has it's own snapshot feature:

```
ETCDCTL_API= etcdctl \
snapshot save snapshot.db
# snapshot status - returns the satus of the snapshot
```

During restore you must specify a new cluster token so that new nodes do not join the old backup version.

```
systemctl deamon-reload
service etcd restart
service kube-apiserver start
```


```
Run the commands: apt update, apt install kubeadm=1.19.0-00 and then kubeadm upgrade node. Finally, run apt install kubelet=1.19.0-00.
```

# Exam tip

```
Here's a quick tip. In the exam, you won't know if what you did is correct or not as in the practice tests in this course. You must verify your work yourself. For example, if the question is to create a pod with a specific image, you must run the the kubectl describe pod command to verify the pod is created with the correct name and correct image.
```


## Usefull refferences
- https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster

- https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md

- https://www.youtube.com/watch?v=qRPNuT080Hk

# Backup etcd

```
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/snapshot-pre-boot.db
```

Backup solution source - https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md