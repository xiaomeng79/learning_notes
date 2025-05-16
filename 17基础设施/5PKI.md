# PKI体系

[PKI详解](https://www.cnblogs.com/ops-song/p/11351955.html)

PKI是Public Key Infrastructure的首字母缩写，翻译过来就是公钥基础设施。

## 主要任务

是一套基于非对称加密技术的安全框架，用于创建、管理、存储和验证数字证书，确保网络通信的机密性、完整性和身份真实性。

## PKI的核心组成

- **注册机构RA（Registration Authority）**：对用户身份进行验证，校验数据合法性，负责登记，审核过了就发给 CA。
- **证书机构CA（Certification Authority）**：负责证书的颁发和吊销（Revoke），接收来自 RA 的请求，是最核心的部分。
- **证书数据库**：存放证书，多采用 X.500 系列标准格式。可以配合LDAP 目录服务管理用户信息。

## 常见的操作流程为：

用户通过 RA 登记申请证书，提供身份和认证信息等；CA 审核后完成证书的制造，颁发给用户。用户如果需要撤销证书则需要再次向 CA 发出申请。

## [X.509、PKCS文件格式介绍](https://segmentfault.com/a/1190000019008423)

- X.509是证书规范
- PKCS文件是密码学规范，比如PKCS#1定义了RSA公钥和私钥的格式

### 编码规则

ASN.1（规定如何用二进制来表示数据结构，DER是其中一种。）

### PEM和DER(内容格式)

DER是二进制格式，不适合与邮件传输（早期Email不能发送附件），因此使用PEM把二进制内容转换成ASCII码（base64编码DER内容）。

```pem
# label用来区分内容到底是什么类型，这些label只是一种约定俗成。
-----BEGIN label-----
BASE64Encoded
-----END label-----
```
### X.509证书

[关于X509证书和密钥的概念](https://segmentfault.com/a/1190000020811310)

一个X.509 Certificate包含一个Public Key和一个身份信息，它要么是被CA签发的要么是自签发的。

### PKCS系列

- PKCS#1：RSA Cryptography Standard，定义了RSA Public Key和Private Key数学属性和格式
- PKCS#7：它规定了加密、签名等消息的语法格式，就是电子信封，包含了信息和证书。
- PKCS#8：Private-Key Information Syntax Standard，用于加密或非加密地存储Private Certificate Keypairs（不限于RSA）
- PKCS#10：是证书请求语法。
- PKCS#12：个人信息交换语法标准，含有私钥，同时可以有公钥，有口令保护。

## OCSP在线证书状态协议

OCSP（Online Certificate Status Protocol）[14]是IETF颁布的用于检查数字证书在某一交易时刻是否仍然有效的标准。该标准提供给PKI用户一条方便快捷的数字证书状态查询通道，使PKI体系能够更有效、更安全地在各个领域中被广泛应用。

## LDAP 轻量级目录访问协议

LDAP规范（RFC1487）简化了笨重的X.500目录访问协议，并且在功能性、数据表示、编码和传输方面都进行了相应的修改。1997年，LDAP第3版本成为互联网标准。目前，LDAP v3已经在PKI体系中被广泛应用于证书信息发布、CRL信息发布、CA政策以及与信息发布相关的各个方面。
