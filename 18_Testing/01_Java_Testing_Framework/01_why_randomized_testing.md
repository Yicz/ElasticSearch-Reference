## why randomized testing?

The key concept of randomized testing is not to use the same input values for every testcase, but still be able to reproduce it in case of a failure. This allows to test with vastly different input variables in order to make sure, that your implementation is actually independent from your provided test data.

All of the tests are run using a custom junit runner, the `RandomizedRunner` provided by the randomized-testing project. If you are interested in the implementation being used, check out the [RandomizedTesting webpage](http://labs.carrotsearch.com/randomizedtesting.html).
