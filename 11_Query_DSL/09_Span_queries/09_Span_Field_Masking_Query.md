## Span Field Masking Query

Wrapper to allow span queries to participate in composite single-field span queries by _lying_ about their search field. The span field masking query maps to Lucene’s `SpanFieldMaskingQuery`

This can be used to support queries like `span-near` or `span-or` across different fields, which is not ordinarily permitted.

Span field masking query is invaluable in conjunction with **multi-fields** when same content is indexed with multiple analyzers. For instance we could index a field with the standard analyzer which breaks text up into words, and again with the english analyzer which stems words into their root form.

Example:
    
    
    GET /_search
    {
      "query": {
        "span_near": {
          "clauses": [
            {
              "span_term": {
                "text": "quick brown"
              }
            },
            {
              "field_masking_span": {
                "query": {
                  "span_term": {
                    "text.stems": "fox"
                  }
                },
                "field": "text"
              }
            }
          ],
          "slop": 5,
          "in_order": false
        }
      }
    }

Note: as span field masking query returns the masked field, scoring will be done using the norms of the field name supplied. This may lead to unexpected scoring behaviour.
