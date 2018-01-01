## 查看字段信息 cat fielddata

`fielddata` shows how much heap memory is currently being used by fielddata on every data node in the cluster.
    
    
    GET /_cat/fielddata?v

Looks like:
    
    
    id                     host      ip        node    field   size
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in body    544b
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in soul    480b

Fields can be specified either as a query parameter, or in the URL path:
    
    
    GET /_cat/fielddata?v&fields=body

Which looks like:
    
    
    id                     host      ip        node    field   size
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in body    544b

And it accepts a comma delimited list:
    
    
    GET /_cat/fielddata/body,soul?v

Which produces the same output as the first snippet:
    
    
    id                     host      ip        node    field   size
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in body    544b
    Nqk-6inXQq-OxUfOUI8jNQ 127.0.0.1 127.0.0.1 Nqk-6in soul    480b

The output shows the individual fielddata for the `body` and `soul` fields, one row per field per node.
