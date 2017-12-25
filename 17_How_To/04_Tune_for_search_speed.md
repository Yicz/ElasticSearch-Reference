## Tune for search speed

### Give memory to the filesystem cache

Elasticsearch heavily relies on the filesystem cache in order to make search fast. In general, you should make sure that at least half the available memory goes to the filesystem cache so that elasticsearch can keep hot regions of the index in physical memory.

### Use faster hardware

If your search is I/O bound, you should investigate giving more memory to the filesystem cache (see above) or buying faster drives. In particular SSD drives are known to perform better than spinning disks. Always use local storage, remote filesystems such as `NFS` or `SMB` should be avoided. Also beware of virtualized storage such as Amazon’s `Elastic Block Storage`. Virtualized storage works very well with Elasticsearch, and it is appealing since it is so fast and simple to set up, but it is also unfortunately inherently slower on an ongoing basis when compared to dedicated local storage. If you put an index on `EBS`, be sure to use provisioned IOPS otherwise operations could be quickly throttled.

If your search is CPU-bound, you should investigate buying faster CPUs.

### Document modeling

Documents should be modeled so that search-time operations are as cheap as possible.

In particular, joins should be avoided. [`nested`](nested.html) can make queries several times slower and [parent-child](mapping-parent-field.html) relations can make queries hundreds of times slower. So if the same questions can be answered without joins by denormalizing documents, significant speedups can be expected.

### Pre-index data

You should leverage patterns in your queries to optimize the way data is indexed. For instance, if all your documents have a `price` field and most queries run [`range`](search-aggregations-bucket-range-aggregation.html) aggregations on a fixed list of ranges, you could make this aggregation faster by pre-indexing the ranges into the index and using a [`terms`](search-aggregations-bucket-terms-aggregation.html) aggregations.

For instance, if documents look like:
    
    
    PUT index/type/1
    {
      "designation": "spoon",
      "price": 13
    }

and search requests look like:
    
    
    GET index/_search
    {
      "aggs": {
        "price_ranges": {
          "range": {
            "field": "price",
            "ranges": [
              { "to": 10 },
              { "from": 10, "to": 100 },
              { "from": 100 }
            ]
          }
        }
      }
    }

Then documents could be enriched by a `price_range` field at index time, which should be mapped as a [`keyword`](keyword.html):
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "price_range": {
              "type": "keyword"
            }
          }
        }
      }
    }
    
    PUT index/type/1
    {
      "designation": "spoon",
      "price": 13,
      "price_range": "10-100"
    }

And then search requests could aggregate this new field rather than running a `range` aggregation on the `price` field.
    
    
    GET index/_search
    {
      "aggs": {
        "price_ranges": {
          "terms": {
            "field": "price_range"
          }
        }
      }
    }

### Mappings

The fact that some data is numeric does not mean it should always be mapped as a [numeric field](number.html). Typically, fields storing identifiers such as an `ISBN` or any number identifying a record from another database, might benefit from being mapped as [`keyword`](keyword.html) rather than `integer` or `long`.

### Avoid scripts

In general, scripts should be avoided. If they are absolutely needed, you should prefer the `painless` and `expressions` engines.

### Search rounded dates

Queries on date fields that use `now` are typically not cacheable since the range that is being matched changes all the time. However switching to a rounded date is often acceptable in terms of user experience, and has the benefit of making better use of the query cache.

For instance the below query:
    
    
    PUT index/type/1
    {
      "my_date": "2016-05-11T16:30:55.328Z"
    }
    
    GET index/_search
    {
      "query": {
        "constant_score": {
          "filter": {
            "range": {
              "my_date": {
                "gte": "now-1h",
                "lte": "now"
              }
            }
          }
        }
      }
    }

could be replaced with the following query:
    
    
    GET index/_search
    {
      "query": {
        "constant_score": {
          "filter": {
            "range": {
              "my_date": {
                "gte": "now-1h/m",
                "lte": "now/m"
              }
            }
          }
        }
      }
    }

In that case we rounded to the minute, so if the current time is `16:31:29`, the range query will match everything whose value of the `my_date` field is between `15:31:00` and `16:31:59`. And if several users run a query that contains this range in the same minute, the query cache could help speed things up a bit. The longer the interval that is used for rounding, the more the query cache can help, but beware that too aggressive rounding might also hurt user experience.

![Note](images/icons/note.png)

It might be tempting to split ranges into a large cacheable part and smaller not cacheable parts in order to be able to leverage the query cache, as shown below:
    
    
    GET index/_search
    {
      "query": {
        "constant_score": {
          "filter": {
            "bool": {
              "should": [
                {
                  "range": {
                    "my_date": {
                      "gte": "now-1h",
                      "lte": "now-1h/m"
                    }
                  }
                },
                {
                  "range": {
                    "my_date": {
                      "gt": "now-1h/m",
                      "lt": "now/m"
                    }
                  }
                },
                {
                  "range": {
                    "my_date": {
                      "gte": "now/m",
                      "lte": "now"
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }

However such practice might make the query run slower in some cases since the overhead introduced by the `bool` query may defeat the savings from better leveraging the query cache.

### Force-merge read-only indices

Indices that are read-only would benefit from being [merged down to a single segment](indices-forcemerge.html). This is typically the case with time-based indices: only the index for the current time frame is getting new documents while older indices are read-only.

![Important](images/icons/important.png)

Don’t force-merge indices that are still being written to — leave merging to the background merge process.

### Warm up global ordinals

Global ordinals are a data-structure that is used in order to run [`terms`](search-aggregations-bucket-terms-aggregation.html) aggregations on [`keyword`](keyword.html) fields. They are loaded lazily in memory because elasticsearch does not know which fields will be used in `terms` aggregations and which fields won’t. You can tell elasticsearch to load global ordinals eagerly at refresh-time by configuring mappings as described below:
    
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "keyword",
              "eager_global_ordinals": true
            }
          }
        }
      }
    }

### Warm up the filesystem cache

If the machine running elasticsearch is restarted, the filesystem cache will be empty, so it will take some time before the operating system loads hot regions of the index into memory so that search operations are fast. You can explicitly tell the operating system which files should be loaded into memory eagerly depending on the file extension using the [`index.store.preload`](index-modules-store.html#file-system) setting.

![Warning](images/icons/warning.png)

Loading data into the filesystem cache eagerly on too many indices or too many files will make search _slower_ if the filesystem cache is not large enough to hold all the data. Use with caution.
