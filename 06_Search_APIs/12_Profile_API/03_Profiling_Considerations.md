## Profiling Considerations

###性能说明

就像任何分析器一样，Profile API引入了一个不可忽略的开销来搜索执行。低级别方法调用例如collect，advance和next_doc的行为可能相当昂贵，因为这些方法在紧密循环中被调用。因此，默认情况下，不应在生产设置中启用分析，并且不应将其与非分析查询时间进行比较。分析只是一个诊断工具。

也有一些特殊的Lucene优化被禁用，因为它们不适合分析。这可能会导致一些查询报告比它们的非异常对象更大的相对时间，但是与概要查询中的其他组件相比，通常不会有太大的影响。

###限制

  * 分析统计信息目前无法提供建议，高亮显示“dfs_query_then_fetch”
  * 聚合缩减阶段的分析目前不可用

  Profiler仍然是高度实验性的。 Profiler正在测试那些从未被设计为以这种方式暴露的Lucene的一部分，所以所有的结果都应该被视为尽力提供详细的诊断。我们希望随着时间的推移来改善。如果你发现明显错误的数字，奇怪的查询结构或其他错误，请报告！

