# Makefile

## go工具自动安装(go-tool.make)

工具包含：golang govendor cloc gocyclo protoc go-torch debugcharts dep等，可以增加添加
默认：golang govendor(包管理) cloc(代码统计) gocyclo(圈复杂度) protoc(protobuf protoc-gen-go protoc-gen-micro) go-torch (火焰图)
可以自定义设置: 修改all:后面的标签
#### 安装

```shell
#新建目录存放go包和第三方插件(这里目录为gopkg)
mkdir -p ${HOME}/gopkg/bin ${HOME}/gopkg/src
#下载makefile
git clone https://github.com/xiaomeng79/Makefile.git && cd Makefile
#更改makefile中soft_dir和go_path的路径为自定义的路径（默认为一下设置）
vi go-tool.make
soft_dir=${HOME}/gopkg/third
go_path=${HOME}/gopkg
#安装软件(默认安装all下面的软件，可以单独安装一个软件)
make -f go-tool.make
#安装一个软件(以govendor为例)
make -f go-tool.make govendor
#设置环境变量
make -f go-tool.make setpath
#清空安装包
make -f go-tool.make clean

```
>| 安装过程由于网络问题，可能安装不好，需要重试几次
