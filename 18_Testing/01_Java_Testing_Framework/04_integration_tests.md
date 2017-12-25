## integration tests

These kind of tests require firing up a whole cluster of nodes, before the tests can actually be run. Compared to unit tests they are obviously way more time consuming, but the test infrastructure tries to minimize the time cost by only restarting the whole cluster, if this is configured explicitly.

The class your tests have to inherit from is `ESIntegTestCase`. By inheriting from this class, you will no longer need to start elasticsearch nodes manually in your test, although you might need to ensure that at least a certain number of nodes are up. The integration test behaviour can be configured heavily by specifying different system properties on test runs. See the `TESTING.asciidoc` documentation in the [source repository](https://github.com/elastic/elasticsearch/blob/master/TESTING.asciidoc) for more information.

### number of shards

The number of shards used for indices created during integration tests is randomized between `1` and `10` unless overwritten upon index creation via index settings. The rule of thumb is not to specify the number of shards unless needed, so that each test will use a different one all the time. Alternatively you can override the `numberOfShards()` method. The same applies to the `numberOfReplicas()` method.

### generic helper methods

There are a couple of helper methods in `ESIntegTestCase`, which will make your tests shorter and more concise.

`refresh()`

| 

Refreshes all indices in a cluster   
  
---|---  
  
`ensureGreen()`

| 

Ensures a green health cluster state, waiting for relocations. Waits the default timeout of 30 seconds before failing.   
  
`ensureYellow()`

| 

Ensures a yellow health cluster state, also waits for 30 seconds before failing.   
  
`createIndex(name)`

| 

Creates an index with the specified name   
  
`flush()`

| 

Flushes all indices in a cluster   
  
`flushAndRefresh()`

| 

Combines `flush()` and `refresh()` calls   
  
`forceMerge()`

| 

Waits for all relocations and force merges all indices in the cluster to one segment.   
  
`indexExists(name)`

| 

Checks if given index exists   
  
`admin()`

| 

Returns an `AdminClient` for administrative tasks   
  
`clusterService()`

| 

Returns the cluster service java class   
  
`cluster()`

| 

Returns the test cluster class, which is explained in the next paragraphs   
  
### test cluster methods

The `InternalTestCluster` class is the heart of the cluster functionality in a randomized test and allows you to configure a specific setting or replay certain types of outages to check, how your custom code reacts.

`ensureAtLeastNumNodes(n)`

| 

Ensure at least the specified number of nodes is running in the cluster   
  
---|---  
  
`ensureAtMostNumNodes(n)`

| 

Ensure at most the specified number of nodes is running in the cluster   
  
`getInstance()`

| 

Get a guice instantiated instance of a class from a random node   
  
`getInstanceFromNode()`

| 

Get a guice instantiated instance of a class from a specified node   
  
`stopRandomNode()`

| 

Stop a random node in your cluster to mimic an outage   
  
`stopCurrentMasterNode()`

| 

Stop the current master node to force a new election   
  
`stopRandomNonMaster()`

| 

Stop a random non master node to mimic an outage   
  
`buildNode()`

| 

Create a new elasticsearch node   
  
`startNode(settings)`

| 

Create and start a new elasticsearch node   
  
### Changing node settings

If you want to ensure a certain configuration for the nodes, which are started as part of the `EsIntegTestCase`, you can override the `nodeSettings()` method
    
    
    public class Mytests extends ESIntegTestCase {
    
      @Override
      protected Settings nodeSettings(int nodeOrdinal) {
          return Settings.builder().put(super.nodeSettings(nodeOrdinal))
                 .put("node.mode",)
                 .build();
      }
    
    }

### Accessing clients

In order to execute any actions, you have to use a client. You can use the `ESIntegTestCase.client()` method to get back a random client. This client can be a `TransportClient` or a `NodeClient` \- and usually you do not need to care as long as the action gets executed. There are several more methods for client selection inside of the `InternalTestCluster` class, which can be accessed using the `ESIntegTestCase.internalCluster()` method.

`iterator()`

| 

An iterator over all available clients   
  
---|---  
  
`masterClient()`

| 

Returns a client which is connected to the master node   
  
`nonMasterClient()`

| 

Returns a client which is not connected to the master node   
  
`clientNodeClient()`

| 

Returns a client, which is running on a client node   
  
`client(String nodeName)`

| 

Returns a client to a given node   
  
`smartClient()`

| 

Returns a smart client   
  
### Scoping

By default the tests are run with unique cluster per test suite. Of course all indices and templates are deleted between each test. However, sometimes you need to start a new cluster for each test - for example, if you load a certain plugin, but you do not want to load it for every test.

You can use the `@ClusterScope` annotation at class level to configure this behaviour
    
    
    @ClusterScope(scope=TEST, numDataNodes=1)
    public class CustomSuggesterSearchTests extends ESIntegTestCase {
      // ... tests go here
    }

The above sample configures the test to use a new cluster for each test method. The default scope is `SUITE` (one cluster for all test methods in the test). The `numDataNodes` settings allows you to only start a certain number of data nodes, which can speed up test execution, as starting a new node is a costly and time consuming operation and might not be needed for this test.

By default, the testing infrastructure will randomly start dedicated master nodes. If you want to disable dedicated masters you can set `supportsDedicatedMasters=false` in a similar fashion to the `numDataNodes` setting. If dedicated master nodes are not used, data nodes will be allowed to become masters as well.

### Changing plugins via configuration

As elasticsearch is using JUnit 4, using the `@Before` and `@After` annotations is not a problem. However you should keep in mind, that this does not have any effect in your cluster setup, as the cluster is already up and running when those methods are run. So in case you want to configure settings - like loading a plugin on node startup - before the node is actually running, you should overwrite the `nodePlugins()` method from the `ESIntegTestCase` class and return the plugin classes each node should load.
    
    
    @Override
    protected Collection<Class<? extends Plugin>> nodePlugins() {
      return Arrays.asList(CustomSuggesterPlugin.class);
    }
