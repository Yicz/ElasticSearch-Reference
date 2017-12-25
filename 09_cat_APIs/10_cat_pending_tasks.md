## cat pending tasks

`pending_tasks` provides the same information as the [`/_cluster/pending_tasks`](cluster-pending.html) API in a convenient tabular format. For example:
    
    
    GET /_cat/pending_tasks?v

Might look like:
    
    
    insertOrder timeInQueue priority source
           1685       855ms HIGH     update-mapping [foo][t]
           1686       843ms HIGH     update-mapping [foo][t]
           1693       753ms HIGH     refresh-mapping [foo][[t]]
           1688       816ms HIGH     update-mapping [foo][t]
           1689       802ms HIGH     update-mapping [foo][t]
           1690       787ms HIGH     update-mapping [foo][t]
           1691       773ms HIGH     update-mapping [foo][t]
