## `index_options`

The `index_options` parameter controls what information is added to the inverted index, for search and highlighting purposes. It accepts the following settings:

`docs`

| 

Only the doc number is indexed. Can answer the question _Does this term exist in this field?_  
  
---|---  
  
`freqs`

| 

Doc number and term frequencies are indexed. Term frequencies are used to score repeated terms higher than single terms.   
  
`positions`

| 

Doc number, term frequencies, and term positions (or order) are indexed. Positions can be used for [proximity or phrase queries](query-dsl-match-query-phrase.html "Match Phrase Query").   
  
`offsets`

| 

Doc number, term frequencies, positions, and start and end character offsets (which map the term back to the original string) are indexed. Offsets are used by the [postings highlighter](search-request-highlighting.html#postings-highlighter "Postings highlighter").   
  
[Analyzed](mapping-index.html "index") string fields use `positions` as the default, and all other fields use `docs` as the default.
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "text": {
              "type": "text",
              "index_options": "offsets"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "text": "Quick brown fox"
    }
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "text": "brown fox"
        }
      },
      "highlight": {
        "fields": {
          "text": {} ![](images/icons/callouts/1.png)
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `text` field will use the postings highlighter by default because `offsets` are indexed.   
  
---|---
