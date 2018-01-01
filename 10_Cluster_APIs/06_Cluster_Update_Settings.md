## 更新集群设置 Cluster Update Settings

Allows to update cluster wide specific settings. Settings updated can either be persistent (applied cross restarts) or transient (will not survive a full cluster restart). Here is an example:
    
    
    PUT /_cluster/settings
    {
        "persistent" : {
            "indices.recovery.max_bytes_per_sec" : "50mb"
        }
    }

Or:
    
    
    PUT /_cluster/settings?flat_settings=true
    {
        "transient" : {
            "indices.recovery.max_bytes_per_sec" : "20mb"
        }
    }

The cluster responds with the settings updated. So the response for the last example will be:
    
    
    {
        ...
        "persistent" : { },
        "transient" : {
            "indices.recovery.max_bytes_per_sec" : "20mb"
        }
    }

Resetting persistent or transient settings can be done by assigning a `null` value. If a transient setting is reset, the persistent setting is applied if available. Otherwise Elasticsearch will fallback to the setting defined at the configuration file or, if not existent, to the default value. Here is an example:
    
    
    PUT /_cluster/settings
    {
        "transient" : {
            "indices.recovery.max_bytes_per_sec" : null
        }
    }

Reset settings will not be included in the cluster response. So the response for the last example will be:
    
    
    {
        ...
        "persistent" : {},
        "transient" : {}
    }

Settings can also be reset using simple wildcards. For instance to reset all dynamic `indices.recovery` setting a prefix can be used:
    
    
    PUT /_cluster/settings
    {
        "transient" : {
            "indices.recovery.*" : null
        }
    }

Cluster wide settings can be returned using:
    
    
    GET /_cluster/settings

### Precedence of settings

Transient cluster settings take precedence over persistent cluster settings, which take precedence over settings configured in the `elasticsearch.yml` config file.

For this reason it is preferrable to use the `elasticsearch.yml` file only for local configurations, and set all cluster-wider settings with the `settings` API.

A list of dynamically updatable settings can be found in the [Modules](modules.html) documentation.
