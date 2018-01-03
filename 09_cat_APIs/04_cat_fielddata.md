## 查看字段信息 cat fielddata

`fielddata`显示集群中每个数据节点上fielddata当前正在使用多少堆内存。    
    
    GET /_cat/fielddata?v

响应:
    
    id                     host      ip        node    field   size
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in body    544b
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in soul    480b

可以将字段指定为查询参数，也可以在URL路径中指定：
    
    GET /_cat/fielddata?v&fields=body

响应:
    
    
    id                     host      ip        node    field   size
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in body    544b

可以使用逗号分隔接收多个参数：    
    
    GET /_cat/fielddata/body,soul?v

产生的响应如下内容：
    
    id                     host      ip        node    field   size
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in body    544b
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in soul    480b

输出显示了`body`和`soul`字段的单个字段数据，每个节点每个字段一行。
