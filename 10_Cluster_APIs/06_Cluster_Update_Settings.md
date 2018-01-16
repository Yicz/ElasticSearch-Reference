## 更新集群设置 Cluster Update Settings

允许更新群集范围的特定设置。 更新的设置可以是持久的（应用交叉重新启动）或瞬态的（不会在完全重新启动集群的情况下）。 这里是一个例子：
    
    
    PUT /_cluster/settings
    {
        "persistent" : {
            "indices.recovery.max_bytes_per_sec" : "50mb"
        }
    }

或:
    
    
    PUT /_cluster/settings?flat_settings=true
    {
        "transient" : {
            "indices.recovery.max_bytes_per_sec" : "20mb"
        }
    }

群集响应设置更新。 所以最后一个例子的回应是：    
    
    {
        ...
        "persistent" : { },
        "transient" : {
            "indices.recovery.max_bytes_per_sec" : "20mb"
        }
    }

重置持久或瞬态设置可以通过分配一个“null”值来完成。 如果瞬态设置被重置，则应用持久性设置（如果可用）。 否则，Elasticsearch将回退到在配置文件中定义的设置，或者如果不存在，则回到默认值。 这里是一个例子：

    PUT /_cluster/settings
    {
        "transient" : {
            "indices.recovery.max_bytes_per_sec" : null
        }
    }

重置设置将不会包含在群集响应中。 所以最后一个例子的回应是：
    
    
    {
        ...
        "persistent" : {},
        "transient" : {}
    }

设置也可以使用简单的通配符来重置。 例如重置所有动态的`indices.recovery`设置一个前缀可以使用：
    
    PUT /_cluster/settings
    {
        "transient" : {
            "indices.recovery.*" : null
        }
    }

可以使用以下命令返回群集范围设置
    
    GET /_cluster/settings

### 设置的优先级 Precedence of settings

暂时集群设置优先于持久集群设置，优先于在elasticsearch.yml配置文件中配置的设置。

出于这个原因，最好使用`elasticsearch.yml`文件来进行本地配置，并使用`settings` API来设置所有群集范围的设置。

可以在[Modules](modules.html)文档中找到动态可更新设置的列表。
