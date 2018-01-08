##  查看索引信息 cat indices

`_cat/indices`接口展示了每个索引的信息，这个信息**跨越节点**，例如：
    
    GET /_cat/indices/twi*?v&s=index

响应: 
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   twitter  u8FNjxh8Rfy_awN11oDKYQ   1   1       1200            0     88.1kb         88.1kb
    green  open   twitter2 nYFWZEO7TUiOjLQXBaYJpA   5   0          0            0       260b           260b

我们可以快速地知道一个索引的分片数量，文档数量，以及被删除的文档数据和主分片的存储大小，和总存在大小（包含所有副本），接口的现在完成依赖于Lucene APIs

 **提示:**

  1. 由于这里显示的文档和删除文档的数量是在lucene级别，因此它包含了所有隐藏的文档（例如嵌套文档）。
  2. 要在elasticsearch级别获得文档的实际数量，推荐的方法是使用[_cat count_](cat-count.html)或[_Count API_](search-count.html)



### 主分片 Primaries

索引统计信息默认会显示所有索引的分片，包括副本。`pri`标识出了所有主分片的相关信息。

### 案例 Examples

查询黄色状态的索引
    
    GET /_cat/indices?v&health=yellow

响应:
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   twitter  u8FNjxh8Rfy_awN11oDKYQ   1   1       1200            0     88.1kb         88.1kb

按文档大小排序索引
    
    GET /_cat/indices?v&s=docs.count:desc

响应：
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   twitter  u8FNjxh8Rfy_awN11oDKYQ   1   1       1200            0     88.1kb         88.1kb
    green  open   twitter2 nYFWZEO7TUiOjLQXBaYJpA   5   0          0            0       260b           260b


查看`twitter`操作了多少次的合并操作：
    
    GET /_cat/indices/twitter?pri&v&h=health,index,pri,rep,docs.count,mt

响应:
    
    health index   pri rep docs.count mt pri.mt
    yellow twitter   1   1 1200       16     16

按索引占用内存大小进行排序
    
    GET /_cat/indices?v&h=i,tm&s=tm:desc

响应：
    
    i         tm
    twitter   8.1gb
    twitter2  30.5kb
