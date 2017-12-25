## Remote Cluster Info

The cluster remote info API allows to retrieve all of the configured remote cluster information.
    
    
    GET /_remote/info

This command returns returns connection and endpoint information keyed by the configured remote cluster alias.

`seeds`
     The configured initial seed transport addresses of the remote cluster. 
`http_addresses`
     The published http addresses of all connected remote nodes. 
`connected`
     True if there is at least one connection to the remote cluster. 
`num_nodes_connected`
     The number of connected nodes in the remote cluster. 
`max_connection_per_cluster`
     The maximum number of connections maintained for the remote cluster. 
`initial_connect_timeout`
     The initial connect timeout for remote cluster connections. 