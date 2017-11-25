## Node level settings related to shadow replicas

These are non-dynamic settings that need to be configured in `elasticsearch.yml`

`node.add_lock_id_to_custom_path`
     Boolean setting indicating whether Elasticsearch should append the node’s ordinal to the custom data path. For example, if this is enabled and a path of "/tmp/foo" is used, the first locally-running node will use "/tmp/foo/0", the second will use "/tmp/foo/1", the third "/tmp/foo/2", etc. Defaults to `true`. 
