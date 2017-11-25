# Breaking changes

This div discusses the changes that you need to be aware of when migrating your application from one version of Elasticsearch to another.

As a general rule:

  * Migration between minor versions — e.g. `5.x` to `5.y` — can be performed by [upgrading one node at a time](rolling-upgrades.html "Rolling upgrades"). 
  * Migration between consecutive major versions — e.g. `2.x` to `5.x` —  requires a [full cluster restart](restart-upgrade.html "Full cluster restart upgrade"). 
  * Migration between non-consecutive major versions — e.g. `1.x` to `5.x` —  is not supported. 



See [_Upgrading Elasticsearch_](setup-upgrade.html "Upgrading Elasticsearch") for more info.
