##  磁盘数据路径变更 Path to data on disk

In prior versions of Elasticsearch, the `path.data` directory included a folder for the cluster name, so that data was in a folder such as `$DATA_DIR/$CLUSTER_NAME/nodes/$nodeOrdinal`. In 5.0 the cluster name as a directory is deprecated. Data will now be stored in `$DATA_DIR/nodes/$nodeOrdinal` if there is no existing data. Upon startup, Elasticsearch will check to see if the cluster folder exists and has data, and will read from it if necessary. In Elasticsearch 6.0 this backwards-compatible behavior will be removed.

If you are using a multi-cluster setup with both instances of Elasticsearch pointing to the same data path, you will need to add the cluster name to the data path so that different clusters do not overwrite data.

### Local files

Prior to 5.0, nodes that were marked with both `node.data: false` and `node.master: false` (or the now removed `node.client: true`) didn’t write any files or folder to disk. 5.x added persistent node ids, requiring nodes to store that information. As such, all node types will write a small state file to their data folders.
