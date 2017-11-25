## URL-based access control

Many users use a proxy with URL-based access control to secure access to Elasticsearch indices. For [multi-search](search-multi-search.html "Multi Search API"), [multi-get](docs-multi-get.html "Multi Get API") and [bulk](docs-bulk.html "Bulk API") requests, the user has the choice of specifying an index in the URL and on each individual request within the request body. This can make URL-based access control challenging.

To prevent the user from overriding the index which has been specified in the URL, add this setting to the `elasticsearch.yml` file:
    
    
    rest.action.multi.allow_explicit_index: false

The default value is `true`, but when set to `false`, Elasticsearch will reject requests that have an explicit index specified in the request body.
