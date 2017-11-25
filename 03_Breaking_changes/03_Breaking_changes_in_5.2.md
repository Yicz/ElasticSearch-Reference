## Breaking changes in 5.2

### Packaging changes

#### System call bootstrap check

Elasticsearch has attempted to install a system call filter since version 2.1.0. On some systems, installing this system call filter could fail. Previous versions of Elasticsearch would log a warning, but would otherwise continue executing potentially leaving the end-user unaware of this situation. Starting in Elasticsearch 5.2.0, there is now a [bootstrap check](bootstrap-checks.html "Bootstrap Checks") for success of installing the system call filter. If you encounter an issue starting Elasticsearch due to this bootstrap check, you need to either fix your configuration so that the system call filter can be installed, or **at your own risk** disable the [system call filter check](system-call-filter-check.html "System call filter check").

### Settings changes

#### System call filter setting

Elasticsearch has attempted to install a system call filter since version 2.1.0. These are enabled by default and could be disabled via `bootstrap.seccomp`. The naming of this setting is poor since seccomp is specific to Linux but Elasticsearch attempts to install a system call filter on various operating systems. Starting in Elasticsearch 5.2.0, this setting has been renamed to `bootstrap.system_call_filter`. The previous setting is still support but will be removed in Elasticsearch 6.0.0.

### Java API changes

#### Removed some of the `source` overrides

In an effort to clean up internals we’ve removed the following methods:

  * `PutRepositoryRequest#source(XContentBuilder)`
  * `PutRepositoryRequest#source(String)`
  * `PutRepositoryRequest#source(byte[])`
  * `PutRepositoryRequest#source(byte[], int, int)`
  * `PutRepositoryRequest#source(BytesReference)`
  * `CreateSnapshotRequest#source(XContentBuilder)`
  * `CreateSnapshotRequest#source(String)`
  * `CreateSnapshotRequest#source(byte[])`
  * `CreateSnapshotRequest#source(byte[], int, int)`
  * `CreateSnapshotRequest#source(BytesReference)`
  * `RestoreSnapshotRequest#source(XContentBuilder)`
  * `RestoreSnapshotRequest#source(String)`
  * `RestoreSnapshotRequest#source(byte[])`
  * `RestoreSnapshotRequest#source(byte[], int, int)`
  * `RestoreSnapshotRequest#source(BytesReference)`
  * `RolloverRequest#source(BytesReference)`
  * `ShrinkRequest#source(BytesReference)`
  * `UpdateRequest#fromXContent(BytesReference)`



Please use the non-`source` methods instead (like `settings` and `type`).

#### Timestamp meta-data field type for ingest processors has changed

The type of the "timestamp" meta-data field for ingest processors has changed from `java.lang.String` to `java.util.Date`.
