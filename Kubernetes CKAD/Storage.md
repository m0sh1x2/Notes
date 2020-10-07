# Storage

## Docker Storage

Creates the filesystem at ```/var/lib/docker```
Under it are:
- aufs
- containers
- images
- volumes

Docker uses a Layered Architecture

The main storage drivers are:
- AUFS
- ZFS
- BTRFS
- Device Mapper
- Overlay
- Overlay2

CRI - Container Runtime Interface
- Helps with communication between the container runtimes(rkt, docker, cri-o).

CNI - Container Network Interface 
- Helps connecting specific network solutions(weaveworks, flannel, cilium)

CSI - Container Storage Interface
- This is a universtal standard and allows any container orchiestration tool to work with any storage provider.

### Volumes & Mounts

We define the volume and mount it in the container spec.

```yaml
spec:
  containers:
  - image: alpine
  ...
    volumeMounts:
    - mountPath: /opt
      name: data-volume
  volumes:
  - name: data-volume
    hostPath:
      path: /data
      type: Directory
```

### Persistent Volumes

```yaml
# pv-definition.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  nae: pv-vol1
spec:
  accessModes;
    - ReadWriteOnce
  capacity:
    storage: 1Gi
  hostPath:
    path: /tmp/data
```

### Persistent Volume Claims

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
``` 


Execute commands in a pod
```
kubectl exec webap -- cat /log/app.log
```