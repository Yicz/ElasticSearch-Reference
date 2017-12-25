## Slow Log

### Search Slow Log

Shard level slow search log allows to log slow search (query and fetch phases) into a dedicated log file.

Thresholds can be set for both the query phase of the execution, and fetch phase, here is a sample:
    
    
    index.search.slowlog.threshold.query.warn: 10s
    index.search.slowlog.threshold.query.info: 5s
    index.search.slowlog.threshold.query.debug: 2s
    index.search.slowlog.threshold.query.trace: 500ms
    
    index.search.slowlog.threshold.fetch.warn: 1s
    index.search.slowlog.threshold.fetch.info: 800ms
    index.search.slowlog.threshold.fetch.debug: 500ms
    index.search.slowlog.threshold.fetch.trace: 200ms

All of the above settings are _dynamic_ and are set per-index.

By default, none are enabled (set to `-1`). Levels (`warn`, `info`, `debug`, `trace`) allow to control under which logging level the log will be logged. Not all are required to be configured (for example, only `warn` threshold can be set). The benefit of several levels is the ability to quickly "grep" for specific thresholds breached.

The logging is done on the shard level scope, meaning the execution of a search request within a specific shard. It does not encompass the whole search request, which can be broadcast to several shards in order to execute. Some of the benefits of shard level logging is the association of the actual execution on the specific machine, compared with request level.

The logging file is configured by default using the following configuration (found in `log4j2.properties`):
    
    
    appender.index_search_slowlog_rolling.type = RollingFile
    appender.index_search_slowlog_rolling.name = index_search_slowlog_rolling
    appender.index_search_slowlog_rolling.fileName = ${sys:es.logs}_index_search_slowlog.log
    appender.index_search_slowlog_rolling.layout.type = PatternLayout
    appender.index_search_slowlog_rolling.layout.pattern = [%d{ISO8601}][%-5p][%-25c] %.10000m%n
    appender.index_search_slowlog_rolling.filePattern = ${sys:es.logs}_index_search_slowlog-%d{yyyy-MM-dd}.log
    appender.index_search_slowlog_rolling.policies.type = Policies
    appender.index_search_slowlog_rolling.policies.time.type = TimeBasedTriggeringPolicy
    appender.index_search_slowlog_rolling.policies.time.interval = 1
    appender.index_search_slowlog_rolling.policies.time.modulate = true
    
    logger.index_search_slowlog_rolling.name = index.search.slowlog
    logger.index_search_slowlog_rolling.level = trace
    logger.index_search_slowlog_rolling.appenderRef.index_search_slowlog_rolling.ref = index_search_slowlog_rolling
    logger.index_search_slowlog_rolling.additivity = false

### Index Slow log

The indexing slow log, similar in functionality to the search slow log. The log file name ends with `_index_indexing_slowlog.log`. Log and the thresholds are configured in the same way as the search slowlog. Index slowlog sample:
    
    
    index.indexing.slowlog.threshold.index.warn: 10s
    index.indexing.slowlog.threshold.index.info: 5s
    index.indexing.slowlog.threshold.index.debug: 2s
    index.indexing.slowlog.threshold.index.trace: 500ms
    index.indexing.slowlog.level: info
    index.indexing.slowlog.source: 1000

All of the above settings are _dynamic_ and are set per-index.

By default Elasticsearch will log the first 1000 characters of the _source in the slowlog. You can change that with `index.indexing.slowlog.source`. Setting it to `false` or `0` will skip logging the source entirely an setting it to `true` will log the entire source regardless of size. The original `_source` is reformatted by default to make sure that it fits on a single log line. If preserving the original document format is important, you can turn off reformatting by setting `index.indexing.slowlog.reformat` to `false`, which will cause the source to be logged "as is" and can potentially span multiple log lines.

The index slow log file is configured by default in the `log4j2.properties` file:
    
    
    appender.index_indexing_slowlog_rolling.type = RollingFile
    appender.index_indexing_slowlog_rolling.name = index_indexing_slowlog_rolling
    appender.index_indexing_slowlog_rolling.fileName = ${sys:es.logs}_index_indexing_slowlog.log
    appender.index_indexing_slowlog_rolling.layout.type = PatternLayout
    appender.index_indexing_slowlog_rolling.layout.pattern = [%d{ISO8601}][%-5p][%-25c] %marker%.10000m%n
    appender.index_indexing_slowlog_rolling.filePattern = ${sys:es.logs}_index_indexing_slowlog-%d{yyyy-MM-dd}.log
    appender.index_indexing_slowlog_rolling.policies.type = Policies
    appender.index_indexing_slowlog_rolling.policies.time.type = TimeBasedTriggeringPolicy
    appender.index_indexing_slowlog_rolling.policies.time.interval = 1
    appender.index_indexing_slowlog_rolling.policies.time.modulate = true
    
    logger.index_indexing_slowlog.name = index.indexing.slowlog.index
    logger.index_indexing_slowlog.level = trace
    logger.index_indexing_slowlog.appenderRef.index_indexing_slowlog_rolling.ref = index_indexing_slowlog_rolling
    logger.index_indexing_slowlog.additivity = false