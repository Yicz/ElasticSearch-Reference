##  5.0的版本变更

This div discusses the changes that you need to be aware of when migrating your application to Elasticsearch 5.0.

### Migration Plugin

The [`elasticsearch-migration` plugin](https://github.com/elastic/elasticsearch-migration/blob/2.x/README.asciidoc) (compatible with Elasticsearch 2.3.0 and above) will help you to find issues that need to be addressed when upgrading to Elasticsearch 5.0.

### Indices created before 5.0

Elasticsearch 5.0 can read indices created in version 2.0 or above. An Elasticsearch 5.0 node will not start in the presence of indices created in a version of Elasticsearch before 2.0.

![Important](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/important.png)

### Reindex indices from Elasticseach 1.x or before

Indices created in Elasticsearch 1.x or before will need to be reindexed with Elasticsearch 2.x or 5.x in order to be readable by Elasticsearch 5.x. It is not sufficient to use the `upgrade` API. See [Reindex to upgrade](reindex-upgrade.html) for more details.

The first time Elasticsearch 5.0 starts, it will automatically rename index folders to use the index UUID instead of the index name. If you are using [shadow replicas](indices-shadow-replicas.html) with shared data folders, first start a single node with access to all data folders, and let it rename all index folders before starting other nodes in the cluster.

### Also see:

  * [Search and Query DSL changes](breaking_50_search_changes.html)
  * [Mapping changes](breaking_50_mapping_changes.html)
  * [Percolator changes](breaking_50_percolator.html)
  * [Suggester changes](breaking_50_suggester.html)
  * [Index APIs changes](breaking_50_index_apis.html)
  * [Document API changes](breaking_50_document_api_changes.html)
  * [Settings changes](breaking_50_settings_changes.html)
  * [Allocation changes](breaking_50_allocation.html)
  * [HTTP changes](breaking_50_http_changes.html)
  * [REST API changes](breaking_50_rest_api_changes.html)
  * [CAT API changes](breaking_50_cat_api.html)
  * [Java API changes](breaking_50_java_api_changes.html)
  * [Packaging](breaking_50_packaging.html)
  * [Plugin changes](breaking_50_plugins.html)
  * [Filesystem related changes](breaking_50_fs.html)
  * [Aggregation changes](breaking_50_aggregations_changes.html)
  * [Script related changes](breaking_50_scripting.html)


