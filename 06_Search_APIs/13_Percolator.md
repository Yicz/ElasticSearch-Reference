## 过滤器

![Warning](/images/icons/warning.png)

### 在 5.0.0 后弃用. 

过滤和多过滤API已被弃用，并已被新的[`percolate` query](query-dsl-percolate-query.html)取代
Percolate and multi percolate APIs are deprecated and have been replaced by the new [

对于版本5.0.0-alpha1或之后创建的索引，过滤器自动将查询条件与过滤器查询进行索引。 这使得渗滤器能够更迅速地渗透文件。 建议重新编制任何5.0.0之前的索引来利用这个新的优化。


