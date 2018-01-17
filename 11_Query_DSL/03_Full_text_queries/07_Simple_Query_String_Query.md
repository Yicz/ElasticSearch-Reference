## 简单`query_string` Simple Query String Query

A query that uses the SimpleQueryParser to parse its context. Unlike the regular `query_string` query, the `simple_query_string` query will never throw an exception, and discards invalid parts of the query. Here is an example:
    
    
    GET /_search
    {
      "query": {
        "simple_query_string" : {
            "query": "\"fried eggs\" +(eggplant | potato) -frittata",
            "analyzer": "snowball",
            "fields": ["body^5","_all"],
            "default_operator": "and"
        }
      }
    }

The `simple_query_string` top level parameters include:

Parameter | Description  
---|---  
`query`| The actual query to be parsed. See below for syntax.    
`fields`| The fields to perform the parsed query against. Defaults to the `index.query.default_field` index settings, which inturn defaults to `_all`.    
`default_operator`| The default operator used if no explicit operator is specified. For example, with a default operator of `OR`, thequery `capital of Hungary` is translated to `capital OR of OR Hungary`, and with default operator of `AND`, the samequery is translated to `capital AND of AND Hungary`. The default value is `OR`.    
`analyzer`| The analyzer used to analyze each term of the query when creating composite queries.    
`flags`| Flags specifying which features of the `simple_query_string` to enable. Defaults to `ALL`.    
`analyze_wildcard`| Whether terms of prefix queries should be automatically analyzed or not. If `true` a best effort will be made toanalyze the prefix. However, some analyzers will be not able to provide a meaningful results based just on the prefixof a term. Defaults to `false`.    
`lenient`| If set to `true` will cause format based failures (like providing text to a numeric field) to be ignored.    
`minimum_should_match`| The minimum number of clauses that must match for a document to be returned. See the [`minimum_should_match`]query-dsl-minimum-should-match.html) documentation for the full list of options.    
`quote_field_suffix`| A suffix to append to fields for quoted parts of the query string. This allows to use a field that has a differentanalysis chain for exact matching. Look [here](recipes.html#mixing-exact-search-with-stemming) for a comprehensiveexample.    
`all_fields`| Perform the query on all fields detected in the mapping that can be queried. Will be used by default when the `_all` field is disabled and no `default_field` is specified index settings, and no `fields` are specified.  
  
##### Simple Query String Syntax

The `simple_query_string` supports the following special characters:

  * `+` signifies AND operation 
  * `|` signifies OR operation 
  * `-` negates a single token 
  * `"` wraps a number of tokens to signify a phrase for searching 
  * `*` at the end of a term signifies a prefix query 
  * `(` and `)` signify precedence 
  * `~N` after a word signifies edit distance (fuzziness) 
  * `~N` after a phrase signifies slop amount 



In order to search for any of these special characters, they will need to be escaped with `\`.

Be aware that this syntax may have a different behavior depending on the `default_operator` value. For example, consider the following query:
    
    
    GET /_search
    {
        "query": {
            "simple_query_string" : {
                "fields" : ["content"],
                "query" : "foo bar -baz"
            }
        }
    }

You may expect that documents containing only "foo" or "bar" will be returned, as long as they do not contain "baz", however, due to the `default_operator` being OR, this really means "match documents that contain "foo" or documents that contain "bar", or documents that don’t contain "baz". If this is unintended then the query can be switched to `"foo bar +-baz"` which will not return documents that contain "baz".

#### Default Field

When not explicitly specifying the field to search on in the query string syntax, the `index.query.default_field` will be used to derive which field to search on. It defaults to `_all` field.

If the `_all` field is disabled and no `fields` are specified in the request`, the `simple_query_string` query will automatically attempt to determine the existing fields in the index’s mapping that are queryable, and perform the search on those fields.

#### Multi Field

The fields parameter can also include pattern based field names, allowing to automatically expand to the relevant fields (dynamically introduced fields included). For example:
    
    
    GET /_search
    {
        "query": {
            "simple_query_string" : {
                "fields" : ["content", "name.*^5"],
                "query" : "foo bar baz"
            }
        }
    }

#### Flags

`simple_query_string`支持多个标志来指定应该启用哪些分析功能。 它使用`flags`参数指定为`|`-delimited字符串：
    
    
    GET /_search
    {
        "query": {
            "simple_query_string" : {
                "query" : "foo | bar + baz*",
                "flags" : "OR|AND|PREFIX"
            }
        }
    }

flags参数可以接受的值: `ALL`, `NONE`, `AND`, `OR`, `NOT`, `PREFIX`, `PHRASE`, `PRECEDENCE`, `ESCAPE`, `WHITESPACE`, `FUZZY`, `NEAR`, and `SLOP`.
