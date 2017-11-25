## Number of threads

Elasticsearch uses a number of thread pools for different types of operations. It is important that it is able to create new threads whenever needed. Make sure that the number of threads that the Elasticsearch user can create is at least 2048.

This can be done by setting [`ulimit -u 2048`](setting-system-settings.html#ulimit "ulimit") as root before starting Elasticsearch, or by setting `nproc` to `2048` in [`/etc/security/limits.conf`](setting-system-settings.html#limits.conf "/etc/security/limits.conf").
