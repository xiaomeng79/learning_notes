# Solidity

## 教程
- [WTF学院](https://frontend-doctor-dc.vercel.app/docs/intro)
- [视频教程01](https://www.bilibili.com/video/BV13a4y1F7V3/?spm_id_from=333.788.comment.all.click&vd_source=216c269c25aa3c3084573565ad368f6f)
- [视频教程02](https://www.bilibili.com/video/BV1u8411k7Z7/?spm_id_from=333.788.comment.all.click&vd_source=216c269c25aa3c3084573565ad368f6f)

## 概念
- function 
`function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]`
    - function：声明函数。
    - (<parameter types>)：输入到函数的变量类型和名字。
    - {internal|external|public|private}：函数可见性说明符，一共4种。没标明函数类型的，默认internal。
        - public: 内部外部均可见。(也可用于修饰状态变量，public变量会自动生成 getter函数，用于查询数值).
        - private: 只能从本合约内部访问，继承的合约也不能用（也可用于修饰状态变量）。
        - external: 只能从合约外部访问（但是可以用this.f()来调用，f是函数名）
        - internal: 只能从合约内部访问，继承的合约可以用（也可用于修饰状态变量）。
    - [pure|view|payable]：决定函数权限/功能的关键字。
        - payable（可支付的）很好理解，带着它的函数，运行的时候可以给合约转入ETH。
        - pure关键字的函数，不能读取也不能写入存储在链上的状态变量。
        - view关键字的函数，能读取但也不能写入状态变量。
        - 不写pure也不写view，函数既可以读取也可以写入状态变量。
    - [returns ()]：函数返回的变量类型和名称。
    - return用于函数主体中，返回指定的变量。
    ```solidity
        // 返回多个变量
    function returnMultiple() public pure returns(uint256, bool, uint256[3] memory){
            return(1, true, [uint256(1),2,5]);
        }
    ```
- 数据位置
    - storage：合约里的状态变量**默认**都是storage，存储在链上，消耗gas多。
    - memory：函数里的参数和临时变量一般用memory，存储在内存中，不上链，消耗gas少。
    - calldata：和memory类似，存储在内存中，不上链。与memory的不同点在于calldata变量不能修改（immutable），一般用于函数的参数。
- 引用类型
    - 数组（array）bytes也是
    - 结构体（struct）
    - 映射（mapping）

- 不同类型相互赋值时的规则
    - storage（合约的状态变量）赋值给本地storage（函数里的）时候，会创建引用，改变新变量会影响原变量。
    - storage赋值给memory，会创建独立的复本，修改其中一个不会影响另一个；反之亦然。
    - memory赋值给memory，会创建引用，改变新变量会影响原变量。
    - 其他情况，变量赋值给storage，会创建独立的复本，修改其中一个不会影响另一个。

- 变量的作用域
    - 状态变量：存储在链上，gas消耗高。
    - 局部变量：数据存储在内存里，不上链，gas低。
    - 全局变量：solidity预留关键字，msg.sender, block.number和msg.data等[列表](https://learnblockchain.cn/docs/solidity/units-and-global-variables.html#special-variables-and-functions)。

- 创建数组的规则
    - 对于memory修饰的动态数组，可以用new操作符来创建，但是必须声明长度，并且声明后长度不能改变。

- 映射的规则
    - 映射的_KeyType只能选择solidity默认的类型，比如uint，address等
    - 映射的存储位置必须是storage，不能用于public函数的参数或返回结果中。

- 常数
    - 可以节省gas。
    - constant
        - 只能声明
        - string和bytes只能constant。
    - immutable
        - 可以在声明时或构造函数中初始化。

- 修饰器（modifier）
也可继承，和函数一样。
```solidity
   // 定义modifier
   modifier onlyOwner {
      require(msg.sender == owner); // 检查调用者是否为owner地址
      _; // 如果是的话，继续运行函数主体；否则报错并revert交易
   }
    function changeOwner(address _newOwner) external onlyOwner{
      owner = _newOwner; // 只有owner地址运行这个函数，并改变owner
   }
```

- 事件
    ```solidity
    event Transfer(address indexed from, address indexed to, uint256 value);
    ```
    - 响应：应用程序（ether.js）可以通过RPC接口订阅和监听这些事件，并在前端做响应
    - 经济：事件是EVM上比较经济的存储数据的方式，每个大概消耗2,000 gas；相比之下，链上存储一个新变量至少需要20,000 gas。
    - `indexed`标记的变量可以理解为检索事件的索引“键”,在以太坊上单独作为一个 topic 进行存储和索引。每个事件最多有3个带`indexed`的变量。每个 `indexed` 变量的大小为固定的256比特。
    - `value` 不带 `indexed` 关键字，会存储在事件的 data 部分中，可以理解为事件的“值”。

- 继承
    ```solidity
    contract YeYe {
    event Log(string msg);
    function hip() public virtual {
        emit Log("yeye");
    }
    }

    contract BaBa is YeYe{
        function hip() public virtual override  {
            emit Log("baba");
        }
    }
    ```
    - virtual: 父合约中的函数，如果希望子合约重写，需要加上`virtual`关键字。
    - override：子合约重写了父合约中的函数，需要加上`override`关键字。
    - 多重继承：继承时要按辈分最高到最低的顺序排。
        - 如果某一个函数在多个继承的合约里都存在，在子合约里必须重写，不然会报错。
        - 重写在多个父合约中重名函数时，override关键字后面要加上所有父合约名字，例如override(Yeye, Baba)。

- 抽象合约
一个智能合约里至少有一个未实现的函数（缺少主体{}），则必须将该合约标为abstract。未实现的函数需要加virtual。

- 接口
    > 接口类似于抽象合约，但它不实现任何功能。
    > 接口和ABI等价，可转换。[abi-to-sol](https://gnidan.github.io/abi-to-sol/)
    - 不能包含状态变量
    - 不能包含构造函数
    - 不能继承除接口外的其他合约
    - 所有函数都必须是external且不能有函数体
    - 继承接口的合约必须实现接口定义的所有功能

- Error
error必须搭配revert（回退）命令使用。

- Require
抛出异常的常用方法，唯一的缺点就是gas随着描述异常的字符串长度增加，比error命令要高。

- Assert
debug用

- 函数重载
允许重载，但是不允许修饰器（modifier）重载。

- 库`library`函数
    - 不能存在状态变量
    - 不能够继承或被继承
    - 不能接收以太币
    - 不可以被销毁
    ```solidity
    // Strings库
    // 1.利用using for指令
    using Strings for uint256;
    function getString1(uint256 _number) public pure returns(string memory){
        // 库函数会自动添加为uint256型变量的成员
        return _number.toHexString();
    }
    // 2. 通过库合约名称调用库函数
    function getString2(uint256 _number) public pure returns(string memory){
        return Strings.toHexString(_number);
    }
    ```

- import用法
    - 通过源文件相对位置导入
    - 通过网址引用`import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol';`
    - 通过npm的目录导入`import '@openzeppelin/contracts/access/Ownable.sol';`

- receive和fallback 接收ETH
    - receive：接收ETH函数，必须有`external payable`。
    - 一些退款合约，嵌入恶意消耗gas的内容或者使得执行故意失败。
    ```solidity
        // 定义事件
    event Received(address Sender, uint Value);
    // 接收ETH时释放Received事件
    // 不要太复杂，消耗gas高。
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
    ```
    - fallback：可用于接收ETH，也可以用于代理合约proxy contract。
    - 合约接收ETH时，msg.data为空且存在receive()时，会触发receive()；**msg.data不为空或不存在receive()时，会触发fallback()**，此时fallback()必须为payable。

- Solidity有三种方法向其他合约发送ETH
    - `transfer()`:接收方地址.transfer(发送ETH数额),gas限制是2300，gas足够前提是对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
    ```solidity
    // 用transfer()发送ETH
    // 如果转账失败，会自动revert（回滚交易）
    function transferETH(address payable _to, uint256 amount) external payable{
        _to.transfer(amount);
    }
    ```
    - `send()`:接收方地址.send(发送ETH数额),gas限制是2300，gas足够前提是对方合约的fallback()或receive()函数不能实现太复杂的逻辑。如果转账失败，**不会revert**。
    ```solidity
    // send()发送ETH
    function sendETH(address payable _to, uint256 amount) external payable{
        // 处理下send的返回值，如果失败，revert交易并发送error
        bool success = _to.send(amount);
        if(!success){
            revert SendFailed();
        }
    }
    ```
    - `call()`:接收方地址.call{value: 发送ETH数额}("")，没有gas限制，如果转账失败，不会revert。返回值是(bool, data)，其中bool代表着转账成功或失败，需要额外代码处理一下。**推荐使用**
    ```solidity
    // call()发送ETH
    function callETH(address payable _to, uint256 amount) external payable{
        // 处理下call的返回值，如果失败，revert交易并发送error
        (bool success,) = _to.call{value: amount}("");
        if(!success){
            revert CallFailed();
        }
    }
    ```

- 调用合约
`_Name(_Address).f()`:其中_Name是合约名，_Address是合约地址
```solidity
contract Test {
    // 传入合约地址
    function setOtherX(address _address,uint256 _x) external {
        OtherContract(_address).setX(_x);
    }
    // 传入合约变量
    function setOtherXByContract(OtherContract _address,uint256 _x) external  {
        _address.setX(_x);
    }
}
```

- call
call 是address类型的低级成员函数，它用来与其他合约交互。它的返回值为(bool, data)，分别对应call是否成功以及目标函数的返回值。
`目标合约地址.call{value:发送数额, gas:gas数额}(二进制编码);`其中二进制编码生成：`abi.encodeWithSignature("函数签名", 逗号分隔的具体参数)`

- delegatecall
    - 代理合约B必须和目标合约C的变量存储布局必须相同。
    - 与call类似，它可以用来调用其他合约；不同点在于运行的语境，B call C，语境为C；而B delegatecall C，语境为B。目前delegatecall最大的应用是代理合约和EIP-2535 Diamonds（钻石）。

- 在合约中创建新合约
    - `create`:`新地址 = hash(创建者地址, nonce)`
    ```solidity
    // 其中Contract是要创建的合约名，x是合约对象（地址），如果构造函数是payable，可以创建时转入_value数量的ETH，params是新合约构造函数的参数。
    Contract x = new Contract{value: _value}(params)
    ```
    - `create2`:`新地址 = hash("0xFF",创建者地址, salt, bytecode)`
        ```solidity
        Contract x = new Contract{salt: _salt, value: _value}(params)
        ```
        - 部署到以太坊网络之前就能预测合约的创建码
        - 应用场景
            - 交易所为新用户预留创建钱包合约地址。
            - 由 CREATE2 驱动的 factory 合约，在uniswapV2中交易对的创建是在 Factory中调用create2完成。这样做的好处是: 它可以得到一个确定的pair地址, 使得 Router中就可以通过 (tokenA, tokenB) 计算出pair地址, 不再需要执行一次 Factory.getPair(tokenA, tokenB) 的跨合约调用。

- ~~selfdestruct：删除合约 ~~
`selfdestruct(_addr)；`:其中_addr为接收ETH的地址。当合约被销毁后与智能合约的交互也能成功，并且返回0。

- ABI编码
    - abi.encode:将每个参数转填充为32字节的数据，并拼接在一起。和合约交互用。
    - abi.encodePacked:类似 abi.encode，但是会把其中填充的很多0省略。比如，只用1字节来编码uint类型。当你想省空间，并且不与合约交互的时候，可以使用abi.encodePacked，例如算一些数据的hash时。
    - abi.encodeWithSignature:与abi.encode功能类似，只不过第一个参数为函数签名。abi.encode编码结果前加上了4字节的函数选择器。
    - abi.encodeWithSelector：与abi.encodeWithSignature功能类似，只不过第一个参数为函数选择器，为函数签名Keccak哈希的前4个字节。

- ABI解码
    - abi.decode：用于解码abi.encode生成的二进制编码，将它还原成原本的参数。

- 函数选择器
> 在函数签名中，uint和int要写为uint256和int256。



