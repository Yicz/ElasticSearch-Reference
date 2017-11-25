## Cluster Health

Let’s start with a basic health check, which we can use to see how our cluster is doing. We’ll be using curl to do this but you can use any tool that allows you to make HTTP/REST calls. Let’s assume that we are still on the same node where we started Elasticsearch on and open another command shell window.

To check the cluster health, we will be using the [`_cat` API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/cat.html). You can run the command below in [Kibana’s Console](https://www.elastic.co/guide/en/kibana/5.4/console-kibana.html) by clicking "VIEW IN CONSOLE" or with `curl` by clicking the "COPY AS CURL" link below and pasting it into a terminal.
    
    
    GET /_cat/health?v

And the response:
    
    
    epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
    1475247709 17:01:49  elasticsearch green           1         1      0   0    0    0        0             0                  -                100.0%

We can see that our cluster named "elasticsearch" is up with a green status.

Whenever we ask for the cluster health, we either get green, yellow, or red. Green means everything is good (cluster is fully functional), yellow means all data is available but some replicas are not yet allocated (cluster is fully functional), and red means some data is not available for whatever reason. Note that even if a cluster is red, it still is partially functional (i.e. it will continue to serve search requests from the available shards) but you will likely need to fix it ASAP since you have missing data.

Also from the above response, we can see a total of 1 node and that we have 0 shards since we have no data in it yet. Note that since we are using the default cluster name (elasticsearch) and since Elasticsearch uses unicast network discovery by default to find other nodes on the same machine, it is possible that you could accidentally start up more than one node on your computer and have them all join a single cluster. In this scenario, you may see more than 1 node in the above response.

We can also get a list of nodes in our cluster as follows:
    
    
    GET /_cat/nodes?v

And the response:
    
    
    ip        heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
    127.0.0.1           10           5   5    4.46                        mdi      *      PB2SGZY

Here, we can see our one node named "PB2SGZY", which is the single node that is currently in our cluster.
