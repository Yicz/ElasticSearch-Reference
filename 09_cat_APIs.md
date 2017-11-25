# cat APIs

## Introduction

JSON is great… for computers. Even if it’s pretty-printed, trying to find relationships in the data is tedious. Human eyes, especially when looking at an ssh terminal, need compact and aligned text. The cat API aims to meet this need.

All the cat commands accept a query string parameter `help` to see all the headers and info they provide, and the `/_cat` command alone lists all the available commands.

## Common parameters

### Verbose

Each of the commands accepts a query string parameter `v` to turn on verbose output. For example:
    
    
    GET /_cat/master?v

Might respond with:
    
    
    id                     host      ip        node
    u_n93zwxThWHi1PDBJAGAg 127.0.0.1 127.0.0.1 u_n93zw

### Help

Each of the commands accepts a query string parameter `help` which will output its available columns. For example:
    
    
    GET /_cat/master?help

Might respond respond with:
    
    
    id   |   | node id
    host | h | host name
    ip   |   | ip address
    node | n | node name

### Headers

Each of the commands accepts a query string parameter `h` which forces only those columns to appear. For example:
    
    
    GET /_cat/nodes?h=ip,port,heapPercent,name

Responds with:
    
    
    127.0.0.1 9300 27 sLBaIGK

You can also request multiple columns using simple wildcards like `/_cat/thread_pool?h=ip,bulk.*` to get all headers (or aliases) starting with `bulk.`.

### Numeric formats

Many commands provide a few types of numeric output, either a byte, size or a time value. By default, these types are human-formatted, for example, `3.5mb` instead of `3763212`. The human values are not sortable numerically, so in order to operate on these values where order is important, you can change it.

Say you want to find the largest index in your cluster (storage used by all the shards, not number of documents). The `/_cat/indices` API is ideal. We only need to tweak two things. First, we want to turn off human mode. We’ll use a byte-level resolution. Then we’ll pipe our output into `sort` using the appropriate column, which in this case is the eighth one.
    
    
    % curl '192.168.56.10:9200/_cat/indices?bytes=b' | sort -rnk8
    green wiki2 3 0 10000   0 105274918 105274918
    green wiki1 3 0 10000 413 103776272 103776272
    green foo   1 0   227   0   2065131   2065131

If you want to change the [time units](common-options.html#time-units "Time unitsedit"), use `time` parameter.

If you want to change the [size units](common-options.html#size-units "Unit-less quantitiesedit"), use `size` parameter.

If you want to change the [byte units](common-options.html#byte-units "Byte size unitsedit"), use `bytes` parameter.

### Response as text, json, smile, yaml or cbor
    
    
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

Currently supported formats (for the `?format=` parameter): \- text (default) \- json \- smile \- yaml \- cbor

Alternatively you can set the "Accept" HTTP header to the appropriate media format. All formats above are supported, the GET parameter takes precedence over the header. For example:
    
    
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

### Sort

Each of the commands accepts a query string parameter `s` which sorts the table by the columns specified as the parameter value. Columns are specified either by name or by alias, and are provided as a comma separated string. By default, sorting is done in ascending fashion. Appending `:desc` to a column will invert the ordering for that column. `:asc` is also accepted but exhibits the same behavior as the default sort order.

For example, with a sort string `s=column1,column2:desc,column3`, the table will be sorted in ascending order by column1, in descending order by column2, and in ascending order by column3.
    
    
    GET _cat/templates?v&s=order:desc,template

returns:
    
    
    name                  template     order version
    pizza_pepperoni       *pepperoni*  2
    sushi_california_roll *avocado*    1     1
    pizza_hawaiian        *pineapples* 1
