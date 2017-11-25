## unit tests

If your test is a well isolated unit test which doesn’t need a running elasticsearch cluster, you can use the `ESTestCase`. If you are testing lucene features, use `ESTestCase` and if you are testing concrete token streams, use the `ESTokenStreamTestCase` class. Those specific classes execute additional checks which ensure that no resources leaks are happening, after the test has run.
