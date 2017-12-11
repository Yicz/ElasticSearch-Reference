## Multiple Indices


大多数引用`index`参数的API支持跨越多个索引执行，使用简单的`test1，test2，test3`表示法（或所有索引的`_all`）。它也支持通配符，例如`test *`或`* test`或`te * t`或`* test *`，并且能够“添加”（`+`）和“remove”（``` ），例如：`+ test *， - test3`。

所有多索引API都支持以下url查询字符串参数：

`ignore_unavailable`控制是否忽略任何指定的索引不可用，这包括不存在的索引或闭合的索引。可以指定“true”或“false”。
     

`allow_no_indices`
控制如果通配符表达式结果没有具体的索引，是否失败。可以指定“true”或“false”。例如，如果指定了通配符表达式“foo *”，并且没有以“foo”开头的索引，则取决于此设置，请求将失败。这个设置也适用于`_all`，`*`或者没有指定索引的情况。这个设置也适用于别名，以防别名指向一个封闭的索引。

`expand_wildcards`
控制什么样的具体指标通配符指数表达式扩展到。如果指定了`open`，那么通配符表达式将被扩展为仅打开索引，如果指定了
`closed`，那么通配符表达式只扩展到闭合索引。也可以指定两个值（`open，closed`）以扩展到所有的索引。
如果指定了none，通配符扩展将被禁用，如果指定了all，通配符表达式将扩展到所有的索引（这相当于指定“open”，“closed”）。

上述参数的默认设置取决于正在使用的api。

The defaults settings for the above parameters depend on the api being used.
单索引APIs如 [Document APIs](docs.html "Document APIs")和[single-index `alias` APIs](indices-aliases.html "Index Aliases") 不支持多索引操作
