# Modules

This div contains modules responsible for various aspects of the functionality in Elasticsearch. Each module has settings which may be:

_static_
     These settings must be set at the node level, either in the `elasticsearch.yml` file, or as an environment variable or on the command line when starting a node. They must be set on every relevant node in the cluster. 
_dynamic_
     These settings can be dynamically updated on a live cluster with the [cluster-update-settings](cluster-update-settings.html "Cluster Update Settings") API. 

The modules in this div are:

[Cluster-level routing and shard allocation](modules-cluster.html "Cluster")
     Settings to control where, when, and how shards are allocated to nodes. 
[Discovery](modules-discovery.html "Discovery")
     How nodes discover each other to form a cluster. 
[Gateway](modules-gateway.html "Local Gateway")
     How many nodes need to join the cluster before recovery can start. 
[HTTP](modules-http.html "HTTP")
     Settings to control the HTTP REST interface. 
[Indices](modules-indices.html "Indices")
     Global index-related settings. 
[Network](modules-network.html "Network Settings")
     Controls default network settings. 
[Node client](modules-node.html "Node")
     A Java node client joins the cluster, but doesn’t hold data or act as a master node. 
[Painless](modules-scripting-painless.html "Painless Scripting Language")
     A built-in scripting language for Elasticsearch that’s designed to be as secure as possible. 
[Plugins](modules-plugins.html "Plugins")
     Using plugins to extend Elasticsearch. 
[Scripting](modules-scripting.html "Scripting")
     Custom scripting available in Lucene Expressions, Groovy, Python, and Javascript. You can also write scripts in the built-in scripting language, [Painless](modules-scripting-painless.html "Painless Scripting Language"). 
[Snapshot/Restore](modules-snapshots.html "Snapshot And Restore")
     Backup your data with snapshot/restore. 
[Thread pools](modules-threadpool.html "Thread Pool")
     Information about the dedicated thread pools used in Elasticsearch. 
[Transport](modules-transport.html "Transport")
     Configure the transport networking layer, used internally by Elasticsearch to communicate between nodes. 
[Tribe nodes](modules-tribe.html "Tribe node")
     A tribe node joins one or more clusters and acts as a federated client across them. 
[Cross cluster Search](modules-cross-cluster-search.html "Cross Cluster Search")
     Cross cluster search enables executing search requests across more than one cluster without joining them and acts as a federated client across them. 
