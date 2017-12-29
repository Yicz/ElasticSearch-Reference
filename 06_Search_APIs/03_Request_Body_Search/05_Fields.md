## 字段 Fields

![Warning](/images/icons/warning.png)

`stored_fields`参数是关于显式标记为存储在映射中的字段，默认情况下是关闭的，通常不推荐。 使用[源过滤source filtering](search-request-source-filtering.html)来选择要返回的原始源文档的子集。

允许选择性地为由搜索命中代表的每个文档加载特定的存储字段。

    
    GET /_search
    {
        "stored_fields" : ["user", "postDate"],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

通配符`*` 可以用来代表文档中所有存储的字段。

一个空的数组只会返回每个命中的`_id`和`_type`，例如：    
    
    GET /_search
    {
        "stored_fields" : [],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

如果请求的字段没有被存储（`store`映射设置为`false`），它们将被忽略。

从文档本身获取的存储字段值总是作为数组返回。 相反，像`_routing`和`_parent`这样的元数据字段永远不会以数组的形式返回。

也只有叶字段可以通过`field`选项返回。 所以对象字段不能被返回，这样的请求将失败。

脚本字段也可以自动检测并用作字段，所以可以使用`_source.obj1.field1`，尽管不推荐，因为`obj1.field1`也可以。


### 完全禁用存储的字段 Disable stored fields entirely

要完全禁用存储的字段（和元数据字段），请使用：`_none_`：    
    
    GET /_search
    {
        "stored_fields": "_none_",
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

![Note](/images/icons/note.png)

如果使用`_none_`，则不能激活[`_source`](search-request-source-filtering.html)和[`version`](search-request-version.html) 参数。
