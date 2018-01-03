## 刷新 Refresh

刷新API允许显式地刷新一个或多个索引，使得自从上次可用于搜索的刷新以来执行的所有操作。 （近）实时能力取决于所使用的索引引擎。 例如，内部的刷新需要被调用，但是默认情况下定期刷新刷新。
    
    
    POST /twitter/_refresh

### 操作多索引 Multi Index

刷新API可以在一次请求中设置多个索引或者全部(`_all`)索引 
    
    POST /kimchy,elasticsearch/_refresh
    
    POST /_refresh
