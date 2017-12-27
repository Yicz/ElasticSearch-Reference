## Thai Tokenizer

The `thai` tokenizer segments Thai text into words, using the Thai segmentation algorithm included with Java. Text in other languages in general will be treated the same as the [`standard` tokenizer](analysis-standard-tokenizer.html).

![Warning](/images/icons/warning.png)

This tokenizer may not be supported by all JREs. It is known to work with Sun/Oracle and OpenJDK. If your application needs to be fully portable, consider using the [ICU Tokenizer](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/analysis-icu-tokenizer.html) instead.

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "thai",
      "text": "การที่ได้ต้องแสดงว่างานดี"
    }

The above sentence would produce the following terms:
    
    
    [ การ, ที่, ได้, ต้อง, แสดง, ว่า, งาน, ดี ]

### Configuration

The `thai` tokenizer is not configurable.
