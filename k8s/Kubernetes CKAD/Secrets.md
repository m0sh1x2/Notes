# Secrets

Similar to ConfigMaps but their values are encoded

```
kubectl create secret generic SECRET_NAME --from-literal=KEY=VALUE
```

--from-file is also supported

## Imperative way
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: mysql
  DB_User: root
  DB_Password: password?:)

```

## Encode and decode the secret
--decode

```
echo "secret_password:)"  | base64
```

## Injecting the secret

### ENV

```yaml
envFrom:
  - secretRef:
      name: app-config
```

### Single ENV
```yaml
env:
  - name: DB_Password
    valueFrom:
      seretKeyRef:
        name: app-secret
        key: DB_Password
```

### Volume

If the secret is mounted as a volume in the pod then each value of the secret will be created as a file with it's content in the volume.

```yaml
volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret
```

## Example

```
kubectl create secret generic \
--from-literal=DB_Host=sql01 \
--from-literal=DB_User=root \
--from-literal=DB_Password=password123 \
db-secret \
-o yaml --dry-run=client > db-secret.yaml
```

## Output

```yaml
apiVersion: v1
data:
  DB_Host: c3FsMDE=
  DB_Password: cGFzc3dvcmQxMjM=
  DB_User: cm9vdA==
kind: Secret
metadata:
  creationTimestamp: null
  name: db-secret
```