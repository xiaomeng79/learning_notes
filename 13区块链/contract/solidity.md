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
    - 数组（array）
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
