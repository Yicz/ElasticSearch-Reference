## Using the elasticsearch test classes

First, you need to include the testing dependency in your project, along with the elasticsearch dependency you have already added. If you use maven and its `pom.xml` file, it looks like this
    
    
    <dependencies>
      <dependency>
        <groupId>org.apache.lucene</groupId>
        <artifactId>lucene-test-framework</artifactId>
        <version>${lucene.version}</version>
        <scope>test</scope>
      </dependency>
      <dependency>
        <groupId>org.elasticsearch.test</groupId>
        <artifactId>framework</artifactId>
        <version>${elasticsearch.version}</version>
        <scope>test</scope>
      </dependency>
    </dependencies>

Replace the elasticsearch version and the lucene version with the corresponding elasticsearch version and its accompanying lucene release.

We provide a few classes that you can inherit from in your own test classes which provide:

  * pre-defined loggers 
  * randomized testing infrastructure 
  * a number of helper methods 


