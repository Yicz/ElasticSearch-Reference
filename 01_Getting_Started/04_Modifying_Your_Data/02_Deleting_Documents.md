## Deleting Documents

Deleting a document is fairly straightforward. This example shows how to delete our previous customer with the ID of 2:
    
    
    DELETE /customer/external/2?pretty

See the [`_delete_by_query` API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-delete-by-query.html) to delete all documents matching a specific query. It is worth noting that it is much more efficient to delete a whole index instead of deleting all documents with the Delete By Query API.
