## Cross Cluster Search

![Warning](images/icons/warning.png)

This functionality is in beta and is subject to change. The design and code is considered to be less mature than official GA features. Elastic will take a best effort approach to fix any issues, but beta features are not subject to the support SLA of official GA features.

The _cross cluster search_ feature allows any node to act as a federated client across multiple clusters. In contrast to the [tribe node](modules-tribe.html) feature, a cross cluster search node won’t join the remote cluster, instead it connects to a remote cluster in a light fashion in order to execute federated search requests.

Cross cluster search works by configuring a remote cluster in the cluster state and connecting only to a limited number of nodes in the remote cluster. Each remote cluster is referenced by a name and a list of seed nodes. When a remote cluster is registered, its cluster state is retrieved from one of the seed nodes so that up to 3 _gateway nodes_ are selected to be connected to as part of upcoming cross cluster search requests. Cross cluster search requests consist of uni-directional connections from the coordinating node to the previously selected remote nodes only. It is possible to tag which nodes should be selected through node attributes (see [Cross cluster search settings.

Each node in a cluster that has remote clusters configured connects to one or more _gateway nodes_ and uses them to federate search requests to the remote cluster.

### Configuring Cross Cluster Search

Remote clusters can be specified globally using [cluster settings](cluster-update-settings.html) (which can be updated dynamically), or local to individual nodes using the `elasticsearch.yml` file.

If a remote cluster is configured via `elasticsearch.yml` only the nodes with that configuration will be able to connect to the remote cluster. In other words, federated search requests will have to be sent specifically to those nodes. Remote clusters set via the [cluster settings API](cluster-update-settings.html) will be available on every node in the cluster.

![Warning](images/icons/warning.png)

This feature was added as Beta in Elasticsearch `v5.3` with further improvements made in 5.4 and 5.5. It requires gateway eligible nodes to be on `v5.5` onwards.

The `elasticsearch.yml` config file for a _cross cluster search_ node just needs to list the remote clusters that should be connected to, for instance:
    
    
    search:
        remote:
            cluster_one: ![](images/icons/callouts/1.png)
                seeds: 127.0.0.1:9300
            cluster_two: ![](images/icons/callouts/2.png)
                seeds: 127.0.0.1:9301

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

`cluster_one` and `cluster_two` are arbitrary cluster aliases representing the connection to each cluster. These names are subsequently used to distinguish between local and remote indices.   
  
---|---  
  
The equivalent example using the [cluster settings API](cluster-update-settings.html) to add remote clusters to all nodes in the cluster would look like the following:
    
    
    PUT _cluster/settings
    {
      "persistent": {
        "search": {
          "remote": {
            "cluster_one": {
              "seeds": [
                "127.0.0.1:9300"
              ]
            },
            "cluster_two": {
              "seeds": [
                "127.0.0.1:9301"
              ]
            }
          }
        }
      }
    }

A remote cluster can be deleted from the cluster settings by setting its seeds to `null`:
    
    
    PUT _cluster/settings
    {
      "persistent": {
        "search": {
          "remote": {
            "cluster_one": {
              "seeds": null ![](images/icons/callouts/1.png)
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

`cluster_one` would be removed from the cluster settings, leaving `cluster_two` intact.   
  
---|---  
  
### Using cross cluster search

To search the `twitter` index on remote cluster `cluster_1` the index name must be prefixed with the cluster alias separated by a `:` character:
    
    
    POST /cluster_one:twitter/tweet/_search
    {
      "query": {
        "match_all": {}
      }
    }

In contrast to the `tribe` feature cross cluster search can also search indices with the same name on different clusters:
    
    
    POST /cluster_one:twitter,twitter/tweet/_search
    {
      "query": {
        "match_all": {}
      }
    }

Search results are disambiguated the same way as the indices are disambiguated in the request. Even if index names are identical these indices will be treated as different indices when results are merged. All results retrieved from a remote index will be prefixed with their remote cluster name:
    
    
     {
      "took" : 89,
      "timed_out" : false,
      "_shards" : {
        "total" : 10,
        "successful" : 10,
        "failed" : 0
      },
      "hits" : {
        "total" : 2,
        "max_score" : 1.0,
        "hits" : [
          {
            "_index" : "cluster_one:twitter",
            "_type" : "tweet",
            "_id" : "1",
            "_score" : 1.0,
            "_source" : {
              "user" : "kimchy",
              "postDate" : "2009-11-15T14:12:12",
              "message" : "trying out Elasticsearch"
            }
          },
          {
            "_index" : "twitter",
            "_type" : "tweet",
            "_id" : "1",
            "_score" : 1.0,
            "_source" : {
              "user" : "kimchy",
              "postDate" : "2009-11-15T14:12:12",
              "message" : "trying out Elasticsearch"
            }
          }
        ]
      }
    }

### Cross cluster search settings

`search.remote.connections_per_cluster`
     The number of nodes to connect to per remote cluster. The default is `3`. 
`search.remote.initial_connect_timeout`
     The time to wait for remote connections to be established when the node starts. The default is `30s`. 
`search.remote.node.attr`
     A node attribute to filter out nodes that are eligible as a gateway node in the remote cluster. For instance a node can have a node attribute `node.attr.gateway: true` such that only nodes with this attribute will be connected to if `search.remote.node.attr` is set to `gateway`. 
`search.remote.connect`
     By default, any node in the cluster can act as a cross-cluster client and connect to remote clusters. The `search.remote.connect` setting can be set to `false` (defaults to `true`) to prevent certain nodes from connecting to remote clusters. Cross-cluster search requests must be sent to a node that is allowed to act as a cross-cluster client. 