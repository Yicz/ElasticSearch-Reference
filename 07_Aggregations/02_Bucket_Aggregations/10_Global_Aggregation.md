## Global Aggregation

Defines a single bucket of all the documents within the search execution context. This context is defined by the indices and the document types you’re searching on, but is **not** influenced by the search query itself.

![Note](images/icons/note.png)

Global aggregators can only be placed as top level aggregators because it doesn’t make sense to embed a global aggregator within another bucket aggregator.

Example:
    
    
    POST /sales/_search?size=0
    {
        "query" : {
            "match" : { "type" : "t-shirt" }
        },
        "aggs" : {
            "all_products" : {
                "global" : {}, ![](images/icons/callouts/1.png)
                "aggs" : { ![](images/icons/callouts/2.png)
                    "avg_price" : { "avg" : { "field" : "price" } }
                }
            },
            "t_shirts": { "avg" : { "field" : "price" } }
        }
    }

![](images/icons/callouts/1.png)

| 

The `global` aggregation has an empty body   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The sub-aggregations that are registered for this `global` aggregation   
  
The above aggregation demonstrates how one would compute aggregations (`avg_price` in this example) on all the documents in the search context, regardless of the query (in our example, it will compute the average price over all products in our catalog, not just on the).

The response for the above aggregation:
    
    
    {
        ...
        "aggregations" : {
            "all_products" : {
                "doc_count" : 7, ![](images/icons/callouts/1.png)
                "avg_price" : {
                    "value" : 140.71428571428572 ![](images/icons/callouts/2.png)
                }
            },
            "t_shirts": {
                "value" : 128.33333333333334 ![](images/icons/callouts/3.png)
            }
        }
    }

![](images/icons/callouts/1.png)

| 

The number of documents that were aggregated (in our case, all documents within the search context)   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The average price of all products in the index   
  
![](images/icons/callouts/3.png)

| 

The average price of all t-shirts 
