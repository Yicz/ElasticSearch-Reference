## 查看节点属性 cat nodeattrs

`nodeattrs`命令显示自定义节点属性。 例如：    
    
    GET /_cat/nodeattrs?v

响应:
    
    
    node    host      ip        attr     value
    EK_AsJb 127.0.0.1 127.0.0.1 testattr test

前几列（`node`，`host`，`ip`）给出每个节点的基本信息，`attr`和`value`列给你定制节点属性，每行一个。

### Columns

以下是可以传递给`nodeattrs？h=`的已有标题的详尽列表，以按有序列检索相关细节。 如果没有指定标题，那么将显示标记为默认显示的标题。 如果指定了任何头部，则不使用默认值。

为简洁起见，别名可以用来代替完整的标题名称。 除非指定了不同的顺序（例如，`h = attr，value`对`h = value，attr`），否则列将按照下面列出的顺序出现。

指定标题时，标题不会默认放在输出中。 要在输出中显示标题，请使用详细模式（`v`）。 标题名称将与提供的值匹配（例如，`pid`与`p`）。 例如：
    
    GET /_cat/nodeattrs?v&h=name,pid,attr,value

响应:
    
    name    pid   attr     value
    EK_AsJb 19566 testattr test

标题名称 | 别名 | 默认显示 | 描述 | 例如  
---|---|---|---|---  
`node`| `name`| Yes| 节点名称 | DKDM97B    
`id`| `nodeId`| No|唯一结节ID| k0zy    
`pid`| `p`| No| 进行ID| 13061    
`host`| `h`| Yes| 主机名| n1    
`ip`| `i`| Yes| IP地址| 127.0.1.1    
`port`| `po`| No| 传输端口| 9300    
`attr`| `attr.name`| Yes| 属性名称| rack    
`value`| `attr.value`| Yes| 属性值| rack123