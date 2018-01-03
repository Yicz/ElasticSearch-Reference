## 查看正在执行的任务 cat pending tasks

`pending_tasks`以便利的表格格式提供与[`/_cluster/pending_tasks`](cluster-pending.html)API相同的信息。 例如：

    
    
    GET /_cat/pending_tasks?v

响应:
    
    
    insertOrder timeInQueue priority source
           1685       855ms HIGH     update-mapping [foo][t]
           1686       843ms HIGH     update-mapping [foo][t]
           1693       753ms HIGH     refresh-mapping [foo][[t]]
           1688       816ms HIGH     update-mapping [foo][t]
           1689       802ms HIGH     update-mapping [foo][t]
           1690       787ms HIGH     update-mapping [foo][t]
           1691       773ms HIGH     update-mapping [foo][t]
