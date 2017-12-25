## Query String Query

A query that uses a query parser in order to parse its content. Here is an example:
    
    
    GET /_search
    {
        "query": {
            "query_string" : {
                "default_field" : "content",
                "query" : "this AND that OR thus"
            }
        }
    }

The `query_string` top level parameters include:

Parameter | Description  
---|---  
  
`query`

| 

The actual query to be parsed. See [Query string syntax](query-dsl-query-string-query.html#query-string-syntax).  
  
`default_field`

| 

The default field for query terms if no prefix field is specified. Defaults to the `index.query.default_field` index settings, which in turn defaults to `_all`.  
  
`default_operator`

| 

The default operator used if no explicit operator is specified. For example, with a default operator of `OR`, the query `capital of Hungary` is translated to `capital OR of OR Hungary`, and with default operator of `AND`, the same query is translated to `capital AND of AND Hungary`. The default value is `OR`.  
  
`analyzer`

| 

The analyzer name used to analyze the query string.  
  
`allow_leading_wildcard`

| 

When set, `*` or `?` are allowed as the first character. Defaults to `true`.  
  
`enable_position_increments`

| 

Set to `true` to enable position increments in result queries. Defaults to `true`.  
  
`fuzzy_max_expansions`

| 

Controls the number of terms fuzzy queries will expand to. Defaults to `50`  
  
`fuzziness`

| 

Set the fuzziness for fuzzy queries. Defaults to `AUTO`. See [Fuzziness for allowed settings.  
  
`fuzzy_prefix_length`

| 

Set the prefix length for fuzzy queries. Default is `0`.  
  
`phrase_slop`

| 

Sets the default slop for phrases. If zero, then exact phrase matches are required. Default value is `0`.  
  
`boost`

| 

Sets the boost value of the query. Defaults to `1.0`.  
  
`auto_generate_phrase_queries`

| 

Defaults to `false`.  
  
`analyze_wildcard`

| 

By default, wildcards terms in a query string are not analyzed. By setting this value to `true`, a best effort will be made to analyze those as well.  
  
`max_determinized_states`

| 

Limit on how many automaton states regexp queries are allowed to create. This protects against too-difficult (e.g. exponentially hard) regexps. Defaults to 10000.  
  
`minimum_should_match`

| 

A value controlling how many).  
  
`lenient`

| 

If set to `true` will cause format based failures (like providing text to a numeric field) to be ignored.  
  
`time_zone`

| 

Time Zone to be applied to any range query related to dates. See also [JODA timezone](http://www.joda.org/joda-time/apidocs/org/joda/time/DateTimeZone.html).  
  
`quote_field_suffix`

| 

A suffix to append to fields for quoted parts of the query string. This allows to use a field that has a different analysis chain for exact matching. Look [here](recipes.html#mixing-exact-search-with-stemming) for a comprehensive example.  
  
`split_on_whitespace`

| 

Whether query text should be split on whitespace prior to analysis. Instead the queryparser would parse around only real _operators_. Defaults to `true`. It is not allowed to set this option to `false` if `auto_generate_phrase_queries` is already set to `true`.  
  
`all_fields`

| 

Perform the query on all fields detected in the mapping that can be queried. Will be used by default when the `_all` field is disabled and no `default_field` is specified (either in the index settings or in the request body) and no `fields` are specified.  
  
When a multi term query is being generated, one can control how it gets rewritten using the [rewrite](query-dsl-multi-term-rewrite.html) parameter.

#### Default Field

When not explicitly specifying the field to search on in the query string syntax, the `index.query.default_field` will be used to derive which field to search on. It defaults to `_all` field.

If the `_all` field is disabled, the `query_string` query will automatically attempt to determine the existing fields in the index’s mapping that are queryable, and perform the search on those fields. Note that this will not include nested documents, use a nested query to search those documents.

#### Multi Field

The `query_string` query can also run against multiple fields. Fields can be provided via the `"fields"` parameter (example below).

The idea of running the `query_string` query against multiple fields is to expand each query term to an OR clause like this:
    
    
    field1:query_term OR field2:query_term | ...

For example, the following query
    
    
    GET /_search
    {
        "query": {
            "query_string" : {
                "fields" : ["content", "name"],
                "query" : "this AND that"
            }
        }
    }

matches the same words as
    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "(content:this OR name:this) AND (content:that OR name:that)"
            }
        }
    }

Since several queries are generated from the individual search terms, combining them can be automatically done using either a `dis_max` query or a simple `bool` query. For example (the `name` is boosted by 5 using `^5` notation):
    
    
    GET /_search
    {
        "query": {
            "query_string" : {
                "fields" : ["content", "name^5"],
                "query" : "this AND that OR thus",
                "use_dis_max" : true
            }
        }
    }

