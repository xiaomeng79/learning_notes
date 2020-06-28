## Helm

[helm](https://github.com/helm/helm)

[官方charts](https://github.com/helm/charts)

[helm介绍](https://blog.csdn.net/bbwangj/article/details/81087911)

[中文文档](https://whmzsu.github.io/helm-doc-zh-cn/quickstart/quickstart-zh_cn.html)


#### helm一些国内的仓库
```bash
# 增加仓库
helm repo add aliyuncs https://apphub.aliyuncs.com
# 国内源
bitnami  	https://charts.bitnami.com/bitnami                         
aliyuncs 	https://apphub.aliyuncs.com                                
gitlab   	https://charts.gitlab.io/                                  
aliyun   	https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts     
incubator	https://kubernetes-charts-incubator.storage.googleapis.com/
stable   	https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts  
```

#### 常见错误
1. Error: unable to build kubernetes objects from release manifest: unable to recognize "": no matches for kind "Deployment" in version "extensions/v1beta1"
```bash
grep -irl "extensions/v1beta1" jenkins | grep deploy | xargs sed -i 's#extensions/v1beta1#apps/v1#g'
```

#### ~~安装步骤(版本2)~~
```bash
kubectl create serviceaccount --namespace=kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.14.3 --stable-repo-url http://mirror.azure.cn/kubernetes/charts/ --service-account tiller --override spec.selector.matchLabels.'name'='tiller',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -

# 检查一下是不是安装成功了
kubectl get pods -n kube-system | grep tiller

root@rancherk8sm1:~# helm version
Client: &version.Version{SemVer:"v2.12.1", GitCommit:"02a47c7249b1fc6d8fd3b94e6b4babf9d818144e", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.12.1", GitCommit:"02a47c7249b1fc6d8fd3b94e6b4babf9d818144e", GitTreeState:"clean"}
```