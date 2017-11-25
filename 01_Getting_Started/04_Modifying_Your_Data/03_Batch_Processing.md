## Batch Processing

In addition to being able to index, update, and delete individual documents, Elasticsearch also provides the ability to perform any of the above operations in batches using the [`_bulk` API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-bulk.html). This functionality is important in that it provides a very efficient mechanism to do multiple operations as fast as possible with as few network roundtrips as possible.

As a quick example, the following call indexes two documents (ID 1 - John Doe and ID 2 - Jane Doe) in one bulk operation:
    
    
    POST /customer/external/_bulk?pretty
    {"index":{"_id":"1"} }
    {"name": "John Doe" }
    {"index":{"_id":"2"} }
    {"name": "Jane Doe" }

This example updates the first document (ID of 1) and then deletes the second document (ID of 2) in one bulk operation:
    
    
    POST /customer/external/_bulk?pretty
    {"update":{"_id":"1"} }
    {"doc": { "name": "John Doe becomes Jane Doe" } }
    {"delete":{"_id":"2"} }

Note above that for the delete action, there is no corresponding source document after it since deletes only require the ID of the document to be deleted.

The Bulk API does not fail due to failures in one of the actions. If a single action fails for whatever reason, it will continue to process the remainder of the actions after it. When the bulk API returns, it will provide a status for each action (in the same order it was sent in) so that you can check if a specific action failed or not.
