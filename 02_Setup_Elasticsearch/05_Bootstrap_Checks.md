## Bootstrap Checks

Collectively, we have a lot of experience with users suffering unexpected issues because they have not configured [important settings](important-settings.html "Important Elasticsearch configuration"). In previous versions of Elasticsearch, misconfiguration of some of these settings were logged as warnings. Understandably, users sometimes miss these log messages. To ensure that these settings receive the attention that they deserve, Elasticsearch has bootstrap checks upon startup.

These bootstrap checks inspect a variety of Elasticsearch and system settings and compare them to values that are safe for the operation of Elasticsearch. If Elasticsearch is in development mode, any bootstrap checks that fail appear as warnings in the Elasticsearch log. If Elasticsearch is in production mode, any bootstrap checks that fail will cause Elasticsearch to refuse to start.

There are some bootstrap checks that are always enforced to prevent Elasticsearch from running with incompatible settings. These checks are documented individually.

### Development vs. production mode

By default, Elasticsearch binds to `localhost` for [HTTP](modules-http.html "HTTP") and [transport (internal)](modules-transport.html "Transport") communication. This is fine for downloading and playing with Elasticsearch, and everyday development but it’s useless for production systems. To join a cluster, an Elasticsearch node must be reachable via transport communication. To join a cluster over an external network interface, a node must bind transport to an external interface and not be using [single-node discovery](bootstrap-checks.html#single-node-discovery "Single-node discoveryedit"). Thus, we consider an Elasticsearch node to be in development mode if it can not form a cluster with another machine over an external network interface, and is otherwise in production mode if it can join a cluster over an external interface.

Note that HTTP and transport can be configured independently via [`http.host`](modules-http.html "HTTP") and [`transport.host`](modules-transport.html "Transport"); this can be useful for configuring a single node to be reachable via HTTP for testing purposes without triggering production mode.

### Single-node discovery

We recognize that some users need to bind transport to an external interface for testing their usage of the transport client. For this situation, we provide the discovery type `single-node` (configure it by setting `discovery.type` to `single-node`); in this situation, a node will elect itself master and will not join a cluster with any other node.

### Forcing the bootstrap checks

If you are running a single node in production, it is possible to evade the bootstrap checks (either by not binding transport to an external interface, or by binding transport to an external interface and setting the discovery type to `single-node`). For this situation, you can force execution of the bootstrap checks by setting the system property `es.enforce.bootstrap.checks` to `true` (set this in [Setting JVM options](setting-system-settings.html#jvm-options "Setting JVM options"), or by adding `-Des.enforce.bootstrap.checks=true` to the environment variable `ES_JAVA_OPTS`). We strongly encourage you to do this if you are in this specific situation. This system property can be used to force execution of the bootstrap checks independent of the node configuration.
