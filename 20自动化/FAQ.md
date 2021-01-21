## FAQ

- 域名解析错误

```bash
envVars:
  - name: RUNNER_PRE_CLONE_SCRIPT
    value: 'i=1 && until nslookup 你的域名 || [ $i -gt 5 ]; do echo waiting for DNS, count $i; i=$((i+1)); sleep 5; done && cat /etc/resolv.conf | sed -r "s/^(search.|options.)/#\1/" > /tmp/resolv && cat /tmp/resolv > /etc/resolv.conf'
```
或
```bash
envVars:
  - name: RUNNER_PRE_CLONE_SCRIPT
    value: 'cat /etc/resolv.conf && echo 你的ip 你的域名 >> /etc/hosts && cat /etc/hosts'
```
- ci脚本无法登录

```bash
docker login -u ${IMAGE_REPO_USER} -p ${IMAGE_REPO_PWD} 仓库地址
#Error: Cannot perform an interactive login from a non TTY device
# 解决方法
docker login -u "gitlab-ci-token" -p "$CI_JOB_TOKEN" $CI_REGISTRY
```
