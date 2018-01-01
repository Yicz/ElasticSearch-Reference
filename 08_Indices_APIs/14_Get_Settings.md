## 获取设置 Get Settings

获取设置API允许返回索引/索引的设置：    
    
    GET /twitter/_settings

### 多个索引和类型 Multiple Indices and Types

获取设置API可用于通过一次调用获取多个索引的设置。 API的一般用法遵循以下语法：`host：port/{index}/_settings`其中`{index}`可以代表逗号分隔的索引名称和别名列表。 要获得所有索引的设置，你可以在`{index}`中使用`_all`。 通配符表达式也被支持。 以下是一些例子：
    
    GET /twitter,kimchy/_settings
    
    GET /_all/_settings
    
    GET /log_2013_*/_settings

### 按名称过滤设置 Filtering settings by name

返回的设置可以使用通配符进行过滤，如下所示：    
    
    curl -XGET 'http://localhost:9200/2013-*/_settings/index.number_*'
