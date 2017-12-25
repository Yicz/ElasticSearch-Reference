## `norms`

Norms store various normalization factors that are later used at query time in order to compute the score of a document relatively to a query.

Although useful for scoring, norms also require quite a lot of disk (typically in the order of one byte per document per field in your index, even for documents that don’t have this specific field). As a consequence, if you don’t need scoring on a specific field, you should disable norms on that field. In particular, this is the case for fields that are used solely for filtering or aggregations.

![Tip](images/icons/tip.png)

The `norms` setting must have the same setting for fields of the same name in the same index. Norms can be disabled on existing fields using the [PUT mapping API](indices-put-mapping.html).

Norms can be disabled (but not reenabled) after the fact, using the [PUT mapping API](indices-put-mapping.html) like so:
    
    
    PUT my_index/_mapping/my_type
    {
      "properties": {
        "title": {
          "type": "text",
          "norms": false
        }
      }
    }

![Note](images/icons/note.png)

Norms will not be removed instantly, but will be removed as old segments are merged into new segments as you continue indexing new documents. Any score computation on a field that has had norms removed might return inconsistent results since some documents won’t have norms anymore while other documents might still have norms.