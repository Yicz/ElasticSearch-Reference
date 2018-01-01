## 脚本查询 Script Query

A query allowing to define [scripts](modules-scripting.html) as queries. They are typically used in a filter context, for example:
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "script" : {
                        "script" : {
                            "inline": "doc['num1'].value > 1",
                            "lang": "painless"
                         }
                    }
                }
            }
        }
    }

#### Custom Parameters

Scripts are compiled and cached for faster execution. If the same script can be used, just with different parameters provider, it is preferable to use the ability to pass parameters to the script itself, for example:
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "script" : {
                        "script" : {
                            "inline" : "doc['num1'].value > params.param1",
                            "lang"   : "painless",
                            "params" : {
                                "param1" : 5
                            }
                        }
                    }
                }
            }
        }
    }
