## Grok Processor

Extracts structured fields out of a single text field within a document. You choose which field to extract matched fields from, as well as the grok pattern you expect will match. A grok pattern is like a regular expression that supports aliased expressions that can be reused.

This tool is perfect for syslog logs, apache and other webserver logs, mysql logs, and in general, any log format that is generally written for humans and not computer consumption. This processor comes packaged with over [120 reusable patterns](https://github.com/elastic/elasticsearch/tree/master/modules/ingest-common/src/main/resources/patterns).

If you need help building patterns to match your logs, you will find the <http://grokdebug.herokuapp.com> and <http://grokconstructor.appspot.com/> applications quite useful!

### Grok Basics

Grok sits on top of regular expressions, so any regular expressions are valid in grok as well. The regular expression library is Oniguruma, and you can see the full supported regexp syntax [on the Onigiruma site](https://github.com/kkos/oniguruma/blob/master/doc/RE).

Grok works by leveraging this regular expression language to allow naming existing patterns and combining them into more complex patterns that match your fields.

The syntax for reusing a grok pattern comes in three forms: `%{SYNTAX:SEMANTIC}`, `%{SYNTAX}`, `%{SYNTAX:SEMANTIC:TYPE}`.

The `SYNTAX` is the name of the pattern that will match your text. For example, `3.44` will be matched by the `NUMBER` pattern and `55.3.244.1` will be matched by the `IP` pattern. The syntax is how you match. `NUMBER` and `IP` are both patterns that are provided within the default patterns set.

The `SEMANTIC` is the identifier you give to the piece of text being matched. For example, `3.44` could be the duration of an event, so you could call it simply `duration`. Further, a string `55.3.244.1` might identify the `client` making a request.

The `TYPE` is the type you wish to cast your named field. `int` and `float` are currently the only types supported for coercion.

For example, you might want to match the following text:
    
    
    3.44 55.3.244.1

You may know that the message in the example is a number followed by an IP address. You can match this text by using the following Grok expression.
    
    
    %{NUMBER:duration} %{IP:client}

### Using the Grok Processor in a Pipeline

 **Table 20. Grok Options**

Name |  Required |  Default |  Description  
---|---|---|---  
  
`field`

| 

yes

| 

-

| 

The field to use for grok expression parsing  
  
`patterns`

| 

yes

| 

-

| 

An ordered list of grok expression to match and extract named captures with. Returns on the first expression in the list that matches.  
  
`pattern_definitions`

| 

no

| 

-

| 

A map of pattern-name and pattern tuples defining custom patterns to be used by the current processor. Patterns matching existing names will override the pre-existing definition.  
  
`trace_match`

| 

no

| 

false

| 

when true, `_ingest._grok_match_index` will be inserted into your matched document’s metadata with the index into the pattern found in `patterns` that matched.  
  
`ignore_missing`

| 

no

| 

false

| 

If `true` and `field` does not exist or is `null`, the processor quietly exits without modifying the document  
  
  


Here is an example of using the provided patterns to extract out and name structured fields from a string field in a document.
    
    
    {
      "message": "55.3.244.1 GET /index.html 15824 0.043"
    }

The pattern for this could be:
    
    
    %{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}

Here is an example pipeline for processing the above document by using Grok:
    
    
    {
      "description" : "...",
      "processors": [
        {
          "grok": {
            "field": "message",
            "patterns": ["%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}"]
          }
        }
      ]
    }

This pipeline will insert these named captures as new fields within the document, like so:
    
    
    {
      "message": "55.3.244.1 GET /index.html 15824 0.043",
      "client": "55.3.244.1",
      "method": "GET",
      "request": "/index.html",
      "bytes": 15824,
      "duration": "0.043"
    }

### Custom Patterns and Pattern Files

The Grok processor comes pre-packaged with a base set of pattern. These patterns may not always have what you are looking for. Pattern have a very basic format. Each entry describes has a name and the pattern itself.

You can add your own patterns to a processor definition under the `pattern_definitions` option. Here is an example of a pipeline specifying custom pattern definitions:
    
    
    {
      "description" : "...",
      "processors": [
        {
          "grok": {
            "field": "message",
            "patterns": ["my %{FAVORITE_DOG:dog} is colored %{RGB:color}"]
            "pattern_definitions" : {
              "FAVORITE_DOG" : "beagle",
              "RGB" : "RED|GREEN|BLUE"
            }
          }
        }
      ]
    }

### Providing Multiple Match Patterns

Sometimes one pattern is not enough to capture the potential structure of a field. Let’s assume we want to match all messages that contain your favorite pet breeds of either cats or dogs. One way to accomplish this is to provide two distinct patterns that can be matched, instead of one really complicated expression capturing the same `or` behavior.

Here is an example of such a configuration executed against the simulate API:
    
    
    POST _ingest/pipeline/_simulate
    {
      "pipeline": {
      "description" : "parse multiple patterns",
      "processors": [
        {
          "grok": {
            "field": "message",
            "patterns": ["%{FAVORITE_DOG:pet}", "%{FAVORITE_CAT:pet}"],
            "pattern_definitions" : {
              "FAVORITE_DOG" : "beagle",
              "FAVORITE_CAT" : "burmese"
            }
          }
        }
      ]
    },
    "docs":[
      {
        "_source": {
          "message": "I love burmese cats!"
        }
      }
      ]
    }

response:
    
    
    {
      "docs": [
        {
          "doc": {
            "_type": "_type",
            "_index": "_index",
            "_id": "_id",
            "_source": {
              "message": "I love burmese cats!",
              "pet": "burmese"
            },
            "_ingest": {
              "timestamp": "2016-11-08T19:43:03.850+0000"
            }
          }
        }
      ]
    }

Both patterns will set the field `pet` with the appropriate match, but what if we want to trace which of our patterns matched and populated our fields? We can do this with the `trace_match` parameter. Here is the output of that same pipeline, but with `"trace_match": true` configured:
    
    
    {
      "docs": [
        {
          "doc": {
            "_type": "_type",
            "_index": "_index",
            "_id": "_id",
            "_source": {
              "message": "I love burmese cats!",
              "pet": "burmese"
            },
            "_ingest": {
              "_grok_match_index": "1",
              "timestamp": "2016-11-08T19:43:03.850+0000"
            }
          }
        }
      ]
    }

In the above response, you can see that the index of the pattern that matched was `"1"`. This is to say that it was the second (index starts at zero) pattern in `patterns` to match.

This trace metadata enables debugging which of the patterns matched. This information is stored in the ingest metadata and will not be indexed.
