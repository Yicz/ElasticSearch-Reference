## 配置ES

ES提供了很好的默认配置，在通常情况下，我们只要配置一小部分设置。同时大部分的配置可以通过[_Cluster Update Settings_](cluster-update-settings.html) API进行动态修改。

这一小部分的配置是节点的特殊指定，如`node.name`和`path`,它们是一个集群中节点的唯一设置，还有配置同一个集群的设置，如：`cluster.name` and `network.host`.

### 配置文件路径

ES只有两个配置文件:

  * `elasticsearch.yml` 配置ES
  * `log4j2.properties` 配置ES的日志. 


他们默认位于`$ES_HOME/config/`. Debain系和RPM系列的系统是默认`/etc/elasticsearch/`.

通过命令启动的时候我们可以修改配置文件所有的路径，使用的参数是`path.conf`,如下：
    
    ./bin/elasticsearch -Epath.conf=/path/to/my/config/

### 配置文件格式

ES配置文件的格式是[YAML](http://www.yaml.org/). 这里列举了修改数据和日志文件位置的例子：
    
    path:
        data: /var/lib/elasticsearch
        logs: /var/log/elasticsearch

下面的例子与上面的意思一致:
    
    path.data: /var/lib/elasticsearch
    path.logs: /var/log/elasticsearch

### 使用环境变量代替

在配置文件中可以通过`${name}`占位符来引用环境变量。举例：    
    
    node.name:    ${HOSTNAME}
    network.host: ${ES_NETWORK_HOST}

### 提示配置
提示配置是指在ES的启动时候，提示你给出参数进行配置启动过程，使用的方式是：`${prpmpt.text}`或`${prompt.secret}`(密码，输入过程不可见)：举例：    
    
    node:
      name: ${prompt.text}

当你启动ES的时候，你可以看到console中输出如下提示：    
    
    Enter value for [node.name]:

使用了提示配置的ES，不能再使用后台服务的形式进行启动。

## 日志配置

ES的日志是使用 [Log4j 2](https://logging.apache.org/log4j/2.x/) . Log4j 2 使用log4j2.properties的配置文件。ES暴露出三个日志配置属性：`${sys:es.logs.base_path}`, `${sys:es.logs.cluster_name}`, and `${sys:es.logs.node_name}`（如果指定了node.name则跟随ES的设置），`${sys:es.logs.base_path}`配置的是日志的目录文件路径。`${sys:es.logs.cluster_name}`和`${sys:es.logs.node_name}`配置日志文件的文件名前缀

例如：你日志目录配置`path.logs`为`/var/log/elasticearch`和你的集群名字是`production`,`$sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}.log`会被解析为`/var/log/elasticsearch/production.log`.
    
    
    appender.rolling.type = RollingFile  文件追加器类型  
    appender.rolling.name = rolling
    appender.rolling.fileName = ${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}.log  配置当前日志名称格式：`/var/log/elasticsearch/production.log` 
    appender.rolling.layout.type = PatternLayout
    appender.rolling.layout.pattern = [%d{ISO8601}][%-5p][%-25c] %.10000m%n
    appender.rolling.filePattern = ${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}-%d{yyyy-MM-dd}.log  滚动的日志名称（旧的日志名称格式）`/var/log/elasticsearch/production-yyyy-MM-dd.log`  
    appender.rolling.policies.type = Policies
    appender.rolling.policies.time.type = TimeBasedTriggeringPolicy 使用时间滚动策略  
    appender.rolling.policies.time.interval = 1 每天滚动一次   

    appender.rolling.policies.time.modulate = true  时间对齐


  
在log4j配置文件中，空格会被严格当作标准字符来执行。所以请严格检查你的log4j配置文件。

如果你在`appender.rolling.filePattern`使用了`gz`事`zip`文件后缀，日志文件将会被进行压缩。

如果你还想只保留一定时期的日志，你可以使用一个滚动的删除行为策略，举例如下：    
    
    appender.rolling.strategy.type = DefaultRolloverStrategy 配置策略类型
    appender.rolling.strategy.action.type = Delete 策略行为为删除
    appender.rolling.strategy.action.basepath = ${sys:es.logs.base_path} 日志基本路径    appender.rolling.strategy.action.condition.type = IfLastModified 匹配最后修改时候
    appender.rolling.strategy.action.condition.age = 7D 7天内的数据
    appender.rolling.strategy.action.PathConditions.type = IfFileName 匹配条件为名字    appender.rolling.strategy.action.PathConditions.glob = ${sys:es.logs.cluster_name}-* 全局匹配模式
     

匹配了全局匹配模式：`${sys:es.logs.cluster_name}-*`将会删除文件。 
在ES的配置路径中的log4j2.properties可以加载多个

### 弃用日志

除了正常的日志，ES允许你启动日志的级别进行不同日志的输出。默认的日志级别是WARN.
    
    logger.deprecation.level = warn


这将在日志目录中创建一个每日滚动弃用日志文件。定期检查此文件，特别是当您打算升级到新的主要版本时。

默认日志记录配置已将弃用日志的滚动策略设置为在1 GB之后进行滚动和压缩，并最多保留五个日志文件（四个滚动日志和活动日志）。

你可以在`config / log4j2.properties`文件中通过设置deprecation log level为`error`来禁用它。
