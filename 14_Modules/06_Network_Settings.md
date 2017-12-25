## Network Settings

Elasticsearch binds to localhost only by default. This is sufficient for you to run a local development server (or even a development cluster, if you start multiple nodes on the same machine), but you will need to configure some [basic network settings](modules-network.html#common-network-settings) in order to run a real production cluster across multiple servers.

![Warning](images/icons/warning.png)

### Be careful with the network configuration!

Never expose an unprotected node to the public internet.

### Commonly Used Network Settings

`network.host`
    

The node will bind to this hostname or IP address and _publish_ (advertise) this host to other nodes in the cluster. Accepts an IP address, hostname, a [special value](modules-network.html#network-interface-values), or an array of any combination of these. 

Defaults to `_local_`.

`discovery.zen.ping.unicast.hosts`
    

In order to join a cluster, a node needs to know the hostname or IP address of at least some of the other nodes in the cluster. This setting provides the initial list of other nodes that this node will try to contact. Accepts IP addresses or hostnames. If a hostname lookup resolves to multiple IP addresses then each IP address will be used for discovery. [Round robin DNS](https://en.wikipedia.org/wiki/Round-robin_DNS) — returning a different IP from a list on each lookup — can be used for discovery; non- existent IP addresses will throw exceptions and cause another DNS lookup on the next round of pinging (subject to JVM DNS caching). 

Defaults to `["127.0.0.1", "[::1]"]`.

`http.port`
    

Port to bind to for incoming HTTP requests. Accepts a single value or a range. If a range is specified, the node will bind to the first available port in the range. 

Defaults to `9200-9300`.

`transport.tcp.port`
    

Port to bind for communication between nodes. Accepts a single value or a range. If a range is specified, the node will bind to the first available port in the range. 

Defaults to `9300-9400`.

### Special values for `network.host`

The following special values may be passed to `network.host`:

`_[networkInterface]_`

| 

Addresses of a network interface, for example `_en0_`.   
  
---|---  
  
`_local_`

| 

Any loopback addresses on the system, for example `127.0.0.1`.   
  
`_site_`

| 

Any site-local addresses on the system, for example `192.168.0.1`.   
  
`_global_`

| 

Any globally-scoped addresses on the system, for example `8.8.8.8`.   
  
#### IPv4 vs IPv6

These special values will work over both IPv4 and IPv6 by default, but you can also limit this with the use of `:ipv4` of `:ipv6` specifiers. For example, `_en0:ipv4_` would only bind to the IPv4 addresses of interface `en0`.

![Tip](images/icons/tip.png)

### Discovery in the cloud

More special settings are available when running in the cloud with either the [EC2 discovery plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/discovery-ec2-discovery.html#discovery-ec2-network-host) or the [Google Compute Engine discovery plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/discovery-gce-network-host.html#discovery-gce-network-host) installed.

### Advanced network settings

The `network.host` setting explained in [Commonly used network settings](modules-network.html#common-network-settings) is a shortcut which sets the _bind host_ and the _publish host_ at the same time. In advanced used cases, such as when running behind a proxy server, you may need to set these settings to different values:

`network.bind_host`
     This specifies which network interface(s) a node should bind to in order to listen for incoming requests. A node can bind to multiple interfaces, e.g. two network cards, or a site-local address and a local address. Defaults to `network.host`. 
`network.publish_host`
     The publish host is the single interface that the node advertises to other nodes in the cluster, so that those nodes can connect to it. Currently an Elasticsearch node may be bound to multiple addresses, but only publishes one. If not specified, this defaults to the “best” address from `network.host`, sorted by IPv4/IPv6 stack preference, then by reachability. If you set a `network.host` that results in multiple bind addresses yet rely on a specific address for node-to-node communication, you should explicitly set `network.publish_host`. 

Both of the above settings can be configured just like `network.host` — they accept IP addresses, host names, and [special values](modules-network.html#network-interface-values).

### Advanced TCP Settings

Any component that uses TCP (like the [HTTP](modules-http.html) and [Transport](modules-transport.html) modules) share the following settings:

`network.tcp.no_delay`

| 

Enable or disable the [TCP no delay](https://en.wikipedia.org/wiki/Nagle%27s_algorithm) setting. Defaults to `true`.   
  
---|---  
  
`network.tcp.keep_alive`

| 

Enable or disable [TCP keep alive](https://en.wikipedia.org/wiki/Keepalive). Defaults to `true`.   
  
`network.tcp.reuse_address`

| 

Should an address be reused or not. Defaults to `true` on non-windows machines.   
  
`network.tcp.send_buffer_size`

| 

The size of the TCP send buffer (specified with [size units](common-options.html#size-units)). By default not explicitly set.   
  
`network.tcp.receive_buffer_size`

| 

The size of the TCP receive buffer (specified with [size units](common-options.html#size-units)). By default not explicitly set.   
  
### Transport and HTTP protocols

An Elasticsearch node exposes two network protocols which inherit the above settings, but may be further configured independently:

TCP Transport 
     Used for communication between nodes in the cluster, by the Java [Transport client](https://www.elastic.co/guide/en/elasticsearch/client/java-api/5.4/transport-client.html) and by the [Tribe node](modules-tribe.html). See the [Transport module](modules-transport.html) for more information. 
HTTP 
     Exposes the JSON-over-HTTP interface used by all clients other than the Java clients. See the [HTTP module](modules-http.html) for more information. 
