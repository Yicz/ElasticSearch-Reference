## Get Index

The get index API allows to retrieve information about one or more indexes.
    
    
    GET /twitter

The above example gets the information for an index called `twitter`. Specifying an index, alias or wildcard expression is required.

The get index API can also be applied to more than one index, or on all indices by using `_all` or `*` as index.

### Filtering index information

The information returned by the get API can be filtered to include only specific features by specifying a comma delimited list of features in the URL:
    
    
    GET twitter/_settings,_mappings

The above command will only return the settings and mappings for the index called `twitter`.

The available features are `_settings`, `_mappings` and `_aliases`.
