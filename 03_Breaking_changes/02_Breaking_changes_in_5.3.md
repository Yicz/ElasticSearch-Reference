## 5.3的版本变更

### Packaging changes

#### Logging configuration

Previously Elasticsearch exposed a single system property (`es.logs`) that included the absolute path to the configured logs directory, and the prefix of the filenames used for the various logging files (the main log file, the deprecation log, and the slow logs). This property has been replaced in favor of three properties:

  * `es.logs.base_path`: the absolute path to the configured logs directory 
  * `es.logs.cluster_name`: the default prefix of the filenames used for the various logging files 
  * `es.logs.node_name`: exposed if `node.name` is configured for inclusion in the filenames of the various logging files (if you prefer) 



The property `es.logs` is deprecated and will be removed in Elasticsearch 6.0.0.

#### Use of Netty 3 is deprecated

Usage of Netty 3 for transport (`transport.type=netty3`) or HTTP (`http.type=netty3`) is deprecated and will be removed in Elasticsearch 6.0.0.

### Settings changes

#### Lenient boolean representations are deprecated

Usage of any value other than `false`, `"false"`, `true` and `"true"` in boolean settings deprecated.

### REST API changes

#### Lenient boolean representations are deprecated

Usage of any value other than `false`, `"false"`, `true` and `"true"` for boolean request parameters and boolean properties in the body of REST API calls is deprecated.

### Mapping changes

#### Lenient boolean representations are deprecated

Usage of any value other than `false`, `"false"`, `true` and `"true"` for boolean values in mappings is deprecated.
