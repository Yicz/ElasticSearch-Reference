## Randomized testing

The code snippets you saw so far did not show any trace of randomized testing features, as they are carefully hidden under the hood. However when you are writing your own tests, you should make use of these features as well. Before starting with that, you should know, how to repeat a failed test with the same setup, how it failed. Luckily this is quite easy, as the whole mvn call is logged together with failed tests, which means you can simply copy and paste that line and run the test.

### Generating random data

The next step is to convert your test using static test data into a test using randomized test data. The kind of data you could randomize varies a lot with the functionality you are testing against. Take a look at the following examples (note, that this list could go on for pages, as a distributed system has many, many moving parts):

  * Searching for data using arbitrary UTF8 signs 
  * Changing your mapping configuration, index and field names with each run 
  * Changing your response sizes/configurable limits with each run 
  * Changing the number of shards/replicas when creating an index 



So, how can you create random data. The most important thing to know is, that you never should instantiate your own `Random` instance, but use the one provided in the `RandomizedTest`, from which all elasticsearch dependent test classes inherit from.

`getRandom()`

| 

Returns the random instance, which can recreated when calling the test with specific parameters   
  
---|---  
  
`randomBoolean()`

| 

Returns a random boolean   
  
`randomByte()`

| 

Returns a random byte   
  
`randomShort()`

| 

Returns a random short   
  
`randomInt()`

| 

Returns a random integer   
  
`randomLong()`

| 

Returns a random long   
  
`randomFloat()`

| 

Returns a random float   
  
`randomDouble()`

| 

Returns a random double   
  
`randomInt(max)`

| 

Returns a random integer between 0 and max   
  
`between()`

| 

Returns a random between the supplied range   
  
`atLeast()`

| 

Returns a random integer of at least the specified integer   
  
`atMost()`

| 

Returns a random integer of at most the specified integer   
  
`randomLocale()`

| 

Returns a random locale   
  
`randomTimeZone()`

| 

Returns a random timezone   
  
`randomFrom()`

| 

Returns a random element from a list/array   
  
In addition, there are a couple of helper methods, allowing you to create random ASCII and Unicode strings, see methods beginning with `randomAscii`, `randomUnicode`, and `randomRealisticUnicode` in the random test class. The latter one tries to create more realistic unicode string by not being arbitrary random.

If you want to debug a specific problem with a specific random seed, you can use the `@Seed` annotation to configure a specific seed for a test. If you want to run a test more than once, instead of starting the whole test suite over and over again, you can use the `@Repeat` annotation with an arbitrary value. Each iteration than gets run with a different seed.
