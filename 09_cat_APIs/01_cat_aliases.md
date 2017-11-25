## cat aliases

`aliases` shows information about currently configured aliases to indices including filter and routing infos.
    
    
    GET /_cat/aliases?v

Might respond with:
    
    
    alias  index filter routing.index routing.search
    alias1 test1 -      -            -
    alias2 test1 *      -            -
    alias3 test1 -      1            1
    alias4 test1 -      2            1,2

The output shows that `alias2` has configured a filter, and specific routing configurations in `alias3` and `alias4`.

If you only want to get information about a single alias, you can specify the alias in the URL, for example `/_cat/aliases/alias1`.
