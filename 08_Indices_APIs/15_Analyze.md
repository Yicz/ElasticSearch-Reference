## 分析 Analyze

对文本执行分析过程并返回文本的分解结果。

可以在没有指定众多内置分析器之一的索引的情况下使用：
    
    GET _analyze
    {
      "analyzer" : "standard",
      "text" : "this is a test"
    }

如果文本参数是作为字符串数组提供的，则将其作为多值字段进行分析。    
    
    GET _analyze
    {
      "analyzer" : "standard",
      "text" : ["this is a test", "the second text"]
    }

或者使用分词器，符号过滤器和字符过滤器构建自定义瞬态分析器。 符号过滤器可以使用较短的_filter_参数名称：
    
    GET _analyze
    {
      "tokenizer" : "keyword",
      "filter" : ["lowercase"],
      "text" : "this is a test"
    }
    
    
    GET _analyze
    {
      "tokenizer" : "keyword",
      "filter" : ["lowercase"],
      "char_filter" : ["html_strip"],
      "text" : "this is a <b>test</b>"
    }

![Warning](/images/icons/warning.png)

### Deprecated in 5.0.0. 
使用`filter`/`char_filter`代替了`filters`/`char_filters` 并移除了`token_filters` 

自定义分词器，符号过滤器和字符过滤器可以在请求主体中进行指定，如下所示：

    GET _analyze
    {
      "tokenizer" : "whitespace",
      "filter" : ["lowercase", {"type": "stop", "stopwords": ["a", "is", "this"]}],
      "text" : "this is a test"
    }

它也可以针对特定的索引运行：    
    
    GET twitter/_analyze
    {
      "text" : "this is a test"
    }

以上将使用与`twitter`索引关联的默认索引分析器对`this is a test`文本进行分析。 也可以使用`analyzer`参数来指定的分析仪：
    
    GET twitter/_analyze
    {
      "analyzer" : "whitespace",
      "text" : "this is a test"
    }

而且，分析器可以基于字段映射来导出，例如：    
    
    GET twitter/_analyze
    {
      "field" : "obj1.field1",
      "text" : "this is a test"
    }

将导致分析使用`obj1.field1`（如果没有，默认的索引分析器）映射中配置的分析器。

![Warning](/images/icons/warning.png)在5.1.0请求参数中弃用，并将在下一个主要版本中删除。 请使用JSON参数而不是请求参数。

所有参数也可以作为请求参数提供。 例如：
    
    GET /_analyze?tokenizer=keyword&filter=lowercase&text=this+is+a+test

为了向后兼容，我们也接受文本参数作为请求的主体，只要它不以`{`开始：    
    
    curl -XGET 'localhost:9200/_analyze?tokenizer=keyword&filter=lowercase&char_filter=reverse' -d 'this is a test' -H 'Content-Type: text/plain'

![Warning](/images/icons/warning.png)在5.1.0中不推荐使用text参数作为请求的主体，这个特性将在下一个主版本中被删除。 请使用JSON文本参数。
