# 设置ElasticSearch
Elasticsearch使用了约定优于配置的原则，所以只需要非常少的配置。大多数设置还可以在运行的集群使用[Cluster update API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/cluster-update-settings.html)进行更新设置。

> 特定于节点的配置文件应该包含设置(如node.name和路径),或设置一个节点需要为了能够加入集群,cluster.name和network.host等。

## 配置文件路径
Elasticsearch有两个配置文件：

用于配置Elasticsearch的elasticsearch.yml和
用于配置Elasticsearch日志记录的log4j2.properties。
这些文件位于config目录中，其位置默认为$ ES_HOME/config/。 Debian和RPM包将config目录位置设置为/etc/elasticsearch/。

config目录的位置可以使用path.conf设置进行更改，如下所示：

```sh
./bin/elasticsearch -Epath.conf=/path/to/my/config/
```

## 配置的格式
配置格式是YAML语法。这里有一个例子改变数据和日志目录的路径:

```yaml
path:
    data: /var/lib/elasticsearch
    logs: /var/log/elasticsearch
    
<!-- 另一种格式 -->
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
```

## 环境变量的引用

环境变量引用的$ {…}符号在配置文件将取代环境变量的值,例如:

```yaml
node.name:    ${HOSTNAME}
network.host: ${ES_NETWORK_HOST}
```

## 提示（prompting）配置

对于不希望存储在配置文件中的设置，可以使用值$ {prompt.text}或$ {prompt.secret}并在前台启动Elasticsearch。 $ {prompt.secret}已经禁用回显功能，因此输入的值将不会显示在您的终端中; $ {prompt.text}将允许您在输入时看到该值。例如：

```yaml
node:
  name: ${prompt.text}
```
当你启动的时候你会看到如下的输出：

```sh
Enter value for [node.name]:
```

> ### tips
> 如果在设置中使用$ {prompt.text}或$ {prompt.secret}并且该过程作为服务运行或在后台运行，Elasticsearch将不会启动。
> 

# 日志配置
Elasticsearch使用Log4j2进行日志记录。 Log4j2可以使用log4j2.properties文件进行配置。 Elasticsearch公开了三个属性$ {sys：es.logs.base_path}，$ {sys：es.logs.cluster_name}和$ {sys：es.logs.node_name}（如果节点名是通过node.name显式设置的 ）可以在配置文件中引用来确定日志文件的位置。 属性$ {sys：es.logs.base_path}将解析到日志目录，$ {sys：es.logs.cluster_name}将解析为集群名称（在默认配置中用作日志文件名的前缀），以及 $ {sys：es.logs.node_name}将解析为节点名称（如果节点名称已明确设置）。

例如，如果您的日志目录（path.logs）是/var/log/elasticsearch，并且您的集群命名为production，则$ {sys：es.logs.base_path}将解析为/ var/log/elasticsearch和$ {sys：es.logs.base_path} $ {sys：file.separator} $ {sys：es.logs.cluster_name} .log将解析为/var/log/elasticsearch/production.log。

```sh
appender.rolling.type = RollingFile 
appender.rolling.name = rolling
appender.rolling.fileName = ${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}.log 
appender.rolling.layout.type = PatternLayout
appender.rolling.layout.pattern = [%d{ISO8601}][%-5p][%-25c] %.10000m%n
appender.rolling.filePattern = ${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}-%d{yyyy-MM-dd}.log 
appender.rolling.policies.type = Policies
appender.rolling.policies.time.type = TimeBasedTriggeringPolicy 
appender.rolling.policies.time.interval = 1 
appender.rolling.policies.time.modulate = true 
```
> ### tips 
> Log4j配置会解析任何多余的空格,如果你复制粘贴这个页面上任何Log4j设置,或输入任何Log4j配置,一定要削减任何前缀和尾随的空白。

# 弃用的操作日志
除了常规日志记录外，Elasticsearch还允许您启用已弃用操作的日志记录。 例如，如果您将来需要迁移某些功能，则可以提前确定。 默认情况下，弃用日志记录是在WARN级别启用的，在此级别上将放弃所有弃用日志消息。

```sh
logger.deprecation.level = warn
```
　这将创建一个每天滚动弃用日志文件在你的日志目录。定期检查这个文件,尤其是当你打算升级到一个新的主要版本。默认日志配置已弃用日志卷卷政策,压缩后1 GB,并保留最多五个日志文件(四个滚日志,活动日志)。你可以在config/log4j2.properties禁用它，通过设置它的日志级别为error.
　
