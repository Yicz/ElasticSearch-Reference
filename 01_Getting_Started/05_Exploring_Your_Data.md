## 探索你的数据

### 简单的数据集合

现在我们掌握一些基本简单数据操作，现在我们尝试复杂一点的数据集合，我们已经准备了一个例子：一个银行客户账号的信息，格式是Json文档，每条数据都遵循下面的模板：
    
    {
        "account_number": 0,
        "balance": 16623,
        "firstname": "Bradshaw",
        "lastname": "Mckenzie",
        "age": 29,
        "gender": "F",
        "address": "244 Columbus Place",
        "employer": "Euron",
        "email": "bradshawmckenzie@euron.com",
        "city": "Hobucken",
        "state": "CO"
    }

数据是我从 [`www.json-generator.com/`](http://www.json-generator.com/) 随机生成的，请忽略数据的相关性。

### ES加载数据集

你可以从[这里](https://github.com/elastic/elasticsearch/blob/master/docs/src/test/resources/accounts.json?raw=true). 下载accounts.json，解压到你当前目录下，并使用如下的命令加载到ES集群中：    
    
    curl -H "Content-Type: application/json" -XPOST 'localhost:9200/bank/account/_bulk?pretty&refresh' --data-binary "@accounts.json"
    curl 'localhost:9200/_cat/indices?v'
响应内容如下    
    
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   bank  l7sSYV2cQXmu6_4rJWVIww   5   1       1000            0    128.6kb        128.6kb

这意味着我们批量的插入了1000个文档到名字为bank的索引，并且类型为account
