## Delete an Index

Now let’s delete the index that we just created and then list all the indexes again:
    
    
    DELETE /customer?pretty
    GET /_cat/indices?v

And the response:
    
    
    health status index uuid pri rep docs.count docs.deleted store.size pri.store.size

Which means that the index was deleted successfully and we are now back to where we started with nothing in our cluster.

Before we move on, let’s take a closer look again at some of the API commands that we have learned so far:
    
    
    PUT /customer
    PUT /customer/external/1
    {
      "name": "John Doe"
    }
    GET /customer/external/1
    DELETE /customer

If we study the above commands carefully, we can actually see a pattern of how we access data in Elasticsearch. That pattern can be summarized as follows:
    
    
    <REST Verb> /<Index>/<Type>/<ID>

This REST access pattern is so pervasive throughout all the API commands that if you can simply remember it, you will have a good head start at mastering Elasticsearch.
