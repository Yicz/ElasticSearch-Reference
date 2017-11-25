## cat repositories

The `repositories` command shows the snapshot repositories registered in the cluster. For example:
    
    
    GET /_cat/repositories?v

might looks like:
    
    
    id    type
    repo1   fs
    repo2   s3

We can quickly see which repositories are registered and their type.
