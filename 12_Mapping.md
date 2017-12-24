# 映射关系 Mapping

映射操作是一个定义一个文档的过程，包含定义文档字段，是否进行存储或索引，举个实例，使用映射进行定义：

  * 哪些字段可以当作全文字段。
  * 哪个字段包含数据，日期，或地理位置。
  * 是否应将文档中所有字段的值编入全部[`_all`](mapping-all-field.html)字段中。

  * 定义 [日期格式](mapping-date-format.html)。
  * 自定义添加新字段的映射的规则 [动态映射](dynamic-mapping.html)

## 映射类型

每个索引都有1+个 _映射类型_ , 为了在同一个索引里面进行文档的逻辑区分。用户文档应该划分为`user`，而博客文章应该划分为`blogpost`.

每个映射关系都有如下内容:

[元字段 Meta-fields](mapping-fields.html)
    
    元字段用于自定义文档元数据关联的处理方式。 元字段的例子包括文档的[`_index`](mapping-index-field.html), [`_type`](mapping-type-field.html), [`_id`](mapping-id-field.html), 和 [`_source`](mapping-source-field.html). 
[字段 Fields](mapping-types.html) or _属性 properties_
    
    每种映射类型都包含与该类型相关的字段或“属性”列表。'user`类型可能包含`title`，`name`和`age`字段，而`blogpost`类型可能包含`title`，`body`，`user_id`和`created`字段。 具有相同索引的不同映射类型中的相同名称的字段[必须具有相同的映射](mapping.html#field-conflicts). 

## 字段数据类型

每个字段都有一个类型:

  * 一个简单类型，如 [`text`](text.html), [`keyword`](keyword.html), [`date`](date.html), [`long`](number.html), [`double`](number.html), [`boolean`](boolean.html) 或 [`ip`](ip.html). 
  * 一个JSONS对象， [`object`](object.html) 或 [`nested`](nested.html). 
  * 一个特殊别名 [`geo_point`](geo-point.html), [`geo_shape`](geo-shape.html), 或 [`completion`](search-suggesters-completion.html). 


为了不同的目的在同一个索引的字段使用不同的字段类型是很有用的，如，使用`string`进行[索引 indexed](mapping-index.html)，`text`类型可用作全文查询,还有`keyword`类型可用作排序和聚合分析。另外，你还可以对一个`string`类型的字段使用不同的分词器，如 [`标准 standard` 分词器](analysis-standard-analyzer.html)，[`英文 english`](analysis-lang-analyzer.html#english-analyzer) 分词器, 还有 the [`法语 french` 分词器](analysis-lang-analyzer.html#french-analyzer).

这是_multi-fields_的目的。 大多数数据类型通过[`fields`](multi-fields.html)参数支持多字段。

### 防止映射错误的设置

以下设置允许您限制可以手动或动态创建的字段映射的数量，以防止不良文档导致映射发生错误：

`index.mapping.total_fields.limit`
    
     一个索引最大的映射数，默认值是`1000`.
`index.mapping.depth.limit`
    
    一个字段的嵌套对象的深度：如果都定义在根下，则深度为1，如果包含了一个单结构的对象则是2，默认值是`20`.
`index.mapping.nested_fields.limit`

     索引中嵌套字段的最大数量，默认为50。 使用100个嵌套字段索引1文档实际上索引101个文档，因为每个嵌套文档都被编入索引为单独的隐藏文档。 

## 动态映射

字段和映射关系不一定要在使用前进行定义，可以使用_动态映射_。一个新的映射关系和新字段会在索引一个新文档被默认自动添加，新字段可以添加到`mapping`顶层元素和[`object`](object.html) 还有 [`nested`](nested.html) 中。

[动态映射](dynamic-mapping.html) 配置可以自定义新类型(type)和新字段的关系。

## 显示映射 Explicit mappings

你比ES使用猜的方式更加了解你的数据，所以虽然对于开始动态映射是有用的，但是在某些时候你还是需要进行指定你自己的映射关系。

你可以在创建索引的时候指定映射关系和字段类型，你也可以在已经存在索引的前提下使用[PUT mapping API](indices-put-mapping.html)进行添加映射关系和字段映射。

## 更新映射关系


**现有的类型和字段映射不能更新**。更改映射将意味着已经索引的文档无效。相反，您应该使用正确的映射创建新的索引，并将数据重新索引到该索引中。

## 字段跨映射类型共享

映射类型用于对字段进行分组，但是每种映射类型中的字段并不相互独立。 字段必须满足下面的条件：

  * 相同的名字
  * 在同一个索引中
  * 不同的映射类型
  * 映射相同的字段
  * 必须是相同的映射关系。 

如果`user`和`blogpost`映射类型中都存在`title`字段，`title`字段必须在每个类型中具有完全相同的映射。 这个规则的例外只有[`copy_to`](copy-to.html)，[`dynamic`](dynamic.html)，[`enabled`](enabled.html)，[`ignore_above`](ignore -above.html)，[`include_in_all`](include-in-all.html)和[`properties`](properties.html)参数，其每个字段可能有自己不同的设置。

通常，具有相同名称的字段也包含相同类型的数据，因此具有相同的映射不是问题。 当出现冲突时，可以通过选择更多的描述性名称来解决，比如`user_title`和`blog_title`。

## 举个映射关系的例子

上述示例的映射可以在创建索引时指定，如下所示：    
    
    PUT my_index 
    {
      "mappings": {
        "user": { 
          "_all":       { "enabled": false  }, 
          "properties": { 
            "title":    { "type": "text"  }, 
            "name":     { "type": "text"  }, 
            "age":      { "type": "integer" }  
          }
        },
        "blogpost": { 
          "_all":       { "enabled": false  }, 
          "properties": { 
            "title":    { "type": "text"  }, 
            "body":     { "type": "text"  }, 
            "user_id":  {
              "type":   "keyword" 
            },
            "created":  {
              "type":   "date", 
              "format": "strict_date_optional_time||epoch_millis"
            }
          }
        }
      }
    }