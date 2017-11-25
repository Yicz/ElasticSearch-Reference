# Glossary of terms

analysis 
    

Analysis is the process of converting [full text](glossary.html#glossary-text) to [terms](glossary.html#glossary-term). Depending on which analyzer is used, these phrases: `FOO BAR`, `Foo-Bar`, `foo,bar` will probably all result in the terms `foo` and `bar`. These terms are what is actually stored in the index. A full text query (not a [term](glossary.html#glossary-term) query) for `FoO:bAR` will also be analyzed to the terms `foo`,`bar` and will thus match the terms stored in the index. It is this process of analysis (both at index time and at search time) that allows elasticsearch to perform full text queries. Also see [text](glossary.html#glossary-text) and [term](glossary.html#glossary-term). 

cluster 
    

A cluster consists of one or more [nodes](glossary.html#glossary-node) which share the same cluster name. Each cluster has a single master node which is chosen automatically by the cluster and which can be replaced if the current master node fails. 

document 
    

A document is a JSON document which is stored in elasticsearch. It is like a row in a table in a relational database. Each document is stored in an [index](glossary.html#glossary-index) and has a [type](glossary.html#glossary-type) and an [id](glossary.html#glossary-id). A document is a JSON object (also known in other languages as a hash / hashmap / associative array) which contains zero or more [fields](glossary.html#glossary-field), or key-value pairs. The original JSON document that is indexed will be stored in the [`_source` field](glossary.html#glossary-source_field), which is returned by default when getting or searching for a document. 

id 
    

The ID of a [document](glossary.html#glossary-document) identifies a document. The `index/type/id` of a document must be unique. If no ID is provided, then it will be auto-generated. (also see [routing](glossary.html#glossary-routing)) 

field 
    

A [document](glossary.html#glossary-document) contains a list of fields, or key-value pairs. The value can be a simple (scalar) value (eg a string, integer, date), or a nested structure like an array or an object. A field is similar to a column in a table in a relational database. The [mapping](glossary.html#glossary-mapping) for each field has a field _type_ (not to be confused with document [type](glossary.html#glossary-type)) which indicates the type of data that can be stored in that field, eg `integer`, `string`, `object`. The mapping also allows you to define (amongst other things) how the value for a field should be analyzed. 

index 
    

An index is like a _table_ in a relational database. It has a [mapping](glossary.html#glossary-mapping) which defines the [fields](glossary.html#glossary-field) in the index, which are grouped by multiple [type](glossary.html#glossary-type). An index is a logical namespace which maps to one or more [primary shards](glossary.html#glossary-primary-shard) and can have zero or more [replica shards](glossary.html#glossary-replica-shard). 

mapping 
    

A mapping is like a _schema definition_ in a relational database. Each [index](glossary.html#glossary-index) has a mapping, which defines each [type](glossary.html#glossary-type) within the index, plus a number of index-wide settings. A mapping can either be defined explicitly, or it will be generated automatically when a document is indexed. 

node 
    

A node is a running instance of elasticsearch which belongs to a [cluster](glossary.html#glossary-cluster). Multiple nodes can be started on a single server for testing purposes, but usually you should have one node per server. At startup, a node will use unicast to discover an existing cluster with the same cluster name and will try to join that cluster. 

primary shard 
    

Each document is stored in a single primary [shard](glossary.html#glossary-shard). When you index a document, it is indexed first on the primary shard, then on all [replicas](glossary.html#glossary-replica-shard) of the primary shard. By default, an [index](glossary.html#glossary-index) has 5 primary shards. You can specify fewer or more primary shards to scale the number of [documents](glossary.html#glossary-document) that your index can handle. You cannot change the number of primary shards in an index, once the index is created. See also [routing](glossary.html#glossary-routing)

replica shard 
    

Each [primary shard](glossary.html#glossary-primary-shard) can have zero or more replicas. A replica is a copy of the primary shard, and has two purposes: 

  1. increase failover: a replica shard can be promoted to a primary shard if the primary fails 
  2. increase performance: get and search requests can be handled by primary or replica shards. By default, each primary shard has one replica, but the number of replicas can be changed dynamically on an existing index. A replica shard will never be started on the same node as its primary shard. 



routing 
    

When you index a document, it is stored on a single [primary shard](glossary.html#glossary-primary-shard). That shard is chosen by hashing the `routing` value. By default, the `routing` value is derived from the ID of the document or, if the document has a specified parent document, from the ID of the parent document (to ensure that child and parent documents are stored on the same shard). This value can be overridden by specifying a `routing` value at index time, or a [routing field](mapping-routing-field.html "_routing field") in the [mapping](glossary.html#glossary-mapping). 

shard 
    

A shard is a single Lucene instance. It is a low-level “worker” unit which is managed automatically by elasticsearch. An index is a logical namespace which points to [primary](glossary.html#glossary-primary-shard) and [replica](glossary.html#glossary-replica-shard) shards. Other than defining the number of primary and replica shards that an index should have, you never need to refer to shards directly. Instead, your code should deal only with an index. Elasticsearch distributes shards amongst all [nodes](glossary.html#glossary-node) in the [cluster](glossary.html#glossary-cluster), and can move shards automatically from one node to another in the case of node failure, or the addition of new nodes. 

source field 
    

By default, the JSON document that you index will be stored in the `_source` field and will be returned by all get and search requests. This allows you access to the original object directly from search results, rather than requiring a second step to retrieve the object from an ID. 

term 
    

A term is an exact value that is indexed in elasticsearch. The terms `foo`, `Foo`, `FOO` are NOT equivalent. Terms (i.e. exact values) can be searched for using _term_ queries. See also [text](glossary.html#glossary-text) and [analysis](glossary.html#glossary-analysis). 

text 
    

Text (or full text) is ordinary unstructured text, such as this paragraph. By default, text will be [analyzed](glossary.html#glossary-analysis) into [terms](glossary.html#glossary-term), which is what is actually stored in the index. Text [fields](glossary.html#glossary-field) need to be analyzed at index time in order to be searchable as full text, and keywords in full text queries must be analyzed at search time to produce (and search for) the same terms that were generated at index time. See also [term](glossary.html#glossary-term) and [analysis](glossary.html#glossary-analysis). 

type 
    

A type represents the _type_ of document, e.g. an `email`, a `user`, or a `tweet`. The search API can filter documents by type. An [index](glossary.html#glossary-index) can contain multiple types, and each type has a list of [fields](glossary.html#glossary-field) that can be specified for [documents](glossary.html#glossary-document) of that type. Fields with the same name in different types in the same index must have the same [mapping](glossary.html#glossary-mapping) (which defines how each field in the document is indexed and made searchable). 
