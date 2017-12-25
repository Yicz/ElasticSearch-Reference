## Post filter

The `post_filter` is applied to the search `hits` at the very end of a search request, after aggregations have already been calculated. Its purpose is best explained by example:

Imagine that you are selling shirts that have the following properties:
    
    
    PUT /shirts
    {
        "mappings": {
            "item": {
                "properties": {
                    "brand": { "type": "keyword"},
                    "color": { "type": "keyword"},
                    "model": { "type": "keyword"}
                }
            }
        }
    }
    
    PUT /shirts/item/1?refresh
    {
        "brand": "gucci",
        "color": "red",
        "model": "slim"
    }

Imagine a user has specified two filters:

`color:red` and `brand:gucci`. You only want to show them red shirts made by Gucci in the search results. Normally you would do this with a [`bool` query](query-dsl-bool-query.html):
    
    
    GET /shirts/_search
    {
      "query": {
        "bool": {
          "filter": [
            { "term": { "color": "red"   } },
            { "term": { "brand": "gucci" } }
          ]
        }
      }
    }

However, you would also like to use _faceted navigation_ to display a list of other options that the user could click on. Perhaps you have a `model` field that would allow the user to limit their search results to red Gucci `t-shirts` or `dress-shirts`.

This can be done with a [`terms` aggregation](search-aggregations-bucket-terms-aggregation.html):
    
    
    GET /shirts/_search
    {
      "query": {
        "bool": {
          "filter": [
            { "term": { "color": "red"   } },
            { "term": { "brand": "gucci" } }
          ]
        }
      },
      "aggs": {
        "models": {
          "terms": { "field": "model" } ![](images/icons/callouts/1.png)
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Returns the most popular models of red shirts by Gucci.   
  
---|---  
  
But perhaps you would also like to tell the user how many Gucci shirts are available in **other colors**. If you just add a `terms` aggregation on the `color` field, you will only get back the color `red`, because your query returns only red shirts by Gucci.

Instead, you want to include shirts of all colors during aggregation, then apply the `colors` filter only to the search results. This is the purpose of the `post_filter`:
    
    
    GET /shirts/_search
    {
      "query": {
        "bool": {
          "filter": {
            "term": { "brand": "gucci" } ![](images/icons/callouts/1.png)
          }
        }
      },
      "aggs": {
        "colors": {
          "terms": { "field": "color" } ![](images/icons/callouts/2.png)
        },
        "color_red": {
          "filter": {
            "term": { "color": "red" } ![](images/icons/callouts/3.png)
          },
          "aggs": {
            "models": {
              "terms": { "field": "model" } ![](images/icons/callouts/4.png)
            }
          }
        }
      },
      "post_filter": { ![](images/icons/callouts/5.png)
        "term": { "color": "red" }
      }
    }

![](images/icons/callouts/1.png)

| 

The main query now finds all shirts by Gucci, regardless of color.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `colors` agg returns popular colors for shirts by Gucci.   
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/4.png)

| 

The `color_red` agg limits the `models` sub-aggregation to **red** Gucci shirts.   
  
![](images/icons/callouts/5.png)

| 

Finally, the `post_filter` removes colors other than red from the search `hits`. 
