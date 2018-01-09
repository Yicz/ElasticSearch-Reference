## 与影子副本相关的节点级别设置 Node level settings related to shadow replicas

这是一个非动态的设置，只能在`elasticsearch.yaml`配置文件中进行设置

`node.add_lock_id_to_custom_path`
    
    布尔类型设置，指示Elasticsearch是否应将节点序号附加到自定义数据存放路径。 例如，如果启用了这个路径并且使用`/tmp/foo`路径，那么第一个在本地运行的节点将使用`/tmp/foo/0`，第二个将使用`/tmp/foo/1` 第三个`/tmp/foo/2`等，默认为`true`。
     