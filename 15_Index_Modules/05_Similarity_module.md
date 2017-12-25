## Similarity module

A similarity (scoring / ranking model) defines how matching documents are scored. Similarity is per field, meaning that via the mapping one can define a different similarity per field.

Configuring a custom similarity is considered a expert feature and the builtin similarities are most likely sufficient as is described in [`similarity`](similarity.html).

### Configuring a similarity

Most existing or custom Similarities have configuration options which can be configured via the index settings as shown below. The index options can be provided when creating an index or updating index settings.
    
    
    "similarity" : {
      "my_similarity" : {
        "type" : "DFR",
        "basic_model" : "g",
        "after_effect" : "l",
        "normalization" : "h2",
        "normalization.h2.c" : "3.0"
      }
    }

Here we configure the DFRSimilarity so it can be referenced as `my_similarity` in mappings as is illustrate in the below example:
    
    
    {
      "book" : {
        "properties" : {
          "title" : { "type" : "text", "similarity" : "my_similarity" }
        }
    }

### Available similarities

#### BM25 similarity ( **default** )

TF/IDF based similarity that has built-in tf normalization and is supposed to work better for short fields (like names). See [Okapi_BM25](http://en.wikipedia.org/wiki/Okapi_BM25) for more details. This similarity has the following options:

`k1`

| 

Controls non-linear term frequency normalization (saturation). The default value is `1.2`.   
  
---|---  
  
`b`

| 

Controls to what degree document length normalizes tf values. The default value is `0.75`.   
  
`discount_overlaps`

| 

Determines whether overlap tokens (Tokens with 0 position increment) are ignored when computing norm. By default this is true, meaning overlap tokens do not count when computing norms.   
  
Type name: `BM25`

#### Classic similarity

The classic similarity that is based on the TF/IDF model. This similarity has the following option:

`discount_overlaps`
     Determines whether overlap tokens (Tokens with 0 position increment) are ignored when computing norm. By default this is true, meaning overlap tokens do not count when computing norms. 

Type name: `classic`

#### DFR similarity

Similarity that implements the [divergence from randomness](http://lucene.apache.org/core/5_2_1/core/org/apache/lucene/search/similarities/DFRSimilarity.html) framework. This similarity has the following options:

`basic_model`

| 

Possible values: `be`, `d`, `g`, `if`, `in`, `ine` and `p`.   
  
---|---  
  
`after_effect`

| 

Possible values: `no`, `b` and `l`.   
  
`normalization`

| 

Possible values: `no`, `h1`, `h2`, `h3` and `z`.   
  
All options but the first option need a normalization value.

Type name: `DFR`

#### DFI similarity

Similarity that implements the [divergence from independence](http://trec.nist.gov/pubs/trec21/papers/irra.web.nb.pdf) model. This similarity has the following options:

`independence_measure`

| 

Possible values `standardized`, `saturated`, `chisquared`.   
  
---|---  
  
Type name: `DFI`

#### IB similarity.

[Information based model](http://lucene.apache.org/core/5_2_1/core/org/apache/lucene/search/similarities/IBSimilarity.html) . The algorithm is based on the concept that the information content in any symbolic _distribution_ sequence is primarily determined by the repetitive usage of its basic elements. For written texts this challenge would correspond to comparing the writing styles of different authors. This similarity has the following options:

`distribution`

| 

Possible values: `ll` and `spl`.   
  
---|---  
  
`lambda`

| 

Possible values: `df` and `ttf`.   
  
`normalization`

| 

Same as in `DFR` similarity.   
  
Type name: `IB`

#### LM Dirichlet similarity.

[LM Dirichlet similarity](http://lucene.apache.org/core/5_2_1/core/org/apache/lucene/search/similarities/LMDirichletSimilarity.html) . This similarity has the following options:

`mu`

| 

Default to `2000`.   
  
---|---  
  
Type name: `LMDirichlet`

#### LM Jelinek Mercer similarity.

[LM Jelinek Mercer similarity](http://lucene.apache.org/core/5_2_1/core/org/apache/lucene/search/similarities/LMJelinekMercerSimilarity.html) . The algorithm attempts to capture important patterns in the text, while leaving out noise. This similarity has the following options:

`lambda`

| 

The optimal value depends on both the collection and the query. The optimal value is around `0.1` for title queries and `0.7` for long queries. Default to `0.1`. When value approaches `0`, documents that match more query terms will be ranked higher than those that match fewer terms.   
  
---|---  
  
Type name: `LMJelinekMercer`

#### Default and Base Similarities

By default, Elasticsearch will use whatever similarity is configured as `default`. However, the similarity functions `queryNorm()` and `coord()` are not per-field. Consequently, for expert users wanting to change the implementation used for these two methods, while not changing the `default`, it is possible to configure a similarity with the name `base`. This similarity will then be used for the two methods.

You can change the default similarity for all fields in an index when it is [created](indices-create-index.html):
    
    
    PUT /my_index
    {
      "settings": {
        "index": {
          "similarity": {
            "default": {
              "type": "classic"
            }
          }
        }
      }
    }

If you want to change the default similarity after creating the index you must [close](indices-open-close.html) your index, send the follwing request and [open](indices-open-close.html) it again afterwards:
    
    
    PUT /my_index/_settings
    {
      "settings": {
        "index": {
          "similarity": {
            "default": {
              "type": "classic"
            }
          }
        }
      }
    }
