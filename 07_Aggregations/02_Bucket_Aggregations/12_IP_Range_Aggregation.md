## IP Range Aggregation

Just like the dedicated [date](search-aggregations-bucket-daterange-aggregation.html "Date Range Aggregation") range aggregation, there is also a dedicated range aggregation for IP typed fields:

Example:
    
    
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

Response:
    
    
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

IP ranges can also be defined as CIDR masks:
    
    
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

Response:
    
    
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

### Keyed Response

Setting the `keyed` flag to `true` will associate a unique string key with each bucket and return the ranges as a hash rather than an array:
    
    
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

Response:
    
    
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

Response:
    
    
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
