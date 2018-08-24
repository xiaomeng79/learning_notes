## curl

### 基本命令

GET _cat/health?v //查看集群状态
GET _cat/indices?v //查看集群索引
PUT /test_index  //创建索引
DELETE/test_index //删除索引

### 查询操作
query string search:get参数 +必须包含 -必须不包含
query DSL es特有的查询
query filter 查询过滤
full-text query 全文查询 模糊匹配
phrase search 短语查询 ，匹配全部
highlight search 高亮查询
```
增加:
PUT /index/type/id
例如：
请求：
PUT /test_index/product/3
{
  "name":"wo de ya gao",
  "price":36
}

(partial update)修改:性能好：

POST /test_index/product/3/_update
{
  "doc": {
    "name":"wo shi ren"
  }
}


查询：
全部：
GET /test_index/product/_search
结果：
{
  "took": 12,//耗费毫秒数
  "timed_out": false,//是否超时
  "_shards": { //分片信息
    "total": 5,
    "successful": 5,
    "skipped": 0,
    "failed": 0
  },
部分：
GET /test_index/product/_search?q=name:wo&sort=price:desc //按照商品名称和价格降排序
DSL://重点 
GET /test_index/product/_search
{
  "query":{"match_all": {}}
}
GET /test_index/product/_search
{
  "query": {
    "match": {
      "name": "shi"
    }
  },
  "sort": [
    {
      "price": “desc”
    }
  ]
}
分页和选择列：
GET /test_index/product/_search
{
  "query": {"match_all": {}},//查询所有
  "from":1,//从哪里
  "size":2,//查询数目
  "_source": ["name","price"] //查询列
}

数据过滤:
GET /test_index/product/_search
{
  "query": {
    "bool": {
      "must":
        {"match": {
          "name": "shi"
        }
      },
      "filter": {
        "range": {
          "price": {
            "gte": 10
          }
        }
      }
    }
  }
}

全文检索:
GET /test_index/product/_search
{
  "query":{
    "match": {
      "name": "wo hello"
    }
  }
}

短语搜索:
GET /test_index/product/_search
{
  "query":{
    "match_phrase": {
      "name": "wo hello"
    }
  }
}

高亮检索:

GET /test_index/product/_search
{
  "query":{
    "match_phrase": {
      "name": "wo hello"
    }
  },
  "highlight":{
    "fields": {
      "name": {}
    }
  }
}
```

### 脚本更新

```
POST shop/product/100/_update
{
  "script":"ctx._source.num+=1"
}
```
### 重试跟新
```
POST shop/product/100/_update?retry_on_conflict=5&version=6
```

### 批量查询(_mget)

```curl
GET _mget
{
  "docs":[
    {
      "_index":"shop",
      "_type":"product",
      "_id":1
    },
        {
      "_index":"shop",
      "_type":"product",
      "_id":2
    }
    ]
}

##index,type固定
GET /shop/product/_mget
{
  "ids":[1,2]
}
```
### 大量操作(_bulk)

一般1000-5000条数据比较合适，因为先加载到内存，才执行
bulk对json不能换行

bulk就是将一条条的数据分发给不同的shard进行处理，提高吞吐量，bulk操作中，任意一个操作失败，是不会影响其他的操作的

一个操作，2个json，delete除外
delete：删除
create:put /index/type/id/_create 强制删除
index:普通的put操作
update:执行partial update操作

```curl
POST /_bulk
{"delete":{"_index":"shop","_type":"product","_id":1}}
```

