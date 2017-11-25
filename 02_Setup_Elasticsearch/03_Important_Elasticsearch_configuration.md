## Important Elasticsearch configuration

While Elasticsearch requires very little configuration, there are a number of settings which need to be configured manually and should definitely be configured before going into production.

  * [`path.data` and `path.logs`](important-settings.html#path-settings "path.data and path.logsedit")
  * [`cluster.name`](important-settings.html#cluster.name "cluster.nameedit")
  * [`node.name`](important-settings.html#node.name "node.nameedit")
  * [`bootstrap.memory_lock`](important-settings.html#bootstrap.memory_lock "bootstrap.memory_lockedit")
  * [`network.host`](important-settings.html#network.host "network.hostedit")
  * [`discovery.zen.ping.unicast.hosts`](important-settings.html#unicast.hosts "discovery.zen.ping.unicast.hostsedit")
  * [`discovery.zen.minimum_master_nodes`](important-settings.html#minimum_master_nodes "discovery.zen.minimum_master_nodesedit")



### `path.data` and `path.logs`

If you are using the `.zip` or `.tar.gz` archives, the `data` and `logs` directories are sub-folders of `$ES_HOME`. If these important folders are left in their default locations, there is a high risk of them being deleted while upgrading Elasticsearch to a new version.

In production use, you will almost certainly want to change the locations of the data and log folder:
    
    
    path:
      logs: /var/log/elasticsearch
      data: /var/data/elasticsearch

The RPM and Debian distributions already use custom paths for `data` and `logs`.

The `path.data` settings can be set to multiple paths, in which case all paths will be used to store data (although the files belonging to a single shard will all be stored on the same data path):
    
    
    path:
      data:
        - /mnt/elasticsearch_1
        - /mnt/elasticsearch_2
        - /mnt/elasticsearch_3

### `cluster.name`

A node can only join a cluster when it shares its `cluster.name` with all the other nodes in the cluster. The default name is `elasticsearch`, but you should change it to an appropriate name which describes the purpose of the cluster.
    
    
    cluster.name: logging-prod

Make sure that you don’t reuse the same cluster names in different environments, otherwise you might end up with nodes joining the wrong cluster.

### `node.name`

By default, Elasticsearch will take the 7 first character of the randomly generated uuid used as the node id. Note that the node id is persisted and does not change when a node restarts and therefore the default node name will also not change.

It is worth configuring a more meaningful name which will also have the advantage of persisting after restarting the node:
    
    
    node.name: prod-data-2

The `node.name` can also be set to the server’s HOSTNAME as follows:
    
    
    node.name: ${HOSTNAME}

### `bootstrap.memory_lock`

It is vitally important to the health of your node that none of the JVM is ever swapped out to disk. One way of achieving that is set the `bootstrap.memory_lock` setting to `true`.

For this setting to have effect, other system settings need to be configured first. See [Enable `bootstrap.memory_lock`](setup-configuration-memory.html#mlockall "Enable bootstrap.memory_lock") for more details about how to set up memory locking correctly.

### `network.host`

By default, Elasticsearch binds to loopback addresses only — e.g. `127.0.0.1` and `[::1]`. This is sufficient to run a single development node on a server.

![Tip](images/icons/tip.png)

In fact, more than one node can be started from the same `$ES_HOME` location on a single node. This can be useful for testing Elasticsearch’s ability to form clusters, but it is not a configuration recommended for production.

In order to communicate and to form a cluster with nodes on other servers, your node will need to bind to a non-loopback address. While there are many [network settings](modules-network.html "Network Settings"), usually all you need to configure is `network.host`:
    
    
    network.host: 192.168.1.10

The `network.host` setting also understands some special values such as `_local_`, `_site_`, `_global_` and modifiers like `:ip4` and `:ip6`, details of which can be found in [Special values for `network.host`.

![Important](images/icons/important.png)

As soon you provide a custom setting for `network.host`, Elasticsearch assumes that you are moving from development mode to production mode, and upgrades a number of system startup checks from warnings to exceptions. See [Development mode vs production mode for more information.

### `discovery.zen.ping.unicast.hosts`

Out of the box, without any network configuration, Elasticsearch will bind to the available loopback addresses and will scan ports 9300 to 9305 to try to connect to other nodes running on the same server. This provides an auto- clustering experience without having to do any configuration.

When the moment comes to form a cluster with nodes on other servers, you have to provide a seed list of other nodes in the cluster that are likely to be live and contactable. This can be specified as follows:
    
    
    discovery.zen.ping.unicast.hosts:
       - 192.168.1.10:9300
       - 192.168.1.11 ![](images/icons/callouts/1.png)
       - seeds.mydomain.com ![](images/icons/callouts/2.png)

![](images/icons/callouts/1.png)

| 

The port will default to `transport.profiles.default.port` and fallback to `transport.tcp.port` if not specified.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

A hostname that resolves to multiple IP addresses will try all resolved addresses.   
  
### `discovery.zen.minimum_master_nodes`

To prevent data loss, it is vital to configure the `discovery.zen.minimum_master_nodes` setting so that each master-eligible node knows the _minimum number of master-eligible nodes_ that must be visible in order to form a cluster.

Without this setting, a cluster that suffers a network failure is at risk of having the cluster split into two independent clusters — a split brain — which will lead to data loss. A more detailed explanation is provided in [Avoiding split brain with `minimum_master_nodes`.

To avoid a split brain, this setting should be set to a _quorum_ of master- eligible nodes:
    
    
    (master_eligible_nodes / 2) + 1

In other words, if there are three master-eligible nodes, then minimum master nodes should be set to `(3 / 2) + 1` or `2`:
    
    
    discovery.zen.minimum_master_nodes: 2
