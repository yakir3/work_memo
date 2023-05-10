```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: yakir-test-counter1
  namespace: default
  labels:
    app: yakir-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: yakir-test
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: yakir-test
    spec:
      containers:
      - image: busybox
        args: ["/bin/sh","-c", 'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 5; done']
        name: counter
```