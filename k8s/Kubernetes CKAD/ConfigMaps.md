# ConfigMaps


## Imperative way

```
kubectl create configmap CONFIG_MAP_NAME --from-literal=KEY=VALUE --from-literal=KEY=VALUE

kubectl create configmap CONFIG_MAP_NAME --from-file=filename.props
```

## Declarative way

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    name: app-config
data:
    APP_COLOR: blue
    APP_MODE: prod
    APP_USER: user1
```

## Example with pod


```yaml
spec:
  containers:
  - name: test-container
    image: nginx:latest
    ports:
      - containerPort: 8080
    envFrom:
      - configMapRef:
          name: app-config
```