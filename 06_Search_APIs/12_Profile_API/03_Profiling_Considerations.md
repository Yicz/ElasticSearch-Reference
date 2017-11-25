## Profiling Considerations

### Performance Notes

Like any profiler, the Profile API introduces a non-negligible overhead to search execution. The act of instrumenting low-level method calls such as `collect`, `advance` and `next_doc` can be fairly expensive, since these methods are called in tight loops. Therefore, profiling should not be enabled in production settings by default, and should not be compared against non-profiled query times. Profiling is just a diagnostic tool.

There are also cases where special Lucene optimizations are disabled, since they are not amenable to profiling. This could cause some queries to report larger relative times than their non-profiled counterparts, but in general should not have a drastic effect compared to other components in the profiled query.

### Limitations

  * Profiling statistics are currently not available for suggestions, highlighting, `dfs_query_then_fetch`
  * Profiling of the reduce phase of aggregation is currently not available 
  * The Profiler is still highly experimental. The Profiler is instrumenting parts of Lucene that were never designed to be exposed in this manner, and so all results should be viewed as a best effort to provide detailed diagnostics. We hope to improve this over time. If you find obviously wrong numbers, strange query structures or other bugs, please report them! 


