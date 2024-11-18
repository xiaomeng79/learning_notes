# 比特币

## 资料
- [比特币开发文档](https://developer.bitcoin.org/reference/rpc/)
- [浏览器](https://btc.com/zh-CN)

## Bitcoin 钱包地址类型

- P2PKH（Pay-to-PubKeyHash）地址
  - 格式：以1开头，例如，1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa。
  - 特点：这是最传统和最常见的地址类型，广泛用于比特币的早期交易。
  - 优点：兼容性好，几乎所有钱包和交易所都支持。
  - 缺点：随着时间的推移，这种地址类型的使用效率较低，交易费用可能会较高。

- P2SH（Pay-to-Script-Hash）地址
  - 格式：以3开头，例如，3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy。
  - 特点：这种地址允许更复杂的交易脚本，例如多重签名地址。
  - 优点：支持更复杂的交易和脚本，安全性更高。
  - 缺点：创建和管理比P2PKH地址更复杂。

- Bech32（SegWit）地址
  - 格式：以 bc1 开头，例如，bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwfvenl。
  - 特点：这是比特币改进提案BIP-0173中引入的新地址格式，旨在提高交易效率和减少费用。
  - 优点：交易费用更低，处理速度更快，且有助于减少交易体积。
  - 缺点：并非所有的钱包和交易所都支持这种地址类型，尽管支持率在逐步增加。