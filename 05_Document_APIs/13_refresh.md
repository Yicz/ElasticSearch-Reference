## `?refresh`

[Index](docs-index_.html), [Update](docs-update.html), [Delete](docs-delete.html), 和 [Bulk](docs-bulk.html) APIs 
运支持`refresh`参数，进行控制请求的结果是否对即时查询可见，允诉赋值为：

空 或`true`

    操作发生后立即刷新相关的主分片和副本分片（而不是整个索引），以便更新的文档立即出现在搜索结果中。 这只能在仔细的思考和验证之后才能做到，从索引和搜索的角度来看，它不会导致糟糕的表现。
`wait_for`
    在响应之前，等待请求所做的更改可以被查询可见。这不会强制立即刷新，而是等待刷新。 ES自动刷新设置`index.refresh_interval`的默认值为1秒的分片。 该设置是[dynamic][dynamic](index-modules.html#dynamic-index-settings)。 在任何支持它的API上调用[_Refresh_](indices-refresh.html)API或将`refresh`设置为`true`也将导致刷新，从而导致已经运行的具有`refresh = wait_for`的请求返回。

`false` (默认) 
     不采取刷新相关的行动。 此请求所做的更改将在请求返回后的某个时间点显示出来。

### 采取刷新的策略 Choosing which setting to use

除非您有充分的理由等待更改变为可见，否则始终使用`refresh = false`，或者，因为这是默认设置，请将`refresh`参数保留在URL之外。 这是最简单和最快的选择。

如果您绝对必须使请求所做的更改与请求同步可见，那么您必须在将更多负载加载到Elasticsearch（`true`）并等待更长的响应时间（`wait_for`）之间进行选择。 这里有几点理由：

  * 对索引做的更改越多，`wait_for`保存的工作与`true`相比就越多。如果索引每次只改变一次`index.refresh_interval`，那么它就不会保存任何工作。
  * `true`会创建效率较低的索引结构（小部分），这些索引结构稍后必须合并到更高效的索引结构（较大的部分）中。意味着性能的消耗是发生在小段索引进行的查询和将小段索引合并成大段的索引。
  * 永远不要在一行中启动多个`refresh=wait_for`请求。而是用`refresh=wait_for`将它们批量放入一个批量请求中，ES将并行启动它们，并且只有当它们全部完成时才会返回。(合并多个`refresh=wait_for的请求`)
  * 如果刷新间隔设置为`-1`，即禁用自动刷新，则使用`refresh=wait_for`的请求将无限期地等待，直到某个操作导致刷新。相反，将`index.refresh_interval`设置为比`200ms`这样的默认值更短的值将会使`refresh=wait_for`恢复得更快，但是它仍然会产生效率不高的段。
  * `refresh=wait_for`只影响它所在的​​请求，但是通过立即强制刷新，`refresh=true`会影响其他正在进行的请求。一般来说，如果你有一个正在运行的系统，你不想干扰，那么`refresh=wait_for`是一个小修改。

个人总结策略优先级（不带参数或不设置>`refresh=wait_for`>`refresh或refresh=true`）

### `refresh=wait_for` 可以强制刷新

如果在已经有`index.max_refresh_listeners`（默认为1000）请求等待在该分片上刷新的情况下进入`refresh=wait_for`请求，那么该请求将表现得就像`refresh=true`相反：它会强制刷新。 这保证了当一个`refresh=wait_for`请求返回时，它的改变对于搜索是可见的，同时防止阻塞请求的未检查的资源使用。 如果一个请求因为侦听器插槽用完而被强制刷新，那么它的响应将包含`forced_refresh：true`。

无论修改分片多少次，批量请求在每个分片上只占用一个插槽。
### 示例

创建一个文档，并立即刷新，让查询可见：
    
    
    PUT /test/test/1?refresh
    {"test": "test"}
    PUT /test/test/2?refresh=true
    {"test": "test"}

单纯创建一个文档，不做刷新操作：
    
    PUT /test/test/3
    {"test": "test"}
    PUT /test/test/4?refresh=false
    {"test": "test"}

创建一个文档，并等待刷新可见后进行返回：    
    
    PUT /test/test/4?refresh=wait_for
    {"test": "test"}
