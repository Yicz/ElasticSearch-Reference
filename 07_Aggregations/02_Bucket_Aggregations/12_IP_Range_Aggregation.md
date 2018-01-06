## IP范围聚合 IP Range Aggregation

类似 [日期范围聚合](search-aggregations-bucket-daterange-aggregation.html) ,IP类型字段也有一个专门的范围聚合：

例如:
    
    
    {
        "aggs" : {
            "ip_ranges" : {
                "ip_range" : {
                    "field" : "ip",
                    "ranges" : [
                        { "to" : "10.0.0.5" },
                        { "from" : "10.0.0.5" }
                    ]
                }
            }
        }
    }

响应:
    
    
    {
        ...
    
        "aggregations": {
            "ip_ranges": {
                "buckets" : [
                    {
                        "to": "10.0.0.5",
                        "doc_count": 4
                    },
                    {
                        "from": "10.0.0.5",
                        "doc_count": 6
                    }
                ]
            }
        }
    }

IP范围也可以定义为CIDR掩码：    
    
    {
        "aggs" : {
            "ip_ranges" : {
                "ip_range" : {
                    "field" : "ip",
                    "ranges" : [
                        { "mask" : "10.0.0.0/25" },
                        { "mask" : "10.0.0.127/25" }
                    ]
                }
            }
        }
    }

响应:
    
    
    {
        "aggregations": {
            "ip_ranges": {
                "buckets": [
                    {
                        "key": "10.0.0.0/25",
                        "from": "10.0.0.0",
                        "to": "10.0.0.127",
                        "doc_count": 127
                    },
                    {
                        "key": "10.0.0.127/25",
                        "from": "10.0.0.0",
                        "to": "10.0.0.127",
                        "doc_count": 127
                    }
                ]
            }
        }
    }

### 控制响应内容 Keyed Response

默认的`keyed`参数设置的是`true`,它将一个唯一的字符串键与每个桶相关联，并将范围作为字典而不是数组返回。 将`keyed`标志设置为`false`将会返回数组类型的响应：
    
    
    {
        "aggs": {
            "ip_ranges": {
                "ip_range": {
                    "field": "remote_ip",
                    "ranges": [
                        { "to" : "10.0.0.5" },
                        { "from" : "10.0.0.5" }
                    ],
                    "keyed": true
                }
            }
        }
    }

响应如下：
    
    
    {
        ...
    
        "aggregations": {
            "ip_ranges": {
                "buckets": {
                    "*-10.0.0.5": {
                        "to": "10.0.0.5",
                        "doc_count": 1462
                    },
                    "10.0.0.5-*": {
                        "from": "10.0.0.5",
                        "doc_count": 50000
                    }
                }
            }
        }
    }

It is also possible to customize the key for each range:
    
    
    {
        "aggs": {
            "ip_ranges": {
                "ip_range": {
                    "field": "remote_ip",
                    "ranges": [
                        { "key": "infinity", "to" : "10.0.0.5" },
                        { "key": "and-beyond", "from" : "10.0.0.5" }
                    ],
                    "keyed": true
                }
            }
        }
    }

响应如下：
    
    
    {
        ...
    
        "aggregations": {
            "ip_ranges": {
                "buckets": {
                    "infinity": {
                        "to": "10.0.0.5",
                        "doc_count": 1462
                    },
                    "and-beyond": {
                        "from": "10.0.0.5",
                        "doc_count": 50000
                    }
                }
            }
        }
    }
