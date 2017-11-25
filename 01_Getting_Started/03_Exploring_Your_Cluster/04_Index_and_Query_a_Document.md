## Index and Query a Document

Let’s now put something into our customer index. Remember previously that in order to index a document, we must tell Elasticsearch which type in the index it should go to.

Let’s index a simple customer document into the customer index, "external" type, with an ID of 1 as follows:
    
    
    PUT /customer/external/1?pretty
    {
      "name": "John Doe"
    }

And the response:
    
    
    {
      "_index" : "customer",
      "_type" : "external",
      "_id" : "1",
      "_version" : 1,
      "result" : "created",
      "_shards" : {
        "total" : 2,
        "successful" : 1,
        "failed" : 0
      },
      "created" : true
    }

From the above, we can see that a new customer document was successfully created inside the customer index and the external type. The document also has an internal id of 1 which we specified at index time.

It is important to note that Elasticsearch does not require you to explicitly create an index first before you can index documents into it. In the previous example, Elasticsearch will automatically create the customer index if it didn’t already exist beforehand.

Let’s now retrieve that document that we just indexed:
    
    
    GET /customer/external/1?pretty

And the response:
    
    
    {
      "_index" : "customer",
      "_type" : "external",
      "_id" : "1",
      "_version" : 1,
      "found" : true,
      "_source" : { "name": "John Doe" }
    }

Nothing out of the ordinary here other than a field, `found`, stating that we found a document with the requested ID 1 and another field, `_source`, which returns the full JSON document that we indexed from the previous step.
