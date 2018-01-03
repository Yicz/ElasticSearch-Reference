## 查看节点属性 cat nodeattrs

`nodeattrs`命令显示自定义节点属性。 例如：    
    
    GET /_cat/nodeattrs?v

响应:
    
    
    node    host      ip        attr     value
    EK_AsJb 127.0.0.1 127.0.0.1 testattr test

前几列（`node`，`host`，`ip`）给出每个节点的基本信息，`attr`和`value`列给你定制节点属性，每行一个。

### Columns

Below is an exhaustive list of the existing headers that can be passed to `nodeattrs?h=` to retrieve the relevant details in ordered columns. If no headers are specified, then those marked to Appear by Default will appear. If any header is specified, then the defaults are not used.

Aliases can be used in place of the full header name for brevity. Columns appear in the order that they are listed below unless a different order is specified (e.g., `h=attr,value` versus `h=value,attr`).

When specifying headers, the headers are not placed in the output by default. To have the headers appear in the output, use verbose mode (`v`). The header name will match the supplied value (e.g., `pid` versus `p`). For example:
    
    
    GET /_cat/nodeattrs?v&h=name,pid,attr,value

Might look like:
    
    
    name    pid   attr     value
    EK_AsJb 19566 testattr test

Header | Alias | Appear by Default | Description | Example  
---|---|---|---|---  
`node`| `name`| Yes| Name of the node| DKDM97B    
`id`| `nodeId`| No| Unique node ID| k0zy    
`pid`| `p`| No| Process ID| 13061    
`host`| `h`| Yes| Host name| n1    
`ip`| `i`| Yes| IP address| 127.0.1.1    
`port`| `po`| No| Bound transport port| 9300    
`attr`| `attr.name`| Yes| Attribute name| rack    
`value`| `attr.value`| Yes| Attribute value| rack123