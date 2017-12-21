## Assertions

As many elasticsearch tests are checking for a similar output, like the amount of hits or the first hit or special highlighting, a couple of predefined assertions have been created. Those have been put into the `ElasticsearchAssertions` class. There is also a specific geo assertions in `ElasticsearchGeoAssertions`.

`assertHitCount()`

| 

Checks hit count of a search or count request   
  
---|---  
  
`assertAcked()`

| 

Ensure the a request has been acknowledged by the master   
  
`assertSearchHits()`

| 

Asserts a search response contains specific ids   
  
`assertMatchCount()`

| 

Asserts a matching count from a percolation response   
  
`assertFirstHit()`

| 

Asserts the first hit hits the specified matcher   
  
`assertSecondHit()`

| 

Asserts the second hit hits the specified matcher   
  
`assertThirdHit()`

| 

Asserts the third hits hits the specified matcher   
  
`assertSearchHit()`

| 

Assert a certain element in a search response hits the specified matcher   
  
`assertNoFailures()`

| 

Asserts that no shard failures have occurred in the response   
  
`assertFailures()`

| 

Asserts that shard failures have happened during a search request   
  
`assertHighlight()`

| 

Assert specific highlights matched   
  
`assertSuggestion()`

| 

Assert for specific suggestions   
  
`assertSuggestionSize()`

| 

Assert for specific suggestion count   
  
`assertThrows()`

| 

Assert a specific exception has been thrown   
  
Common matchers

`hasId()`

| 

Matcher to check for a search hit id   
  
---|---  
  
`hasType()`

| 

Matcher to check for a search hit type   
  
`hasIndex()`

| 

Matcher to check for a search hit index   
  
`hasScore()`

| 

Matcher to check for a certain score of a hit   
  
`hasStatus()`

| 

Matcher to check for a certain `RestStatus` of a response   
  
Usually, you would combine assertions and matchers in your test like this
    
    
    SearchResponse searchResponse = client().prepareSearch() ...;
    assertHitCount(searchResponse, 4);
    assertFirstHit(searchResponse, hasId("4"));
    assertSearchHits(searchResponse, "1", "2", "3", "4");
