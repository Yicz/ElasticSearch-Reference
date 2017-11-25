# Document APIs

This div starts with a short introduction to Elasticsearch’s [data replication model](docs-replication.html "Reading and Writing documents"), followed by a detailed description of the following CRUD APIs:

 **Single document APIs**

  * [_Index API_](docs-index_.html "Index API")
  * [_Get API_](docs-get.html "Get API")
  * [_Delete API_](docs-delete.html "Delete API")
  * [_Update API_](docs-update.html "Update API")



**Multi-document APIs**

  * [_Multi Get API_](docs-multi-get.html "Multi Get API")
  * [_Bulk API_](docs-bulk.html "Bulk API")
  * [_Delete By Query API_](docs-delete-by-query.html "Delete By Query API")
  * [_Update By Query API_](docs-update-by-query.html "Update By Query API")
  * [_Reindex API_](docs-reindex.html "Reindex API")



![Note](images/icons/note.png)

All CRUD APIs are single-index APIs. The `index` parameter accepts a single index name, or an `alias` which points to a single index.
