# Solidity

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
