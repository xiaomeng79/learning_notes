# API

- [google api 设计指南](https://cloud.google.com/apis/design/)

## 使用统一的定义(比如使用protobuf)

- [googleapis](https://github.com/googleapis/googleapis)
- [envoyapis](https://github.com/envoyproxy/data-plane-api)
- [istioapis](https://github.com/istio/api)

## 好处

- API仓库，方便跨部门协作
- 版本管理，基于git控制
- 规范化检查，API lint
- 变更diff
- 权限管理，目录OWNENS

## 技巧

- 使用 `google.protobuf.FieldMask` 来设置一些字段的部分更新
