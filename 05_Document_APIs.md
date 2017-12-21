#文档操作 APIs 

本部分将简短地介绍ES的[数据分片模型](docs-replication.html), 接下来都会进行详细地介绍增删查找(CRUD)APIs:

 **单文档 APIs**

  * [_Index API_](docs-index_.html)
  * [_Get API_](docs-get.html)
  * [_Delete API_](docs-delete.html)
  * [_Update API_](docs-update.html)



**多文档 APIs**

  * [_多个获取 Multi Get API_](docs-multi-get.html)
  * [_批量操作 Bulk API_](docs-bulk.html)
  * [_查询删除 Delete By Query API_](docs-delete-by-query.html)
  * [_查询更新 Update By Query API_](docs-update-by-query.html)
  * [_重建索引 Reindex API_](docs-reindex.html)



![提醒](images/icons/note.png)

全部增删查找(CRUD)APIs都只能进行单文档操作，`index`参数是单索引的名称，或者使用`alias`指向单个索引。
