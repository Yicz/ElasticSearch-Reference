# 了解的你数据
## 简单的数据集
现在我们已经看到了一些基本知识，让我们尝试一下更加真实的数据集。 我准备了一个关于客户银行账户信息的虚构的JSON文档样本。 每个文档都有以下模式：

```sh
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
```

为了好奇，我从[www.json-generator.com](http://www.json-generator.com)生成了这些数据，所以请忽略数据的实际值和语义，因为这些数据都是随机生成的。

## 加载简单数据集
你可以在[这里](https://github.com/elastic/elasticsearch/blob/master/docs/src/test/resources/accounts.json?raw=true)下载一个简单的数据集 (accounts.json) .解压到当前目录，并将它加入到我们的elasticsearch集群当中。

```sh
# 使用命令行
curl -H "Content-Type: application/json" -XPOST 'localhost:9200/bank/account/_bulk?pretty&refresh' --data-binary "@accounts.json"
curl 'localhost:9200/_cat/indices?v'
#响应：
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   bank  l7sSYV2cQXmu6_4rJWVIww   5   1       1000            0    128.6kb        128.6kb
```

从响应中我们可以知道，我们刚刚成功地进行了批量操作并在bank/account中插入了10000条数据。