## Pre-loading data into the file system cache

![Warning](/images/icons/warning.png)

This is an expert-only setting and may be removed in the future 

By default, elasticsearch completely relies on the operating system file system cache for caching I/O operations. It is possible to set `index.store.preload` in order to tell the operating system to load the content of hot index files into memory upon opening. This setting accept a comma-separated list of files extensions: all files whose extension is in the list will be pre-loaded upon opening. This can be useful to improve search performance of an index, especially when the host operating system is restarted, since this causes the file system cache to be trashed. However note that this may slow down the opening of indices, as they will only become available after data have been loaded into physical memory.

This setting is best-effort only and may not work at all depending on the store type and host operating system.

The `index.store.preload` is a static setting that can either be set in the `config/elasticsearch.yml`:
    
    
    index.store.preload: ["nvd", "dvd"]

or in the index settings at index creation time:
    
    
    PUT /my_index
    {
      "settings": {
        "index.store.preload": ["nvd", "dvd"]
      }
    }

The default value is the empty array, which means that nothing will be loaded into the file-system cache eagerly. For indices that are actively searched, you might want to set it to `["nvd", "dvd"]`, which will cause norms and doc values to be loaded eagerly into physical memory. These are the two first extensions to look at since elasticsearch performs random access on them.

A wildcard can be used in order to indicate that all files should be preloaded: `index.store.preload: ["*"]`. Note however that it is generally not useful to load all files into memory, in particular those for stored fields and term vectors, so a better option might be to set it to `["nvd", "dvd", "tim", "doc", "dim"]`, which will preload norms, doc values, terms dictionaries, postings lists and points, which are the most important parts of the index for search and aggregations.

Note that this setting can be dangerous on indices that are larger than the size of the main memory of the host, as it would cause the filesystem cache to be trashed upon reopens after large merges, which would make indexing and searching _slower_.
