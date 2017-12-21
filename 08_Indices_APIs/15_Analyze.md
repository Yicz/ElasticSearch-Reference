## Analyze

Performs the analysis process on a text and return the tokens breakdown of the text.

Can be used without specifying an index against one of the many built in analyzers:
    
    
    GET _analyze
    {
      "analyzer" : "standard",
      "text" : "this is a test"
    }

If text parameter is provided as array of strings, it is analyzed as a multi-valued field.
    
    
    GET _analyze
    {
      "analyzer" : "standard",
      "text" : ["this is a test", "the second text"]
    }

Or by building a custom transient analyzer out of tokenizers, token filters and char filters. Token filters can use the shorter _filter_ parameter name:
    
    
    GET _analyze
    {
      "tokenizer" : "keyword",
      "filter" : ["lowercase"],
      "text" : "this is a test"
    }
    
    
    GET _analyze
    {
      "tokenizer" : "keyword",
      "filter" : ["lowercase"],
      "char_filter" : ["html_strip"],
      "text" : "this is a <b>test</b>"
    }

![Warning](images/icons/warning.png)

### Deprecated in 5.0.0. 

Use `filter`/`char_filter` instead of `filters`/`char_filters` and `token_filters` has been removed 

Custom tokenizers, token filters, and character filters can be specified in the request body as follows:
    
    
    GET _analyze
    {
      "tokenizer" : "whitespace",
      "filter" : ["lowercase", {"type": "stop", "stopwords": ["a", "is", "this"]}],
      "text" : "this is a test"
    }

It can also run against a specific index:
    
    
    GET twitter/_analyze
    {
      "text" : "this is a test"
    }

The above will run an analysis on the "this is a test" text, using the default index analyzer associated with the `test` index. An `analyzer` can also be provided to use a different analyzer:
    
    
    GET twitter/_analyze
    {
      "analyzer" : "whitespace",
      "text" : "this is a test"
    }

Also, the analyzer can be derived based on a field mapping, for example:
    
    
    GET twitter/_analyze
    {
      "field" : "obj1.field1",
      "text" : "this is a test"
    }

Will cause the analysis to happen based on the analyzer configured in the mapping for `obj1.field1` (and if not, the default index analyzer).

![Warning](images/icons/warning.png)

Deprecated in 5.1.0 request parameters are deprecated and will be removed in the next major release. please use JSON params instead of request params. 

All parameters can also supplied as request parameters. For example:
    
    
    GET /_analyze?tokenizer=keyword&filter=lowercase&text=this+is+a+test

For backwards compatibility, we also accept the text parameter as the body of the request, provided it doesn’t start with `{` :
    
    
    curl -XGET 'localhost:9200/_analyze?tokenizer=keyword&filter=lowercase&char_filter=reverse' -d 'this is a test' -H 'Content-Type: text/plain'

![Warning](images/icons/warning.png)

Deprecated in 5.1.0 the text parameter as the body of the request are deprecated and this feature will be removed in the next major release. please use JSON text param. 
