##  查看节点信息 cat nodes

`nodes`命令显示集群拓扑。 例如    
    
    GET /_cat/nodes?v

响应:    
    
    ip        heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
    127.0.0.1           65          99  42    3.07                  mdi       *      mJw06l1

前几列信息(`ip`, `heap.percent`, `ram.percent`, `cpu`, `load_*`) 让你可以了存活的节点和简单的性能统计信息。

后几列 (`node.role`, `master`, and `name`) 列提供了辅助信息，在整个群集，特别是大型群集中，往往是有用的。 比如可以知道有多少个有资格成为主节点的节点？


### 详细列说明

以下是可以传递给`nodes?h=`的已有标题的详尽列表，用于检索有序列中的相关详细信息。 如果没有指定标题，那么将显示标记为默认显示的标题。 如果指定了任何头部，则不使用默认值。

为简洁起见，别名可以用来代替完整的标题名称。 除非指定了不同的顺序（例如，`h = pid，id`与`h = id，pid`），否则列按照下面列出的顺序出现。

指定标题时，标题不会默认放在输出中。 要在输出中显示标题，请使用详细模式（`v`）。 标题名称将与提供的值匹配（例如，“pid”与“p”）。 例如：
    
    
    GET /_cat/nodes?v&h=id,ip,port,v,m

响应:
    
    
    id   ip        port  v         m
    veJR 127.0.0.1 59938 5.4.3 *

