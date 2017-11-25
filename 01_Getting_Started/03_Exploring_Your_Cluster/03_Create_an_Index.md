## Create an Index

Now let’s create an index named "customer" and then list all the indexes again:
    
    
    PUT /customer?pretty
    GET /_cat/indices?v

The first command creates the index named "customer" using the PUT verb. We simply append `pretty` to the end of the call to tell it to pretty-print the JSON response (if any).

And the response:
    
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   customer 95SQ4TSUT7mWBT7VNHH67A   5   1          0            0       260b           260b

The results of the second command tells us that we now have 1 index named customer and it has 5 primary shards and 1 replica (the defaults) and it contains 0 documents in it.

You might also notice that the customer index has a yellow health tagged to it. Recall from our previous discussion that yellow means that some replicas are not (yet) allocated. The reason this happens for this index is because Elasticsearch by default created one replica for this index. Since we only have one node running at the moment, that one replica cannot yet be allocated (for high availability) until a later point in time when another node joins the cluster. Once that replica gets allocated onto a second node, the health status for this index will turn to green.
