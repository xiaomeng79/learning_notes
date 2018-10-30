#!/bin/bash
#设置GOPATH
f=".bashrc"
go_path=""
path=""
if test "$#" -eq 3;then
	f=$1;go_path=$2;path=$3;
else
	print "参数不正确，共三个参数，第一个参数是:修改环境变量的文件路径，第二个参数是，GOPATH的路径，第三个参数是，PATH路径";
	exit -1;
fi
path=${PATH}:${path};
sed -i '/export GOPATH=/d' $f;
echo "export GOPATH=${go_path}" >>$f;
sed -i '/export PATH=/d' $f;
echo "export PATH=${path}" >>$f;

source $f;