标题名称 | 别名 | 默认显示 | 描述 | 例如  
---|---|---|---|---    
`id` |  `nodeId` |  否 |  节点ID |  k0zy    
`pid` |  `p` |  否 |  进程ID |  13061    
`ip` |  `i` |  是 |  IP地址 |  127.0.1.1    
`port` |  `po` |  否 |  绑定端口 |  9300    
`http_address` |  `http` |  否 |  绑定地址 |  127.0.0.1:9200    
`version` |  `v` |  否 |  ES版本 |  5.4.3    
`build` |  `b` |  否 | ES构建hash值 |  5c03844    
`jdk` |  `j` |  否 |  java版本 |  1.8.0    
`disk.avail` |  `d`, `disk`, `diskAvail` |  否 | 磁盘可用空间 |  1.8gb    
`heap.current` |  `hc`, `heapCurrent` |  否 |  已经使用的堆（heap）内存 |  311.2mb    
`heap.percent` |  `hp`, `heapPercent` |  是 |  已使用的堆（heap）内存占总堆内存的百分比 |  7    
`heap.max` |  `hm`, `heapMax` |  否 |  配置的最大堆内存 |  1015.6mb    
`ram.current` |  `rc`, `ramCurrent` |  否 |  使用总内存 |  513.4mb    
`ram.percent` |  `rp`, `ramPercent` |  是 |  使用内存占用总内存的百分比|  47    
`ram.max` |  `rm`, `ramMax` |  否 |  总内存|  2.9gb    
`file_desc.current` |  `fdc`, `fileDescriptorCurrent` |  否 |  已使用的文件描述符 |  123    
`file_desc.percent` |  `fdp`, `fileDescriptorPercent` |  是 |  已使用的文件描述符占总文件描述符百分比 |  1    
`file_desc.max` |  `fdm`, `fileDescriptorMax` |  否 | 最大的文件描述符 |  1024    
`cpu` |  |  否 |  最近CPU使用百分比，展示形式为百分比 |  12    
`load_1m` |  `l` |  否 |  最近一分钟平均加载量 |  0.22    
`load_5m` |  `l` |  否 |  最近五分钟平均加载量 |  0.78    
`load_15m` |  `l` |  否 | 最近十五分钟平均加载量 |  1.24    
`uptime` |  `u` |  否 |  节点启动时间 |  17.3m    
`node.role` |  `r`, `role`, `nodeRole` |  是 |  Master eligible node (m); Data node (d); Ingest node (i); Coordinating node only (-) |  mdi    
`master` |  `m` |  是 |  Elected master (\*); Not elected master (-) |  *    
`name` |  `n` |  是 |  否de name |  I8hydUG    
`completion.size` |  `cs`, `completionSize` |  否 |  完成的大小 |  0b    
`fielddata.memory_size` |  `fm`, `fielddataMemory` |  否 |  使用的字段数据缓存大小 |  0b    
`fielddata.evictions` |  `fe`, `fielddataEvictions` |  否 |  使用的字段数据缓存过期次数|  0    
`query_cache.memory_size` |  `qcm`, `queryCacheMemory` |  否 | 已使用的query缓存的内存过期次数 |  0b    
`query_cache.evictions` |  `qce`, `queryCacheEvictions` |  否 |  已使用的query缓存的内存大小 |  0    
`request_cache.memory_size` |  `rcm`, `requestCacheMemory` |  否 |  请求缓存（cache）使用的内存 |  0b    
`request_cache.evictions` |  `rce`, `requestCacheEvictions` |  否 |  请求缓存（cache）使用的内存数量 |  0    
`request_cache.hit_count` |  `rchc`, `requestCacheHitCount` |  否 | 请求缓存（cache）使用的内存数量命中数 |  0    
`request_cache.miss_count` |  `rcmc`, `requestCacheMissCount` |  否 |  请求缓存（cache）使用的内存数量命中失败数 |  0    
`flush.total` |  `ft`, `flushTotal` |  否 |  flushes次数 |  1    
`flush.total_time` |  `ftt`, `flushTotalTime` |  否 |  flush所花费的时间 |  1    
`get.current` |  `gc`, `getCurrent` |  否 |  当前的get操作 |  0    
`get.time` |  `gti`, `getTime` |  否 |   get操作花费的总时间 |  14ms    
`get.total` |  `gto`, `getTotal` |  否 |  get操作总数|  2    
`get.exists_time` |  `geti`, `getExistsTime` |  否 |  get操作成功花费的时间 |  14ms    
`get.exists_total` |  `geto`, `getExistsTotal` |  否 |  get操作成功次数 |  2    
`get.missing_time` |  `gmti`, `getMissingTime` |  否 |  get操作成功失败的时间  |  0s    
`get.missing_total` |  `gmto`, `getMissingTotal` |  否 |  get操作成功失败的次数 |  1    
`indexing.delete_current` |  `idc`, `indexingDeleteCurrent` |  否 | 当前删除操作的次数 |  0    
`indexing.delete_time` |  `idti`, `indexingDeleteTime` |  否 |  删除操作花费的时间 |  2ms    
`indexing.delete_total` |  `idto`, `indexingDeleteTotal` |  否 |  删除操作的数量 |  2    
`indexing.index_current` |  `iic`, `indexingIndexCurrent` |  否 |  当前索引操作的数量 |  0    
`indexing.index_time` |  `iiti`, `indexingIndexTime` |  否 |  索引花费的时间 |  134ms    
`indexing.index_total` |  `iito`, `indexingIndexTotal` |  否 | 索引的操作次数 |  1    
`indexing.index_failed` |  `iif`, `indexingIndexFailed` |  否 |  索引操作失败的次数 |  0    
`merges.current` |  `mc`, `mergesCurrent` |  否 |  当前合并的操作 |  0    
`merges.current_docs` |  `mcd`, `mergesCurrentDocs` |  否 |  当前合并文档的数据 |  0    
`merges.current_size` |  `mcs`, `mergesCurrentSize` |  否 |  当前合并的操作数量 |  0b    
`merges.total` |  `mt`, `mergesTotal` |  否 | 已经完成的合并操作 |  0    
`merges.total_docs` |  `mtd`, `mergesTotalDocs` |  否 | 合并文档的数量 |  0    
`merges.total_size` |  `mts`, `mergesTotalSize` |  否 |  当前合并的数量 |  0b    
`merges.total_time` |  `mtt`, `mergesTotalTime` |  否 |  合并段花费的时间 |  0s    
`refresh.total` |  `rto`, `refreshTotal` |  否 | refreshes的次数 |  16    
`refresh.time` |  `rti`, `refreshTime` |  否 |  refreshes的所花费的时间 |  91ms    
`script.compilations` |  `scrcc`, `scriptCompilations` |  否 |  Total script compilations |  17    
`script.cache_evictions` |  `scrce`, `scriptCacheEvictions` |  否 |  Total compiled scripts evicted from cache |  6    
`search.fetch_current` |  `sfc`, `searchFetchCurrent` |  否 |  Current fetch phase operations |  0    
`search.fetch_time` |  `sfti`, `searchFetchTime` |  否 |  Time spent in fetch phase |  37ms    
`search.fetch_total` |  `sfto`, `searchFetchTotal` |  否 |  Number of fetch operations |  7    
`search.open_contexts` |  `so`, `searchOpenContexts` |  否 | 打开的查询上下文 |  0    
`search.query_current` |  `sqc`, `searchQueryCurrent` |  否 |  Current query phase operations |  0    
`search.query_time` |  `sqti`, `searchQueryTime` |  否 |  Time spent in query phase |  43ms    
`search.query_total` |  `sqto`, `searchQueryTotal` |  否 |  查询操作的个数 |  9    
`search.scroll_current` |  `scc`, `searchScrollCurrent` |  否 |  当前打开的滚动上下文 |  2    
`search.scroll_time` |  `scti`, `searchScrollTime` |  否 |  Time scroll contexts held open |  2m    
`search.scroll_total` |  `scto`, `searchScrollTotal` |  否 |  完成滚动的上下文 |  1    
`segments.count` |  `sc`, `segmentsCount` |  否 |  段的数量 |  4    
`segments.memory` |  `sm`, `segmentsMemory` |  否 |  段使用的内存 |  1.4kb    
`segments.index_writer_memory` |  `siwm`, `segmentsIndexWriterMemory` |  否 |  索引写入器的使用内存  |  18mb    
`segments.version_map_memory` |  `svmm`, `segmentsVersionMapMemory` |  否 |  Memory used by version map |  1.0kb    
`segments.fixed_bitset_memory` |  `sfbm`, `fixedBitsetMemory` |  否 |  Memory used by fixed bit sets for nested object field types and type filters for types referred in _parent fields |  1.0kb    
`suggest.current` |  `suc`, `suggestCurrent` |  否 |  当前建议的操作的数量 |  0    
`suggest.time` |  `suti`, `suggestTime` |  否 |  建议花费的次数 |  0    
`suggest.total` |  `suto`, `suggestTotal` |  否 |  建议的次数 |  0 