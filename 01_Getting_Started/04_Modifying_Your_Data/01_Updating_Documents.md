## Updating Documents

In addition to being able to index and replace documents, we can also update documents. Note though that Elasticsearch does not actually do in-place updates under the hood. Whenever we do an update, Elasticsearch deletes the old document and then indexes a new document with the update applied to it in one shot.

This example shows how to update our previous document (ID of 1) by changing the name field to "Jane Doe":
    
    
    POST /customer/external/1/_update?pretty
    {
      "doc": { "name": "Jane Doe" }
    }

This example shows how to update our previous document (ID of 1) by changing the name field to "Jane Doe" and at the same time add an age field to it:
    
    
    POST /customer/external/1/_update?pretty
    {
      "doc": { "name": "Jane Doe", "age": 20 }
    }

Updates can also be performed by using simple scripts. This example uses a script to increment the age by 5:
    
    
    POST /customer/external/1/_update?pretty
    {
      "script" : "ctx._source.age += 5"
    }

In the above example, `ctx._source` refers to the current source document that is about to be updated.

Note that as of this writing, updates can only be performed on a single document at a time. In the future, Elasticsearch might provide the ability to update multiple documents given a query condition (like an `SQL UPDATE-WHERE` statement).
