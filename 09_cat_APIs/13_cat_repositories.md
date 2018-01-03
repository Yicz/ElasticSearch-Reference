##  cat repositories

`repositories`命令显示集群中注册的快照库。 例如：    
    
    GET /_cat/repositories?v

响应:
    
    
    id    type
    repo1   fs
    repo2   s3

我们可以快速查看哪些存储库已注册，以及它们的类型。