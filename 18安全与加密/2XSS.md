## XSS

#### 概念

XSS(Cross Site Scripting) 在有漏洞的程序中插入JavaScript、VBScript、 ActiveX或Flash以欺骗用户,一旦得手，他们可以盗取用户帐户信息，修改用户设置，盗取/污染cookie和植入恶意广告等

- 存储型XSS: 恶意用户的Html输入Web程序->进入数据库->Web程序->用户浏览器
- 反射型XSS: 将脚本代码加入URL地址的请求参数里，请求参数进入程序后在页面直接输出，用户点击类似的恶意链接就可能受到攻击

#### 预防

1. 验证所有输入的数据
2. 对所有输出的数据进行适当的处理(转义)

#### 例子

```go
<script>alert()</script> //原
&lt;script&gt;alert()&lt;/script&gt  //转义后

```