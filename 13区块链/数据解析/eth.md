# 以太坊

## 资料
- [erc20代币检测](https://www.jidangeng.com/2020/04/23/eth-wallet-erc20-seek/)

## ABI

- [智能合约ABI](https://www.jianshu.com/p/aa60e81825f8)

## 为什么用事件日志不用交易数据
- 交易数据不记录操作结果
- 无法区分不同代币合约的操作
- 难以检测失败的内部调用

## Ethereum geth 同步区块的三种模式

- full：从开始到结束，获取区块的header、body，从创始块开始校验每一个元素，下载所有区块数据信息。速度最慢，获取到所有的历史数据。
- snap：获取区块的header，获取区块的body，在同步到当前块之前不处理任何事务，不逐一验证，有可能丢失历史数据。
- light：仅获取当前状态。验证元素需要向full节点发起相应的请求。

## [以太坊交易信息及event、input、logs、topics等概念机制](https://blog.csdn.net/cljdsc/article/details/121798544)

### 交易信息

#### 合约事件

  - `event Transfer(address indexed from, address indexed to, uint256 value)`
  - 事件名称：Transfer
  - 事件的参数：address, address, uint256
  - 注意：此事件的from和to参数前有indexed标记，value没有indexed标记

#### 以太坊交易获取

  当上述事件在合约中调用后，我们通过其交易hash获取交易信息。从以太坊得到一条交易信息的方式有两种：
  - eth_getTransactionByHash： ：返回指定交易对应的交易信息。
  ```shell
  curl -s -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionByHash","params":["0xae2a33da8396a6bc40e874b0f32b9967113a3dbf071ab1290c44c62d86873d36"],"id":1}' http://127.0.0.1:8545
 ```
  ```json
  {
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "blockHash": "0xb0d0e3b6c5e59b7b3e7e16701f6d6cb0c3c93487415b03839e88b3f7a241c528",
    "from": "0xb8262c6a2dcabd92a77df1d5bd074afd07fc5829",
    "blockNumber": "0xd19505",
    "gasPrice": "0x274daee580",
    "gas": "0x10e3d",
    "maxPriorityFeePerGas": "0x6ccc91d0",
    "maxFeePerGas": "0x2d48ddd9f1",
    "input": "0xa9059cbb000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000016512c902",
    "hash": "0xae2a33da8396a6bc40e874b0f32b9967113a3dbf071ab1290c44c62d86873d36",
    "to": "0xdac17f958d2ee523a2206206994597c13d831ec7",
    "nonce": "0x14",
    "value": "0x0",
    "transactionIndex": "0x71",
    "accessList": [],
    "type": "0x2",
    "v": "0x1",
    "chainId": "0x1",
    "s": "0x75a485b8c378173a829b27a2e55312311fdb33c68ae65f4c74e5f9cc0a748e0d"
    "r": "0xa1d7455286525df11602aab34e9e8ab21b092e2c7853a0d6beca0dfb2a78b2e8",
    }
  }
  ```

  - eth_getTransactionReceipt ：返回指定交易对应的收据信息。
  ```json
  {
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "blockHash": "0xb0d0e3b6c5e59b7b3e7e16701f6d6cb0c3c93487415b03839e88b3f7a241c528",
    "blockNumber": "0xd19505",
    "contractAddress": null,
    "cumulativeGasUsed": "0x6c847e",
    "effectiveGasPrice": "0x274daee580",
    "from": "0xb8262c6a2dcabd92a77df1d5bd074afd07fc5829",
    "gasUsed": "0xa169",
    "logs": [
      {
        "address": "0xdac17f958d2ee523a2206206994597c13d831ec7",
        "topics": [
          "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
          "0x000000000000000000000000b8262c6a2dcabd92a77df1d5bd074afd07fc5829",
          "0x000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7"
        ],
        "data": "0x000000000000000000000000000000000000000000000000000000016512c902",
        "blockNumber": "0xd19505",
        "transactionHash": "0xae2a33da8396a6bc40e874b0f32b9967113a3dbf071ab1290c44c62d86873d36",
        "transactionIndex": "0x71",
        "blockHash": "0xb0d0e3b6c5e59b7b3e7e16701f6d6cb0c3c93487415b03839e88b3f7a241c528",
        "logIndex": "0xa0",
        "removed": false
      }
    ],
    "logsBloom": "0x00000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000010000000000000000000000000000000000000000000000000000000008000000000080000000000000000000000000000000000000000000000000000000000000000000200000000000000010000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000080000000000000000000000000000000000000004000000002000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000200",
    "status": "0x1",
    "to": "0xdac17f958d2ee523a2206206994597c13d831ec7",
    "transactionHash": "0xae2a33da8396a6bc40e874b0f32b9967113a3dbf071ab1290c44c62d86873d36",
    "transactionIndex": "0x71",
    "type": "0x2"
   }
  }
  ```

### input解析

#### input内容解析

**若input=0x则为非合约调用，否则为合约方法调用。**
以合约方法function transfer(address to, uint tokens) 为例;
input数据分为3个部分：
第一部分： 4 字节，是方法名的哈希
例如：`a9059cbb`，具体可参见：以太坊智能合约各方法对应的签名编码
第二部分： 32字节，以太坊地址，目前以太坊地址是20个字节，高位补0
例如：`000000000000000000000000abcabcabcabcabcabcabcabcabcabcabcabcabca`
第三部分：32字节，是需要传输的代币数量，这里是1*10^18 GNT
例如：`0000000000000000000000000000000000000000000000000de0b6b3a7640000`
所有这些加在一起就是交易数据：
`a9059cbb000000000000000000000000abcabcabcabcabcabcabcabcabcabcabcabcabca0000000000000000000000000000000000000000000000000de0b6b3a7640000`

#### input处理逻辑

 ```javascript

if(transanctionInput=='0x'){
        // 非合约调用
    return;
}else{
    retJson['function'] = {'funcName':null,'inputs':null,'outputs':null,'exeResult':null};
    var funcArr = mxxContractABI.filter(function (per) {
        return per.signature == funcHash ;
    });
    if(funcArr!==null&&funcArr.length>0){   // 得到方法名
        if(funcArr[0].hasOwnProperty("name") && funcArr[0].name!==null){
            retJson['function']['funcName'] = funcArr[0].name;
        }
        if(funcArr[0].hasOwnProperty("inputs") && funcArr[0].inputs!==null){
            funcArr[0].inputs.map(function (res) {  // 得到方法inputs（输入）
                inputs.push(res.type);
            });
            retJson['function']['inputs'] = inputs;
        }
        if(funcArr[0].hasOwnProperty("outputs")&& funcArr[0].outputs!==null){
            funcArr[0].outputs.map(function (res) {// 得到方法outputs（输出）
                outputs.push(res.type);
            });
            retJson['function']['outputs']= outputs;
        }
 
    }
    status = transanctionReceipt.status;
    if(status == '0x1'){
        //执行成功
        retJson['function']['exeResult'] = 'Successfully Executed';
    }else {
        retJson['function']['exeResult'] = 'Failed Executed';
    }

 ```

 ### logs解析

智能合约通过【事件】来产生【日志】,日志存储的Gas费用要比合约的存储便宜很多（日志每个字节花费8个Gas，而合约存储是每32个字节20000个Gas）。想要通过合约向用户返回数据，则需将数据以事件的形式传给用户，用户拿到transactionReceipt后解析log，log.args.x拿到数据。Input只能拿到调用合约以及function的信息，而不能拿到function运行后内部产生的事件（事件不一定和function拥有相同名称和参数）。

#### 解析步骤

1. 取出transactionReceipt中logs。
2. 取出logs中一条log。
3. 使用event.js得到transferEvent，然后用transferEvent的decode方法解析log。
```javascript
web3SolidityEvent = require('./node_modules/truffle-contract/node_modules/web3/lib/web3/event.js');
var transferErc20Json = {
    "anonymous": false,
    "inputs": [{
        "indexed": true,
        "name": "from",
        "type": "address"
    }, {
        "indexed": true,
        "name": "to",
        "type": "address"
    }, {
        "indexed": false,
        "name": "value",
        "type": "uint256"
    }],
    "name": "Transfer",
    "type": "event",
    "signature": "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
};
var transferEvent = new web3SolidityEvent(null, config.transferErc20Json, null);
async function processReceiptLogs(transactionReceipt){
        let ethErc20LogRecord = null;
        let logs = transactionReceipt.logs;
 
        for (let i = 0; i < logs.length; i++) {
            let isContractExists = await redis.contractExists(logs[i].address);
 
            if (isContractExists === true) {//判断redis中是否存在
 
//是否是ERC-20 transfer事件，用topics来判断
                if(logs[i].topics[0] === transferErc20Json.signature){ 
 
                    var log = await transferEvent.decode(logs[i]);
                    logger.debug(prefixOfLogger +'--'+'transferEvent decode result:',log);
                    ethErc20LogRecord = {
                        txHash: log.transactionHash,
                        logIndex: log.logIndex,
                        contractAddress: log.address,
                        fromAddress: log.args.from ,
                        toAddress: log.args.to,
                        value: log.args.value.div(Math.pow(10, 18)).toString(),
                        data: log.args.data,
                        blockNumber: log.blockNumber,
                        removed: log.removed
                    };
                    db.setCreateAndUpdateTime(ethErc20LogRecord);
                    let createLogRecord = await tables.EthErc20Log.create(ethErc20LogRecord);
 
                }
            }
}
```

### 合约交易关键字段解释

>| [getTransactionReceipt返回信息字段详情可参考](https://infura.io/docs/ethereum/json-rpc/eth-getTransactionReceipt)

```json
{
  "jsonrpc": "2.0",   //RPC版本号，2.0
  "id": 1,      //RPC请求编号
  "result": {  //调用结果，为交易收据，主要包含如下字段：
    "blockHash": "0xb0d0e3b6c5e59b7b3e7e16701f6d6cb0c3c93487415b03839e88b3f7a241c528",  // 区块哈希
    "blockNumber": "0xd19505",   // 区块高度
    "contractAddress": null,    //合约地址
    "cumulativeGasUsed": "0x6c847e",  //当前交易执行后累计花费的gas总值
    "effectiveGasPrice": "0x274daee580",  //当前交易预计使用的gas总值
    "from": "0xb8262c6a2dcabd92a77df1d5bd074afd07fc5829",   //当前交易发送者的地址
    "gasUsed": "0xa169",    //执行当前这个交易单独花费的gas
    "logs": [   //这个交易产生的日志对象数组
      {
        "address": "0xdac17f958d2ee523a2206206994597c13d831ec7",   //当前交易被调用的合约地址
        "topics": [
          "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",  //keccak(Transfer(address,address,uint256))， //合约事件签名哈希值，对事件的字符做keccak散列运算
          "0x000000000000000000000000b8262c6a2dcabd92a77df1d5bd074afd07fc5829",  //当前交易from的地址
          "0x000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7"   //当前交易to的地址
        ], 
        "data": "0x000000000000000000000000000000000000000000000000000000016512c902",     //包含日志的非索引参数
        "blockNumber": "0xd19505",    // 区块高度
        "transactionHash": "0xae2a33da8396a6bc40e874b0f32b9967113a3dbf071ab1290c44c62d86873d36",   //交易的哈希值,32字节
        "transactionIndex": "0x71"   //交易在区块里面的序号，当交易为pending时为空
        "blockHash": "0xb0d0e3b6c5e59b7b3e7e16701f6d6cb0c3c93487415b03839e88b3f7a241c528",
        "logIndex": "0xa0",    //块中日志索引位置的整数，当交易为pending时日志为空。
        "removed": false   //当由于链重组而删除日志时，为True。 如果它是一个有效的日志则为False。  
      }
    ],
    //bloom过滤器，当交易为pending时日志为空
    "logsBloom": "0x00000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000010000000000000000000000000000000000000000000000000000000008000000000080000000000000000000000000000000000000000000000000000000000000000000200000000000000010000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000080000000000000000000000000000000000000004000000002000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000200",
    "status": "0x1",   //交易事务状态，1(成功)或0(失败)
    "to": "0xdac17f958d2ee523a2206206994597c13d831ec7",   //当前交易被调用的合约地址
    "transactionHash": "0xae2a33da8396a6bc40e874b0f32b9967113a3dbf071ab1290c44c62d86873d36",  //交易的哈希值,32字节
    "transactionIndex": "0x71",  //交易在区块里面的序号，当交易为pending时为空
    "type": "0x2"  
  }
}
```


#### ​type
- 0x0	Legacy	传统交易（EIP-155 前）
- 0x1	EIP-2930	支持访问列表（Access List）的交易
- ​0x2​​	​​EIP-1559​​	​​动态 Gas 定价交易（Base Fee + Priority Fee）


### ETH启动脚本

```shell
nohup /usr/local/bin/geth --datadir data     --cache 20240 --maxpeers 1000 --http --ws --ws.addr 0.0.0.0 --ws.api web3,eth --http --http.addr 0.0.0.0 --http.vhosts "*" --http.api "net,eth,web3,personal,debug,admin,txpool,engine" --http.corsdomain "*" --syncmode=snap >  nohup.log 2>&1 &
```


### 共识启动脚本

```shell
#!/bin/bash
nohup ./lighthouse \
    --network mainnet \
    --datadir /data/eth/consensus/lighthouse \
    beacon_node \
    --checkpoint-sync-url https://mainnet-checkpoint-sync.stakely.io/ \
    --http \
    --execution-endpoint http://localhost:8551 \
    --execution-jwt /data/eth/geth/data/geth/jwtsecret \
    >> nohup.log 2>&1 &
```

