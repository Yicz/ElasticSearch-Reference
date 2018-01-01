## 设置映射关系 Put Mapping

设置映射关系API允许在一个已经存在的索引中添加新的类型（type）,或给已经存在的类型添加新的字段（field）
The PUT mapping API allows you to add a new type to an existing index, or add new fields to an existing type:
    
    
    PUT twitter <1>
    {
      "mappings": {
        "tweet": {
          "properties": {
            "message": {
              "type": "text"
            }
          }
        }
      }
    }
    
    PUT twitter/_mapping/user <2>
    {
      "properties": {
        "name": {
          "type": "text"
        }
      }
    }
    
    PUT twitter/_mapping/tweet <3>
    {
      "properties": {
        "user_name": {
          "type": "text"
        }
      }
    }

<1>| 创建一个名为`twitter`的索引，并设置了`tweet`的类型和其字段`message`;
---|---    
<2>| 使用设置映射关系的API添加一个新的`user`类型
<3>| 使用设置映射关系的API给已经存在的`tweet`类型添加新的字段`user_name`
  
有关如何定义类型映射的更多信息可以在[mapping](mapping.html)部分中找到。
### 多索引 Multi-index

设置映射关系的API可以在一个请求中设置多个索引，遵循如下的格式：
    
    PUT /{index}/_mapping/{type}
    { body }

  * `{index}` 支持多索引和通配符
  * `{type}` 类型名称
  * `{body}` 映射关系的设置



![Note](/images/icons/note.png)


当通过设置映射关系API改变修改默认(_default_)映射映射的时候，新的映射关系并不会与旧的映射关系不会合并而是覆盖。

###  更新字段映射 Updating field mappings

通常，现有字段的映射不能更新。 这个规则有一些例外。 例如：
  * 新的[属性 `properties`](properties.html)可以添加到[Object datatype](object.html)字段中。
  * 新的[多字段](multi-fields.html)可以添加到现有的字段。 
  * 可以更新[`ignore_above`](ignore-above.html)参数。



例如:
    
    PUT my_index <1>
    {
      "mappings": {
        "user": {
          "properties": {
            "name": {
              "properties": {
                "first": {
                  "type": "text"
                }
              }
            },
            "user_id": {
              "type": "keyword"
            }
          }
        }
      }
    }
    
    PUT my_index/_mapping/user
    {
      "properties": {
        "name": {
          "properties": {
            "last": { <2>
              "type": "text"
            }
          }
        },
        "user_id": {
          "type": "keyword",
          "ignore_above": 100 <3>
        }
      }
    }

<1>| 在`name` [Object datatype](object.html)字段和`user_id`字段下创建一个带`first`字段的索引。
---|---    
<2>| 在`name`对象字段下添加`last`字段。     
<3>| 更新`ignore_above`设置的默认值为100。    

每个[映射参数](mapping-params.html)指定是否可以在现有字段上更新其设置。

### 不同类型的字段之间的冲突 Conflicts between fields in different types

同一索引中具有两个不同类型的相同名称的字段必须具有相同的映射，因为它们在内部由相同的字段支持。 试图为多于一个类型的字段尝试[更新映射参数](indices-put-mapping.html＃updating-field-mappings)将引发异常，除非指定`update_all_types`参数，在这种情况下 它将在同一索引中的所有具有相同名称的字段上更新该参数。

![Tip](/images/icons/tip.png)唯一可以免除此规则的参数 - 可以在每个字段上设置为不同的值 - 可以在[字段在映射类型之间共享]中找到。

例如，这失败了：
    
    
    PUT my_index
    {
      "mappings": {
        "type_one": {
          "properties": {
            "text": { <1>
              "type": "text",
              "analyzer": "standard"
            }
          }
        },
        "type_two": {
          "properties": {
            "text": { <2>
              "type": "text",
              "analyzer": "standard"
            }
          }
        }
      }
    }
    
    PUT my_index/_mapping/type_one <3>
    {
      "properties": {
        "text": {
          "type": "text",
          "analyzer": "standard",
          "search_analyzer": "whitespace"
        }
      }
    }

<1> <2>| 用两种类型创建一个索引，它们都包含一个具有相同映射的`text`字段。     
---|---   
<3>| 试图更新`search_analyzer`只是`type_one`会抛出一个异常，例如“合并失败失败...”。 
  
但是，这个然后运行这个成功：    
    
    PUT my_index/_mapping/type_one?update_all_types <1>
    {
      "properties": {
        "text": {
          "type": "text",
          "analyzer": "standard",
          "search_analyzer": "whitespace"
        }
      }
    }

<1>| 添加`update_all_types`参数更新`type_one`和`type_two`中的`text`字段。     
---|---