Simple wildcard can also be used to search "within" specific inner elements of the document. For example, if we have a `city` object with several fields (or inner object with fields) in it, we can automatically search on all "city" fields:
    
    
    GET /_search
    {
        "query": {
            "query_string" : {
                "fields" : ["city.*"],
                "query" : "this AND that OR thus",
                "use_dis_max" : true
            }
        }
    }

Another option is to provide the wildcard fields search in the query string itself (properly escaping the `*` sign), for example: `city.\*:something`:
    
    
    GET /_search
    {
        "query": {
            "query_string" : {
                "query" : "city.\\*:(this AND that OR thus)",
                "use_dis_max" : true
            }
        }
    }

![Note](images/icons/note.png)

Since `\` (backslash) is a special character in json strings, it needs to be escaped, hence the two backslashes in the above `query_string`.

When running the `query_string` query against multiple fields, the following additional parameters are allowed:

Parameter | Description  
---|---  
  
`use_dis_max`

| 

Should the queries be combined using `dis_max` (set it to `true`), or a `bool` query (set it to `false`). Defaults to `true`.  
  
`tie_breaker`

| 

When using `dis_max`, the disjunction max tie breaker. Defaults to `0`.  
  
The fields parameter can also include pattern based field names, allowing to automatically expand to the relevant fields (dynamically introduced fields included). For example:
    
    
    GET /_search
    {
        "query": {
            "query_string" : {
                "fields" : ["content", "name.*^5"],
                "query" : "this AND that OR thus",
                "use_dis_max" : true
            }
        }
    }

### Query string syntax

The query string “mini-language” is used by the [Query String Query](query-dsl-query-string-query.html) and by the `q` query string parameter in the [`search` API](search-search.html).

The query string is parsed into a series of _terms_ and _operators_. A term can be a single word — `quick` or `brown` — or a phrase, surrounded by double quotes — `"quick brown"` — which searches for all the words in the phrase, in the same order.

Operators allow you to customize the search — the available options are explained below.

#### Field names

As mentioned in [Query String Query](query-dsl-query-string-query.html), the `default_field` is searched for the search terms, but it is possible to specify other fields in the query syntax:

  * where the `status` field contains `active`
    
        status:active

  * where the `title` field contains `quick` or `brown`. If you omit the OR operator the default operator will be used 
    
        title:(quick OR brown)
    title:(quick brown)

  * where the `author` field contains the exact phrase `"john smith"`
    
        author:"John Smith"

  * where any of the fields `book.title`, `book.content` or `book.date` contains `quick` or `brown` (note how we need to escape the `*` with a backslash): 
    
        book.\*:(quick brown)

  * where the field `title` has any non-null value: 
    
        _exists_:title




#### Wildcards

Wildcard searches can be run on individual terms, using `?` to replace a single character, and `*` to replace zero or more characters:
    
    
    qu?ck bro*

Be aware that wildcard queries can use an enormous amount of memory and perform very badly — just think how many terms need to be queried to match the query string `"a* b* c*"`.

![Warning](images/icons/warning.png)

Allowing a wildcard at the beginning of a word (eg `"*ing"`) is particularly heavy, because all terms in the index need to be examined, just in case they match. Leading wildcards can be disabled by setting `allow_leading_wildcard` to `false`.

Only parts of the analysis chain that operate at the character level are applied. So for instance, if the analyzer performs both lowercasing and stemming, only the lowercasing will be applied: it would be wrong to perform stemming on a word that is missing some of its letters.

By setting `analyze_wildcard` to true, queries that end with a `*` will be analyzed and a boolean query will be built out of the different tokens, by ensuring exact matches on the first N-1 tokens, and prefix match on the last token.

#### Regular expressions

Regular expression patterns can be embedded in the query string by wrapping them in forward-slashes (`"/"`):
    
    
    name:/joh?n(ath[oa]n)/

The supported regular expression syntax is explained in [Regular expression syntax](query-dsl-regexp-query.html#regexp-syntax).

![Warning](images/icons/warning.png)

The `allow_leading_wildcard` parameter does not have any control over regular expressions. A query string such as the following would force Elasticsearch to visit every term in the index:
    
    
    /.*n/

Use with caution!

#### Fuzziness

We can search for terms that are similar to, but not exactly like our search terms, using the “fuzzy” operator:
    
    
    quikc~ brwn~ foks~

This uses the [Damerau-Levenshtein distance](http://en.wikipedia.org/wiki/Damerau-Levenshtein_distance) to find all terms with a maximum of two changes, where a change is the insertion, deletion or substitution of a single character, or transposition of two adjacent characters.

The default _edit distance_ is `2`, but an edit distance of `1` should be sufficient to catch 80% of all human misspellings. It can be specified as:
    
    
    quikc~1

#### Proximity searches

While a phrase query (eg `"john smith"`) expects all of the terms in exactly the same order, a proximity query allows the specified words to be further apart or in a different order. In the same way that fuzzy queries can specify a maximum edit distance for characters in a word, a proximity search allows us to specify a maximum edit distance of words in a phrase:
    
    
    "fox quick"~5

The closer the text in a field is to the original order specified in the query string, the more relevant that document is considered to be. When compared to the above example query, the phrase `"quick fox"` would be considered more relevant than `"quick brown fox"`.

#### Ranges

Ranges can be specified for date, numeric or string fields. Inclusive ranges are specified with square brackets `[min TO max]` and exclusive ranges with curly brackets `{min TO max}`.

  * All days in 2012: 
    
        date:[2012-01-01 TO 2012-12-31]

  * Numbers 1..5 
    
        count:[1 TO 5]

  * Tags between `alpha` and `omega`, excluding `alpha` and `omega`: 
    
        tag:{alpha TO omega}

  * Numbers from 10 upwards 
    
        count:[10 TO *]

  * Dates before 2012 
    
        date:{* TO 2012-01-01}




Curly and square brackets can be combined:

  * Numbers from 1 up to but not including 5 
    
        count:[1 TO 5}




Ranges with one side unbounded can use the following syntax:
    
    
    age:>10
    age:>=10
    age:<10
    age:<=10

![Note](images/icons/note.png)

To combine an upper and lower bound with the simplified syntax, you would need to join two clauses with an `AND` operator:
    
    
    age:(>=10 AND <20)
    age:(+>=10 +<20)

The parsing of ranges in query strings can be complex and error prone. It is much more reliable to use an explicit [`range` query](query-dsl-range-query.html).

#### Boosting

Use the _boost_ operator `^` to make one term more relevant than another. For instance, if we want to find all documents about foxes, but we are especially interested in quick foxes:
    
    
    quick^2 fox

The default `boost` value is 1, but can be any positive floating point number. Boosts between 0 and 1 reduce relevance.

Boosts can also be applied to phrases or to groups:
    
    
    "john smith"^2   (foo bar)^4

#### Boolean operators

By default, all terms are optional, as long as one term matches. A search for `foo bar baz` will find any document that contains one or more of `foo` or `bar` or `baz`. We have already discussed the `default_operator` above which allows you to force all terms to be required, but there are also _boolean operators_ which can be used in the query string itself to provide more control.

The preferred operators are `+` (this term **must** be present) and `-` (this term **must not** be present). All other terms are optional. For example, this query:
    
    
    quick brown +fox -news

states that:

  * `fox` must be present 
  * `news` must not be present 
  * `quick` and `brown` are optional — their presence increases the relevance 



The familiar operators `AND`, `OR` and `NOT` (also written `&&`, `||` and `!`) are also supported. However, the effects of these operators can be more complicated than is obvious at first glance. `NOT` takes precedence over `AND`, which takes precedence over `OR`. While the `+` and `-` only affect the term to the right of the operator, `AND` and `OR` can affect the terms to the left and right.

Rewriting the above query using `AND`, `OR` and `NOT` demonstrates the complexity:

`quick OR brown AND fox AND NOT news`
     This is incorrect, because `brown` is now a required term. 
`(quick OR brown) AND fox AND NOT news`
     This is incorrect because at least one of `quick` or `brown` is now required and the search for those terms would be scored differently from the original query. 
`((quick AND fox) OR (brown AND fox) OR fox) AND NOT news`
     This form now replicates the logic from the original query correctly, but the relevance scoring bears little resemblance to the original. 

In contrast, the same query rewritten using the [`match` query](query-dsl-match-query.html) would look like this:
    
    
    {
        "bool": {
            "must":     { "match": "fox"         },
            "should":   { "match": "quick brown" },
            "must_not": { "match": "news"        }
        }
    }

#### Grouping

Multiple terms or clauses can be grouped together with parentheses, to form sub-queries:
    
    
    (quick OR brown) AND fox

Groups can be used to target a particular field, or to boost the result of a sub-query:
    
    
    status:(active OR pending) title:(full text search)^2

#### Reserved characters

If you need to use any of the characters which function as operators in your query itself (and not as operators), then you should escape them with a leading backslash. For instance, to search for `(1+1)=2`, you would need to write your query as `\(1\+1\)\=2`.

The reserved characters are: `+ - = && || > < ! ( ) { } [ ] ^ " ~ * ? : \ /`

Failing to escape these special characters correctly could lead to a syntax error which prevents your query from running.

![Note](images/icons/note.png)

`<` and `>` can’t be escaped at all. The only way to prevent them from attempting to create a range query is to remove them from the query string entirely.

 **Watch this space**

A space may also be a reserved character. For instance, if you have a synonym list which converts `"wi fi"` to `"wifi"`, a `query_string` search for `"wi fi"` would fail. The query string parser would interpret your query as a search for `"wi OR fi"`, while the token stored in your index is actually `"wifi"`. The option `split_on_whitespace=false` will protect it from being touched by the query string parser and will let the analysis run on the entire input (`"wi fi"`).

#### Empty Query

If the query string is empty or only contains whitespaces the query will yield an empty result set.
