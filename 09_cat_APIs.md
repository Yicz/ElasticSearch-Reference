# 查询_cat_ APIs

## 介绍

JSON格式对于电脑来说非常棒。 即使它是格式标准，试图找到关系的数据是乏味的。 使用人眼进行查看，特别是在看ssh终端时，需要紧凑和对齐的文本。\_cat API旨在满足这一需求。

所有cat 命令允许接受一个查询参数`help`来查看请求头和命令提供的信息。`/_cat`接口会列出所有可用的的命令

## 通用参数

### 动词（Verb）

每条命令都接受一个参数`v`，用来打开显示输出过程，例如：
    
    GET /_cat/master?v

响应:
     
    id                     host      ip        node
    u_n93zwxThWHi1PDBJAGAg 127.0.0.1 127.0.0.1 u_n93zw

### 帮助
所有cat 命令允许接受一个查询参数`help`，会列举出所有可用的列，例如：
    
    GET /_cat/master?help

响应:
    
    id   |   | node id
    host | h | host name
    ip   |   | ip address
    node | n | node name

### 头信息 Headers
所有cat 命令允许接受一个查询参数`h`，用来指定列，例如：
    
    GET /_cat/nodes?h=ip,port,heapPercent,name

响应:
    
    
    127.0.0.1 9300 27 sLBaIGK
你还可以使用通配符，如`_cat/thread_pool?h=ip,bulk.*`会匹配所有以`bulk.`的请求头。

### 数据格式 Numeric formats

许多命令提供了几种类型格式的数字输出，无论是字节，大小还是时间值。 默认情况下，这些类型是人类格式的，例如`3.5mb`而不是`3763212`。 人的价值观不能用数字排序，所以为了在这些重要的价值观上运作，你可以改变它。

假设您想要查找群集中最大的索引（所有碎片使用的存储空间，而不是文档数量）。 `/_cat/indices` API是理想的。 我们只需要调整两件事情。 首先，我们要关闭默认人类的模式。 我们将使用字节级别的分辨率。 然后，我们将使用适当的列将输出结果进行“sort”，在这种情况下，列是第八个。
    
    % curl '192.168.56.10:9200/_cat/indices?bytes=b' | sort -rnk8
    green wiki2 3 0 10000   0 105274918 105274918
    green wiki1 3 0 10000 413 103776272 103776272
    green foo   1 0   227   0   2065131   2065131

如果你想修改 [时间单位 time units](common-options.html#time-units), 使用 `time` 参数.

如果你想修改 [大小单位 size units](common-options.html#size-units), 使用 `size` 参数.

如果你想修改 [字节单位 byte units](common-options.html#byte-units), 使用 `bytes` 参数.

### 作为text, json, smile, yaml 或 cbor进行响应
    
    % curl 'localhost:9200/_cat/indices?format=json&pretty'
    [
      {
        "pri.store.size": "650b",
        "health": "yellow",
        "status": "open",
        "index": "twitter",
        "pri": "5",
        "rep": "1",
        "docs.count": "0",
        "docs.deleted": "0",
        "store.size": "650b"
      }
    ]

当前支持使用`?format=` parameter进行响应格式化: \- text (default) \- json \- smile \- yaml \- cbor

或者，您可以将“接受”HTTP标头设置为适当的媒体格式。 以上所有格式均受支持，GET参数优先于标题。 例如：
    
    % curl '192.168.56.10:9200/_cat/indices?pretty' -H "Accept: application/json"
    [
      {
        "pri.store.size": "650b",
        "health": "yellow",
        "status": "open",
        "index": "twitter",
        "pri": "5",
        "rep": "1",
        "docs.count": "0",
        "docs.deleted": "0",
        "store.size": "650b"
      }
    ]

### 排序 Sort

每个命令都接受一个查询字符串参数`s`，该参数`s`将表中的列指定为参数值。 列由名称或别名指定，并以逗号分隔的字符串形式提供。 默认情况下，排序按升序完成。 将`：desc`附加到列将颠倒该列的排序。 `：asc`也被接受，但表现出与默认排序顺序相同的行为。

例如，对于一个排序字符串`s = column1，column2：desc，column3`，表将按列1升序排列，按列2降序排列，按列3升序排列。
    
    GET _cat/templates?v&s=order:desc,template

返回响应:
    
    name                  template     order version
    pizza_pepperoni       *pepperoni*  2
    sushi_california_roll *avocado*    1     1
    pizza_hawaiian        *pineapples* 1
