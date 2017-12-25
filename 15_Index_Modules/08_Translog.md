## Translog

Changes to Lucene are only persisted to disk during a Lucene commit, which is a relatively heavy operation and so cannot be performed after every index or delete operation. Changes that happen after one commit and before another will be lost in the event of process exit or HW failure.

To prevent this data loss, each shard has a _transaction log_ or write ahead log associated with it. Any index or delete operation is written to the translog after being processed by the internal Lucene index.

In the event of a crash, recent transactions can be replayed from the transaction log when the shard recovers.

An Elasticsearch flush is the process of performing a Lucene commit and starting a new translog. It is done automatically in the background in order to make sure the transaction log doesn’t grow too large, which would make replaying its operations take a considerable amount of time during recovery. It is also exposed through an API, though its rarely needed to be performed manually.

### Flush settings

The following [dynamically updatable](indices-update-settings.html) settings control how often the in-memory buffer is flushed to disk:

`index.translog.flush_threshold_size`
     Once the translog hits this size, a flush will happen. Defaults to `512mb`. 

### Translog settings

The data in the transaction log is only persisted to disk when the translog is `fsync`ed and committed. In the event of hardware failure, any data written since the previous translog commit will be lost.

By default, Elasticsearch `fsync`s and commits the translog every 5 seconds if `index.translog.durability` is set to `async` or if set to `request` (default) at the end of every [index](docs-index_.html), [delete](docs-delete.html), [update](docs-update.html), or [bulk](docs-bulk.html) request. In fact, Elasticsearch will only report success of an index, delete, update, or bulk request to the client after the transaction log has been successfully `fsync`ed and committed on the primary and on every allocated replica.

The following [dynamically updatable](indices-update-settings.html) per-index settings control the behaviour of the transaction log:

`index.translog.sync_interval`
     How often the translog is `fsync`ed to disk and committed, regardless of write operations. Defaults to `5s`. Values less than `100ms` are not allowed. 
`index.translog.durability`
    

Whether or not to `fsync` and commit the translog after every index, delete, update, or bulk request. This setting accepts the following parameters:

`request`
     (default) `fsync` and commit after every request. In the event of hardware failure, all acknowledged writes will already have been committed to disk. 
`async`
     `fsync` and commit in the background every `sync_interval`. In the event of hardware failure, all acknowledged writes since the last automatic commit will be discarded. 

### What to do if the translog becomes corrupted?

In some cases (a bad drive, user error) the translog can become corrupted. When this corruption is detected by Elasticsearch due to mismatching checksums, Elasticsearch will fail the shard and refuse to allocate that copy of the data to the node, recovering from a replica if available.

If there is no copy of the data from which Elasticsearch can recover successfully, a user may want to recover the data that is part of the shard at the cost of losing the data that is currently contained in the translog. We provide a command-line tool for this, `elasticsearch-translog`.

![Warning](images/icons/warning.png)

The `elasticsearch-translog` tool should **not** be run while Elasticsearch is running, and you will permanently lose the documents that were contained only in the translog!

In order to run the `elasticsearch-translog` tool, specify the `truncate` subcommand as well as the directory for the corrupted translog with the `-d` option:
    
    
    $ bin/elasticsearch-translog truncate -d /var/lib/elasticsearchdata/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/
    Checking existing translog files
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !   WARNING: Elasticsearch MUST be stopped before running this tool   !
    !                                                                     !
    !   WARNING:    Documents inside of translog files will be lost       !
    !                                                                     !
    !   WARNING:          The following files will be DELETED!            !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    --> data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog-41.ckp
    --> data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog-6.ckp
    --> data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog-37.ckp
    --> data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog-24.ckp
    --> data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog-11.ckp
    
    Continue and DELETE files? [y/N] y
    Reading translog UUID information from Lucene commit from shard at [data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/index]
    Translog Generation: 3
    Translog UUID      : AxqC4rocTC6e0fwsljAh-Q
    Removing existing translog files
    Creating new empty checkpoint at [data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog.ckp]
    Creating new empty translog at [data/nodes/0/indices/P45vf_YQRhqjfwLMUvSqDw/0/translog/translog-3.tlog]
    Done.

You can also use the `-h` option to get a list of all options and parameters that the `elasticsearch-translog` tool supports.