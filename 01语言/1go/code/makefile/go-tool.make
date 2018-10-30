#定义变量
soft_dir=${HOME}/gopkg/third
go_path=${HOME}/gopkg
go_version=1.10
protoc_version=3.6.1
cloc_version=1.76

#定义环境变量
export GOPATH:=$(go_path)
export PATH:=${PATH}:${GOPATH}/bin:$(soft_dir)/go/bin:$(soft_dir)/protobuf/bin:$(soft_dir)/cloc-$(cloc_version)
#开始安装，选择要安装的工具
.PHONY : all
all : golang govendor cloc gocyclo protoc go-torch
	@echo "全部安装完成"
	@echo “第三方插件路径为:”$(soft_dir)
	@echo "GOPATH的路径为："$(go_path)
#设置全局环境变量
.PHONY : setpath
setpath :


	 @{ chmod +x setPath.sh && ./setPath.sh ${HOME}/.bashrc ${go_path} ${PATH} && echo "设置环境变量成功";}

#测试
.PHONY : test
test : gocyclo cloc
        
	@{ \
        cd $(shell pwd)/account-srv && \
        echo "圈复杂度计算:\n" && \
        ls model/* handler/* | grep -v _test | xargs gocyclo && \
        ls model/* handler/* | grep -v _test | xargs gocyclo | awk '{sum+=$$1}END{printf("总圈复杂度: %s\n", sum)}' && \
        echo "统计代码行数:\n" && \
        ls model/* handler/* | xargs cloc --by-file;}

#安装golang
.PHONY : golang
golang :

	@hash go 2>/dev/null || { \
		echo "安装golang环境 go"$(go_version) && \
		mkdir -p $(soft_dir) && cd $(soft_dir) && \
		wget -c https://dl.google.com/go/go$(go_version).linux-amd64.tar.gz && \
		tar -xzvf go$(go_version).linux-amd64.tar.gz && \
		cd .. && \
		go version; \
	}

#安装go的依赖管理工具govendor
.PHONY : govendor
govendor : golang

	@hash govendor 2>/dev/null || { \
		echo "安装go的依赖管理工具govendor" && \
		`go get -u github.com/kardianos/govendor`;\
		}

#安装protoc
.PHONY : protoc
protoc : golang

	@hash protoc 2>/dev/null || { \
		echo "安装protobuf 代码生成工具 protoc" && \
		mkdir -p $(soft_dir) && cd  $(soft_dir) && \
		wget -c https://github.com/google/protobuf/releases/download/v$(protoc_version)/protobuf-cpp-$(protoc_version).tar.gz && \
		tar -xzvf protobuf-cpp-$(protoc_version).tar.gz && \
		cd protobuf-$(protoc_version) && \
		./configure --prefix=`pwd`/../protobuf && \
		make -j8 && \
		make install && \
		cd ../.. && \
		protoc --version; \
	}
	@hash protoc-gen-go 2>/dev/null || { \
		echo "安装 protobuf golang 插件 protoc-gen-go" && \
		`go get -u github.com/golang/protobuf/proto`&& \
		`go get -u github.com/golang/protobuf/protoc-gen-go`; \
	}
	@hash protoc-gen-micro 2>/dev/null || { \
		echo "安装micro 插件protoc-gen-micro" && \
		`go get github.com/micro/protoc-gen-micro`; \
	}


#安装cloc
.PHONY : cloc
cloc :

	@hash cloc 2>/dev/null || { \
		echo "安装代码统计工具 cloc" && \
		mkdir -p $(soft_dir) && cd  $(soft_dir) && \
		wget -c https://github.com/AlDanial/cloc/archive/v$(cloc_version).zip && \
		unzip v$(cloc_version).zip && \
		echo "cloc 的版本是:" && cloc --version; \
		}	

#安装gocyclo圈复杂度计算工具
.PHONY : gocyclo
gocyclo : golang

	@hash gocyclo 2>/dev/null || { \
		echo "安装gocyclo圈复杂度计算工具" && \
		go get -u github.com/fzipp/gocyclo; \
	}

#安装go-torch火焰图
.PHONY : go-torch
go-torch : golang

	@hash go-torch 2>/dev/null || { \
		echo "安装go-torch" && \
		go get github.com/uber/go-torch && \
		cd $(GOPATH)/src/github.com/uber/go-torch && \
		git clone https://github.com/brendangregg/FlameGraph.git; \
	}

#安装gom,可以显示运行的协程数和机器线程数，cpu和mem
.PHONY : gom
gom : golang

	@hash gom 2>/dev/null || { \
		echo "安装gom" && \
		go get github.com/rakyll/gom/cmd/gom && \
		gom; \
	}

#安装debugcharts
.PHONY : debugcharts
debugcharts : golang

	{ \
	echo "安装debugcharts" && \
	`go get -v  github.com/mkevac/debugcharts` 2>/dev/null && \
	echo "项目执行命令上加: -tags debugcharts 去使用"; \
	}
#安装dep为项目管理
.PHONY : dep
dep : golang

	@hash dep 2>/dev/null || { \
		echo "安装dep为项目依赖管理" && \
		`go get -u github.com/golang/dep/cmd/dep` 2>/dev/null; \
	}
#clean无用的安装包
.PHONY : clean
clean :
	@echo "开始清理"
	@-rm -rf $(soft_dir)/*.zip $(soft_dir)/*.gz $(soft_dir)/*.tar
	@echo "清理完毕"
