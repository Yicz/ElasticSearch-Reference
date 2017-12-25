## Pipeline Definition

A pipeline is a definition of a series of [processors](ingest-processors.html) that are to be executed in the same order as they are declared. A pipeline consists of two main fields: a `description` and a list of `processors`:
    
    
    {
      "description" : "...",
      "processors" : [ ... ]
    }

The `description` is a special field to store a helpful description of what the pipeline does.

The `processors` parameter defines a list of processors to be executed in order.
