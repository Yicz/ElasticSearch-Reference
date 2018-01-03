## 强制合并 Force Merge

强制合并API允许通过API强制合并一个或多个索引。 合并涉及Lucene索引在每个分片中保存的分段数量。 强制合并操作允许通过合并来减少分段的数量。

此请求会阻止，直到合并完成。 如果http连接丢失，请求将在后台继续，并且任何新请求都将被阻塞，直到强制合并完成。

    POST /twitter/_forcemerge

### 请求参数 Request Parameters

强制合并API接受以下请求参数：

`max_num_segments`| 要合并到的段的数量。 要完全合并索引，请将其设置为“1”。 默认只是检查合并是否需要执行，如果是的话，执行它。
---|---  
`only_expunge_deletes`| 合并过程应该只删除其中有删除的段。 在Lucene中，文档不会从分段中删除，只会被标记为已删除。 在段的合并过程中，会创建一个没有这些删除的新段。 该标志只允许合并具有删除的段。 默认为“false”。 请注意，这不会覆盖`index.merge.policy.expunge_deletes_allowed`值。     
`flush`| 强制合并后应该执行刷新。 默认为`true`。   
  
### 多索引操作 Multi Index

强制合并API可以在一次请求中设置多个索引或者全部(`_all`)索引 
    
    POST /kimchy,elasticsearch/_forcemerge
    
    POST /_forcemerge
