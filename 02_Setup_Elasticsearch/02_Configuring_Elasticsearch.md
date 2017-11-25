## Configuring Elasticsearch

Elasticsearch ships with good defaults and requires very little configuration. Most settings can be changed on a running cluster using the [_Cluster Update Settings_](cluster-update-settings.html "Cluster Update Settings") API.

The configuration files should contain settings which are node-specific (such as `node.name` and paths), or settings which a node requires in order to be able to join a cluster, such as `cluster.name` and `network.host`.

### Config file location

Elasticsearch has two configuration files:

  * `elasticsearch.yml` for configuring Elasticsearch, and 
  * `log4j2.properties` for configuring Elasticsearch logging. 



These files are located in the config directory, whose location defaults to `$ES_HOME/config/`. The Debian and RPM packages set the config directory location to `/etc/elasticsearch/`.

The location of the config directory can be changed with the `path.conf` setting, as follows:
    
    
    ./bin/elasticsearch -Epath.conf=/path/to/my/config/

### Config file format

The configuration format is [YAML](http://www.yaml.org/). Here is an example of changing the path of the data and logs directories:
    
    
    path:
        data: /var/lib/elasticsearch
        logs: /var/log/elasticsearch

Settings can also be flattened as follows:
    
    
    path.data: /var/lib/elasticsearch
    path.logs: /var/log/elasticsearch

### Environment variable substitution

Environment variables referenced with the `${...}` notation within the configuration file will be replaced with the value of the environment variable, for instance:
    
    
    node.name:    ${HOSTNAME}
    network.host: ${ES_NETWORK_HOST}

### Prompting for settings

For settings that you do not wish to store in the configuration file, you can use the value `${prompt.text}` or `${prompt.secret}` and start Elasticsearch in the foreground. `${prompt.secret}` has echoing disabled so that the value entered will not be shown in your terminal; `${prompt.text}` will allow you to see the value as you type it in. For example:
    
    
    node:
      name: ${prompt.text}

When starting Elasticsearch, you will be prompted to enter the actual value like so:
    
    
    Enter value for [node.name]:

![Note](images/icons/note.png)

Elasticsearch will not start if `${prompt.text}` or `${prompt.secret}` is used in the settings and the process is run as a service or in the background.

## Logging configuration

Elasticsearch uses [Log4j 2](https://logging.apache.org/log4j/2.x/) for logging. Log4j 2 can be configured using the log4j2.properties file. Elasticsearch exposes three properties, `${sys:es.logs.base_path}`, `${sys:es.logs.cluster_name}`, and `${sys:es.logs.node_name}` (if the node name is explicitly set via `node.name`) that can be referenced in the configuration file to determine the location of the log files. The property `${sys:es.logs.base_path}` will resolve to the log directory, `${sys:es.logs.cluster_name}` will resolve to the cluster name (used as the prefix of log filenames in the default configuration), and `${sys:es.logs.node_name}` will resolve to the node name (if the node name is explicitly set).

For example, if your log directory (`path.logs`) is `/var/log/elasticsearch` and your cluster is named `production` then `${sys:es.logs.base_path}` will resolve to `/var/log/elasticsearch` and `${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}.log` will resolve to `/var/log/elasticsearch/production.log`.
    
    
    appender.rolling.type = RollingFile ![](images/icons/callouts/1.png)
    appender.rolling.name = rolling
    appender.rolling.fileName = ${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}.log ![](images/icons/callouts/2.png)
    appender.rolling.layout.type = PatternLayout
    appender.rolling.layout.pattern = [%d{ISO8601}][%-5p][%-25c] %.10000m%n
    appender.rolling.filePattern = ${sys:es.logs.base_path}${sys:file.separator}${sys:es.logs.cluster_name}-%d{yyyy-MM-dd}.log ![](images/icons/callouts/3.png)
    appender.rolling.policies.type = Policies
    appender.rolling.policies.time.type = TimeBasedTriggeringPolicy ![](images/icons/callouts/4.png)
    appender.rolling.policies.time.interval = 1 ![](images/icons/callouts/5.png)
    appender.rolling.policies.time.modulate = true ![](images/icons/callouts/6.png)

![](images/icons/callouts/1.png)

| 

Configure the `RollingFile` appender   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Log to `/var/log/elasticsearch/production.log`  
  
![](images/icons/callouts/3.png)

| 

Roll logs to `/var/log/elasticsearch/production-yyyy-MM-dd.log`  
  
![](images/icons/callouts/4.png)

| 

Using a time-based roll policy   
  
![](images/icons/callouts/5.png)

| 

Roll logs on a daily basis   
  
![](images/icons/callouts/6.png)

| 

Align rolls on the day boundary (as opposed to rolling every twenty-four hours)   
  
![Note](images/icons/note.png)

Log4j’s configuration parsing gets confused by any extraneous whitespace; if you copy and paste any Log4j settings on this page, or enter any Log4j configuration in general, be sure to trim any leading and trailing whitespace.

If you append `.gz` or `.zip` to `appender.rolling.filePattern`, then the logs will be compressed as they are rolled.

If you want to retain log files for a specified period of time, you can use a rollover strategy with a delete action.
    
    
    appender.rolling.strategy.type = DefaultRolloverStrategy ![](images/icons/callouts/1.png)
    appender.rolling.strategy.action.type = Delete ![](images/icons/callouts/2.png)
    appender.rolling.strategy.action.basepath = ${sys:es.logs.base_path} ![](images/icons/callouts/3.png)
    appender.rolling.strategy.action.condition.type = IfLastModified ![](images/icons/callouts/4.png)
    appender.rolling.strategy.action.condition.age = 7D ![](images/icons/callouts/5.png)
    appender.rolling.strategy.action.PathConditions.type = IfFileName ![](images/icons/callouts/6.png)
    appender.rolling.strategy.action.PathConditions.glob = ${sys:es.logs.cluster_name}-* ![](images/icons/callouts/7.png)

![](images/icons/callouts/1.png)

| 

Configure the `DefaultRolloverStrategy`  
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Configure the `Delete` action for handling rollovers   
  
![](images/icons/callouts/3.png)

| 

The base path to the Elasticsearch logs   
  
![](images/icons/callouts/4.png)

| 

The condition to apply when handling rollovers   
  
![](images/icons/callouts/5.png)

| 

Retain logs for seven days   
  
![](images/icons/callouts/6.png)

| 

Only delete files older than seven days if they match the specified glob   
  
![](images/icons/callouts/7.png)

| 

Delete files from the base path matching the glob `${sys:es.logs.cluster_name}-*`; this is the glob that log files are rolled to; this is needed to only delete the rolled Elasticsearch logs but not also delete the deprecation and slow logs   
  
Multiple configuration files can be loaded (in which case they will get merged) as long as they are named `log4j2.properties` and have the Elasticsearch config directory as an ancestor; this is useful for plugins that expose additional loggers. The logger div contains the java packages and their corresponding log level. The appender div contains the destinations for the logs. Extensive information on how to customize logging and all the supported appenders can be found on the [Log4j documentation](http://logging.apache.org/log4j/2.x/manual/configuration.html).

### Deprecation logging

In addition to regular logging, Elasticsearch allows you to enable logging of deprecated actions. For example this allows you to determine early, if you need to migrate certain functionality in the future. By default, deprecation logging is enabled at the WARN level, the level at which all deprecation log messages will be emitted.
    
    
    logger.deprecation.level = warn

This will create a daily rolling deprecation log file in your log directory. Check this file regularly, especially when you intend to upgrade to a new major version.

The default logging configuration has set the roll policy for the deprecation logs to roll and compress after 1 GB, and to preserve a maximum of five log files (four rolled logs, and the active log).

You can disable it in the `config/log4j2.properties` file by setting the deprecation log level to `error`.
