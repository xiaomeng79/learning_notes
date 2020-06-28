## k3s安装istio

1. k3d安装k3s集群

2. 使用k3d创建安装`istio`的集群
```bash
k3d create --server-arg --no-deploy --server-arg traefik --name istio-test
```

3. 