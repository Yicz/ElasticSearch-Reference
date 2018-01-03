## 查询统计数据 cat count

`count`可以快速访问整个群集或单个索引的文档数量。
    
    
    GET /_cat/count?v

响应内容:
    
    
    epoch      timestamp count
    1475868259 15:24:19  121

或者为指定单个索引：
    
    
    GET /_cat/count/twitter?v
    
    epoch      timestamp count
    1475868259 15:24:20  120

![Note](/images/icons/note.png)文档计数表示活动文档的数量，不包括合并过程中尚未清除的已删除文档。