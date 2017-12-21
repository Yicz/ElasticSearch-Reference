## Accessing Data in Pipelines

The processors in a pipeline have read and write access to documents that pass through the pipeline. The processors can access fields in the source of a document and the document’s metadata fields.

### Accessing Fields in the Source

Accessing a field in the source is straightforward. You simply refer to fields by their name. For example:
    
    
    {
      "set": {
        "field": "my_field"
        "value": 582.1
      }
    }

On top of this, fields from the source are always accessible via the `_source` prefix:
    
    
    {
      "set": {
        "field": "_source.my_field"
        "value": 582.1
      }
    }

### Accessing Metadata Fields

You can access metadata fields in the same way that you access fields in the source. This is possible because Elasticsearch doesn’t allow fields in the source that have the same name as metadata fields.

The following example sets the `_id` metadata field of a document to `1`:
    
    
    {
      "set": {
        "field": "_id"
        "value": "1"
      }
    }

The following metadata fields are accessible by a processor: `_index`, `_type`, `_id`, `_routing`, `_parent`.

### Accessing Ingest Metadata Fields

Beyond metadata fields and source fields, ingest also adds ingest metadata to the documents that it processes. These metadata properties are accessible under the `_ingest` key. Currently ingest adds the ingest timestamp under the `_ingest.timestamp` key of the ingest metadata. The ingest timestamp is the time when Elasticsearch received the index or bulk request to pre-process the document.

Any processor can add ingest-related metadata during document processing. Ingest metadata is transient and is lost after a document has been processed by the pipeline. Therefore, ingest metadata won’t be indexed.

The following example adds a field with the name `received`. The value is the ingest timestamp:
    
    
    {
      "set": {
        "field": "received"
        "value": "{ {_ingest.timestamp} }"
      }
    }

Unlike Elasticsearch metadata fields, the ingest metadata field name `_ingest` can be used as a valid field name in the source of a document. Use `_source._ingest` to refer to the field in the source document. Otherwise, `_ingest` will be interpreted as an ingest metadata field.

### Accessing Fields and Metafields in Templates

A number of processor settings also support templating. Settings that support templating can have zero or more template snippets. A template snippet begins with `{ {` and ends with `} }`. Accessing fields and metafields in templates is exactly the same as via regular processor field settings.

The following example adds a field named `field_c`. Its value is a concatenation of the values of `field_a` and `field_b`.
    
    
    {
      "set": {
        "field": "field_c"
        "value": "{ {field_a} } { {field_b} }"
      }
    }

The following example uses the value of the `geoip.country_iso_code` field in the source to set the index that the document will be indexed into:
    
    
    {
      "set": {
        "field": "_index"
        "value": "{ {geoip.country_iso_code} }"
      }
    }
