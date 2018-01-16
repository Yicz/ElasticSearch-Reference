##  集群统计信息 Cluster Stats

Cluster Stats API允许从集群的角度检索统计信息。 API返回基本的索引度量（分片数量，存储大小，内存使用情况）以及有关当前构成集群的节点（数量，角色，操作系统，jvm版本，内存使用情况，CPU和安装的插件）的信息。
    
    
    curl -XGET 'http://localhost:9200/_cluster/stats?human&pretty'

返回内容:
    
    
    {
       "timestamp": 1459427693515,
       "cluster_name": "elasticsearch",
       "status": "green",
       "indices": {
          "count": 2,
          "shards": {
             "total": 10,
             "primaries": 10,
             "replication": 0,
             "index": {
                "shards": {
                   "min": 5,
                   "max": 5,
                   "avg": 5
                },
                "primaries": {
                   "min": 5,
                   "max": 5,
                   "avg": 5
                },
                "replication": {
                   "min": 0,
                   "max": 0,
                   "avg": 0
                }
             }
          },
          "docs": {
             "count": 10,
             "deleted": 0
          },
          "store": {
             "size": "16.2kb",
             "size_in_bytes": 16684,
             "throttle_time": "0s",
             "throttle_time_in_millis": 0
          },
          "fielddata": {
             "memory_size": "0b",
             "memory_size_in_bytes": 0,
             "evictions": 0
          },
          "query_cache": {
             "memory_size": "0b",
             "memory_size_in_bytes": 0,
             "total_count": 0,
             "hit_count": 0,
             "miss_count": 0,
             "cache_size": 0,
             "cache_count": 0,
             "evictions": 0
          },
          "completion": {
             "size": "0b",
             "size_in_bytes": 0
          },
          "segments": {
             "count": 4,
             "memory": "8.6kb",
             "memory_in_bytes": 8898,
             "terms_memory": "6.3kb",
             "terms_memory_in_bytes": 6522,
             "stored_fields_memory": "1.2kb",
             "stored_fields_memory_in_bytes": 1248,
             "term_vectors_memory": "0b",
             "term_vectors_memory_in_bytes": 0,
             "norms_memory": "384b",
             "norms_memory_in_bytes": 384,
             "doc_values_memory": "744b",
             "doc_values_memory_in_bytes": 744,
             "index_writer_memory": "0b",
             "index_writer_memory_in_bytes": 0,
             "version_map_memory": "0b",
             "version_map_memory_in_bytes": 0,
             "fixed_bit_set": "0b",
             "fixed_bit_set_memory_in_bytes": 0,
             "file_sizes": {}
          },
          "percolator": {
             "num_queries": 0
          }
       },
       "nodes": {
          "count": {
             "total": 1,
             "data": 1,
             "coordinating_only": 0,
             "master": 1,
             "ingest": 1
          },
          "versions": [
             "5.4.3"
          ],
          "os": {
             "available_processors": 8,
             "allocated_processors": 8,
             "names": [
                {
                   "name": "Mac OS X",
                   "count": 1
                }
             ],
             "mem" : {
                "total" : "16gb",
                "total_in_bytes" : 17179869184,
                "free" : "78.1mb",
                "free_in_bytes" : 81960960,
                "used" : "15.9gb",
                "used_in_bytes" : 17097908224,
                "free_percent" : 0,
                "used_percent" : 100
             }
          },
          "process": {
             "cpu": {
                "percent": 9
             },
             "open_file_descriptors": {
                "min": 268,
                "max": 268,
                "avg": 268
             }
          },
          "jvm": {
             "max_uptime": "13.7s",
             "max_uptime_in_millis": 13737,
             "versions": [
                {
                   "version": "1.8.0_74",
                   "vm_name": "Java HotSpot(TM) 64-Bit Server VM",
                   "vm_version": "25.74-b02",
                   "vm_vendor": "Oracle Corporation",
                   "count": 1
                }
             ],
             "mem": {
                "heap_used": "57.5mb",
                "heap_used_in_bytes": 60312664,
                "heap_max": "989.8mb",
                "heap_max_in_bytes": 1037959168
             },
             "threads": 90
          },
          "fs": {
             "total": "200.6gb",
             "total_in_bytes": 215429193728,
             "free": "32.6gb",
             "free_in_bytes": 35064553472,
             "available": "32.4gb",
             "available_in_bytes": 34802409472
          },
          "plugins": [
            {
              "name": "analysis-icu",
              "version": "5.4.3",
              "description": "The ICU Analysis plugin integrates Lucene ICU module into elasticsearch, adding ICU relates analysis components.",
              "classname": "org.elasticsearch.plugin.analysis.icu.AnalysisICUPlugin",
              "has_native_controller": false
            },
            {
              "name": "ingest-geoip",
              "version": "5.4.3",
              "description": "Ingest processor that uses looksup geo data based on ip adresses using the Maxmind geo database",
              "classname": "org.elasticsearch.ingest.geoip.IngestGeoIpPlugin",
              "has_native_controller": false
            },
            {
              "name": "ingest-user-agent",
              "version": "5.4.3",
              "description": "Ingest processor that extracts information from a user agent",
              "classname": "org.elasticsearch.ingest.useragent.IngestUserAgentPlugin",
              "has_native_controller": false
            }
          ]
       }
    }
