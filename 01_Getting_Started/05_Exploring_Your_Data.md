## Exploring Your Data

### Sample Dataset

Now that we’ve gotten a glimpse of the basics, let’s try to work on a more realistic dataset. I’ve prepared a sample of fictitious JSON documents of customer bank account information. Each document has the following schema:
    
    
    {
        "account_number": 0,
        "balance": 16623,
        "firstname": "Bradshaw",
        "lastname": "Mckenzie",
        "age": 29,
        "gender": "F",
        "address": "244 Columbus Place",
        "employer": "Euron",
        "email": "bradshawmckenzie@euron.com",
        "city": "Hobucken",
        "state": "CO"
    }

For the curious, I generated this data from [`www.json-generator.com/`](http://www.json-generator.com/) so please ignore the actual values and semantics of the data as these are all randomly generated.

### Loading the Sample Dataset

You can download the sample dataset (accounts.json) from [here](https://github.com/elastic/elasticsearch/blob/master/docs/src/test/resources/accounts.json?raw=true). Extract it to our current directory and let’s load it into our cluster as follows:
    
    
    curl -H "Content-Type: application/json" -XPOST 'localhost:9200/bank/account/_bulk?pretty&refresh' --data-binary "@accounts.json"
    curl 'localhost:9200/_cat/indices?v'

And the response:
    
    
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   bank  l7sSYV2cQXmu6_4rJWVIww   5   1       1000            0    128.6kb        128.6kb

Which means that we just successfully bulk indexed 1000 documents into the bank index (under the account type).
