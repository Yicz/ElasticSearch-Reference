## `similarity`

Elasticsearch allows you to configure a scoring algorithm or _similarity_ per field. The `similarity` setting provides a simple way of choosing a similarity algorithm other than the default `BM25`, such as `TF/IDF`.

Similarities are mostly useful for [`text`](text.html "Text datatype") fields, but can also apply to other field types.

Custom similarities can be configured by tuning the parameters of the built-in similarities. For more details about this expert options, see the [similarity module](index-modules-similarity.html "Similarity module").

The only similarities which can be used out of the box, without any further configuration are:

`BM25`
     The Okapi BM25 algorithm. The algorithm used by default in Elasticsearch and Lucene. See [Pluggable Similarity Algorithms](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/pluggable-similarites.html) for more information. 
`classic`
     The TF/IDF algorithm which used to be the default in Elasticsearch and Lucene. See [Lucene’s Practical Scoring Function](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/practical-scoring-function.html) for more information. 
`boolean`
     A simple boolean similarity, which is used when full-text ranking is not needed and the score should only be based on whether the query terms match or not. Boolean similarity gives terms a score equal to their query boost. 

The `similarity` can be set on the field level when a field is first created, as follows:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "default_field": { ![](images/icons/callouts/1.png)
              "type": "text"
            },
            "classic_field": {
              "type": "text",
              "similarity": "classic" ![](images/icons/callouts/2.png)
            },
            "boolean_sim_field": {
              "type": "text",
              "similarity": "boolean" ![](images/icons/callouts/3.png)
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `default_field` uses the `BM25` similarity.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `classic_field` uses the `classic` similarity (ie TF/IDF).   
  
![](images/icons/callouts/3.png)

| 

The `boolean_sim_field` uses the `boolean` similarity. 
