## Rollover Index

The rollover index API rolls an alias over to a new index when the existing index is considered to be too large or too old.

The API accepts a single alias name and a list of `conditions`. The alias must point to a single index only. If the index satisfies the specified conditions then a new index is created and the alias is switched to point to the new index.
    
    
    PUT /logs-000001 ![](images/icons/callouts/1.png)
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    # Add > 1000 documents to logs-000001
    
    POST /logs_write/_rollover ![](images/icons/callouts/2.png)
    {
      "conditions": {
        "max_age":   "7d",
        "max_docs":  1000
      }
    }

![](images/icons/callouts/1.png)

| 

Creates an index called `logs-0000001` with the alias `logs_write`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

If the index pointed to by `logs_write` was created 7 or more days ago, or contains 1,000 or more documents, then the `logs-000002` index is created and the `logs_write` alias is updated to point to `logs-000002`.   
  
The above request might return the following response:
    
    
    {
      "acknowledged": true,
      "shards_acknowledged": true,
      "old_index": "logs-000001",
      "new_index": "logs-000002",
      "rolled_over": true, ![](images/icons/callouts/1.png)
      "dry_run": false, ![](images/icons/callouts/2.png)
      "conditions": { ![](images/icons/callouts/3.png)
        "[max_age: 7d]": false,
        "[max_docs: 1000]": true
      }
    }

![](images/icons/callouts/1.png)

| 

Whether the index was rolled over.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Whether the rollover was dry run.   
  
![](images/icons/callouts/3.png)

| 

The result of each condition.   
  
### Naming the new index

If the name of the existing index ends with `-` and a number — e.g. `logs-000001` — then the name of the new index will follow the same pattern, incrementing the number (`logs-000002`). The number is zero-padded with a length of 6, regardless of the old index name.

If the old name doesn’t match this pattern then you must specify the name for the new index as follows:
    
    
    POST /my_alias/_rollover/my_new_index_name
    {
      "conditions": {
        "max_age":   "7d",
        "max_docs":  1000
      }
    }

### Using date math with the rollover API

It can be useful to use [date math](date-math-index-names.html) to name the rollover index according to the date that the index rolled over, e.g. `logstash-2016.02.03`. The rollover API supports date math, but requires the index name to end with a dash followed by a number, e.g. `logstash-2016.02.03-1` which is incremented every time the index is rolled over. For instance:
    
    
    # PUT /<logs-{now/d}-1> with URI encoding:
    PUT /%3Clogs-%7Bnow%2Fd%7D-1%3E ![](images/icons/callouts/1.png)
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    PUT logs_write/log/1
    {
      "message": "a dummy log"
    }
    
    POST logs_write/_refresh
    
    # Wait for a day to pass
    
    POST /logs_write/_rollover ![](images/icons/callouts/2.png)
    {
      "conditions": {
        "max_docs":   "1"
      }
    }

![](images/icons/callouts/1.png)

| 

Creates an index named with today’s date (e.g.) `logs-2016.10.31-1`  
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Rolls over to a new index with today’s date, e.g. `logs-2016.10.31-000002` if run immediately, or `logs-2016.11.01-000002` if run after 24 hours   
  
These indices can then be referenced as described in the [date math documentation](date-math-index-names.html). For example, to search over indices created in the last three days, you could do the following:
    
    
    # GET /<logs-{now/d}-*>,<logs-{now/d-1d}-*>,<logs-{now/d-2d}-*>/_search
    GET /%3Clogs-%7Bnow%2Fd%7D-*%3E%2C%3Clogs-%7Bnow%2Fd-1d%7D-*%3E%2C%3Clogs-%7Bnow%2Fd-2d%7D-*%3E/_search

### Defining the new index

The settings, mappings, and aliases for the new index are taken from any matching [index templates](indices-templates.html). Additionally, you can specify `settings`, `mappings`, and `aliases` in the body of the request, just like the [create index](indices-create-index.html) API. Values specified in the request override any values set in matching index templates. For example, the following `rollover` request overrides the `index.number_of_shards` setting:
    
    
    PUT /logs-000001
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    POST /logs_write/_rollover
    {
      "conditions" : {
        "max_age": "7d",
        "max_docs": 1000
      },
      "settings": {
        "index.number_of_shards": 2
      }
    }

### Dry run

The rollover API supports `dry_run` mode, where request conditions can be checked without performing the actual rollover:
    
    
    PUT /logs-000001
    {
      "aliases": {
        "logs_write": {}
      }
    }
    
    POST /logs_write/_rollover?dry_run
    {
      "conditions" : {
        "max_age": "7d",
        "max_docs": 1000
      }
    }

### Wait For Active Shards

Because the rollover operation creates a new index to rollover to, the [`wait_for_active_shards`](indices-create-index.html#create-index-wait-for-active-shards) setting on index creation applies to the rollover action as well.