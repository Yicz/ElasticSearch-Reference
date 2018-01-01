## 获取映射更新 Get Mapping

获取更新可以检索出index/type的映射关系的定义内容。    
    
    GET /twitter/_mapping/tweet

### 多索引和类型 Multiple Indices and Types

获取映射API可用于通过一次调用获取多个索引或类型映射。 API的一般用法遵循以下语法：`host：port/{index} /_mapping/{type}`其中`{index}`和`{type}`可以接受以逗号分隔的名称列表。 为了获得所有索引的映射，你可以在`{index}`中使用`_all`。 以下是一些例子：
    
    GET /_mapping/tweet,kimchy
    
    GET /_all/_mapping/tweet,book

如果你想得到所有指数和类型的映射，那么以下两个例子是等价的：    
    
    GET /_all/_mapping
    
    GET /_mapping
