## Upgrading Elasticsearch

![Important](images/icons/important.png)

Before upgrading Elasticsearch:

  * Consult the [breaking changes](breaking-changes.html "Breaking changes") docs. 
  * Use the [Elasticsearch Migration Plugin](https://github.com/elastic/elasticsearch-migration/) to detect potential issues before upgrading. 
  * Test upgrades in a dev environment before upgrading your production cluster. 
  * Always [back up your data](modules-snapshots.html "Snapshot And Restore") before upgrading. You **cannot roll back** to an earlier version unless you have a backup of your data. 
  * If you are using custom plugins, check that a compatible version is available. 



Elasticsearch can usually be upgraded using a rolling upgrade process, resulting in no interruption of service. This div details how to perform both rolling upgrades and upgrades with full cluster restarts.

To determine whether a rolling upgrade is supported for your release, please consult this table:

Upgrade From | Upgrade To | Supported Upgrade Type  
---|---|---  
  
`1.x`

| 

`5.x`

| 

[Reindex to upgrade](reindex-upgrade.html "Reindex to upgrade")  
  
`2.x`

| 

`2.y`

| 

[Rolling upgrade](rolling-upgrades.html "Rolling upgrades") (where `y > x`)  
  
`2.x`

| 

`5.x`

| 

[Full cluster restart](restart-upgrade.html "Full cluster restart upgrade")  
  
`5.0.0 pre GA`

| 

`5.x`

| 

[Full cluster restart](restart-upgrade.html "Full cluster restart upgrade")  
  
`5.x`

| 

`5.y`

| 

[Rolling upgrade](rolling-upgrades.html "Rolling upgrades") (where `y > x`)  
  
![Important](images/icons/important.png)

### Indices created in Elasticsearch 1.x or before

Elasticsearch is able to read indices created in the **previous major version only**. For instance, Elasticsearch 5.x can use indices created in Elasticsearch 2.x, but not those created in Elasticsearch 1.x or before.

This condition also applies to indices backed up with [snapshot and restore](modules-snapshots.html "Snapshot And Restore"). If an index was originally created in 1.x, it cannot be restored into a 5.x cluster even if the snapshot was made by a 2.x cluster.

Elasticsearch 5.x nodes will fail to start in the presence of too old indices.

See [Reindex to upgrade](reindex-upgrade.html "Reindex to upgrade") for more information about how to upgrade old indices.
