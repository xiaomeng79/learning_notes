## protobuf

[参考](https://github.com/chai2010/advanced-go-programming-book/blob/master/ch4-rpc/ch4-06-grpc-ext.md)

#### 概念

Protocol buffers是一个灵活的、高效的、自动化的用于对结构化数据进行序列化的协议

#### 拓展

1. 默认值

```proto
syntax = "proto3";

package main;

import "google/protobuf/descriptor.proto";

extend google.protobuf.FieldOptions {
	string default_string = 50000;
	int32 default_int = 50001;
}

message Message {
	string name = 1 [(default_string) = "gopher"];
	int32 age = 2[(default_int) = 10];
}
```

2. [验证数据](https://github.com/mwitkow/go-proto-validators)

```shell
    go get github.com/mwitkow/go-proto-validators/protoc-gen-govalidators
```

```proto
syntax = "proto3";

package main;

import "github.com/mwitkow/go-proto-validators/validator.proto";

message Message {
	string important_string = 1 [
		(validator.field) = {regex: "^[a-z]{2,5}$"}
	];
	int32 age = 2 [
		(validator.field) = {int_gt: 0, int_lt: 100}
	];
}

```

3. rest接口

```proto
syntax = "proto3";

package main;

import "google/api/annotations.proto";

message StringMessage {
  string value = 1;
}

service RestService {
	rpc Get(StringMessage) returns (StringMessage) {
		option (google.api.http) = {
			get: "/get/{value}"
		};
	}
	rpc Post(StringMessage) returns (StringMessage) {
		option (google.api.http) = {
			post: "/post"
			body: "*"
		};
	}
}

```

命令安装protoc-gen-grpc-gateway插件：

```shell
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway

```
再通过插件生成grpc-gateway必须的路由处理代码：

```shell
protoc -I/usr/local/include -I. \
	-I$GOPATH/src \
	-I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	--grpc-gateway_out=. \
	hello.proto
	
```
在对外公布REST接口时，我们一般还会提供一个Swagger格式的文件用于描述这个接口规范

```shell
 go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger

 protoc -I. \
	-I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	--swagger_out=. \
	hello.proto
	
```