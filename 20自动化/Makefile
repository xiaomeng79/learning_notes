# See. https://github.com/oam-dev/kubevela/blob/master/Makefile
# 格式化代码
.PHONY : fmt
fmt :
	@echo "格式化代码"
	@gofmt -l -w ./

# 代码测试
.PHONY : test
test :
	@echo "代码测试[覆盖率]"
	@go test  -v -race -cover  -coverprofile=coverage.txt -covermode=atomic ./...

# 代码风格检查
.PHONY : lint
lint :
	@golangci-lint run  -v  ./...

manifests:
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif
GOLANGCILINT_VERSION ?= v1.29.0
HOSTOS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
HOSTARCH := $(shell uname -m)
ifeq ($(HOSTARCH),x86_64)
HOSTARCH := amd64
endif

golangci:
ifeq (, $(shell which golangci-lint))
	@{ \
	set -e ;\
	echo 'installing golangci-lint-$(GOLANGCILINT_VERSION)' ;\
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(GOBIN) $(GOLANGCILINT_VERSION) ;\
	echo 'Install succeed' ;\
	}
GOLANGCILINT=$(GOBIN)/golangci-lint
else
GOLANGCILINT=$(shell which golangci-lint)
endif


# -------------------------------本地CI/CD流程---------------------------------#

# 代码风格检查
locallint :
	@echo "执行代码风格检查脚本"
	@echo "-----------------------------------------------"

# 本地代码测试
localtest :
	@echo "执行代码测试脚本"
	@echo "-----------------------------------------------"

# 代码编译
localbuild :
	@echo "执行代码编译脚本"
	@echo "-----------------------------------------------"

# 打包镜像
localimage :
	@echo "执行打包镜像，推送到镜像仓库脚本"
	@echo "docker login --username=abc --password=123456 xxx.com"
	@echo "-----------------------------------------------"

# 部署镜像
localdeploy :
	@echo "执行部署镜像到docker云或者k8s云环境脚本"
	@echo "-----------------------------------------------"

# ci/cd
localcicd : locallint localtest localbuild localimage localdeploy
	@echo "本地主机执行CI/CD流程"
	@echo "-----------------------------------------------"
	@echo "本地主机执行CI/CD面临的问题:"
	@echo "1. 每个人的环境不一样(操作系统，组件版本)"
	@echo "2. 是否执行全部过程不清楚"
	@echo "3. 每个人都需要安装整个流程的全部工具"
	@echo "4. 密码泄漏"

# -------------------------------本地CI/CD流程---------------------------------#

# 自动化解决我们问题
solve :
	@echo "自动化可以解决我们的什么问题:"
	@echo "1. 减少每个人重复过程(操作系统，测试工具)"
	@echo "2. 任何时间、任何地点生成可部署的软件"
	@echo "3. 建立团队对开发产品的信心(质量保证)"

tools :
	@echo "第三方CI/CD工具解决我们什么问题(jenkins gitlab-ci travis等)"
	@echo "1. 一些秘钥的保护"
	@echo "2. 流程的标准化"