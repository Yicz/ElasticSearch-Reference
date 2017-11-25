## Language Analyzers

A set of analyzers aimed at analyzing specific language text. The following types are supported: [`arabic`](analysis-lang-analyzer.html#arabic-analyzer "arabic analyzer"), [`armenian`](analysis-lang-analyzer.html#armenian-analyzer "armenian analyzer"), [`basque`](analysis-lang-analyzer.html#basque-analyzer "basque analyzer"), [`brazilian`](analysis-lang-analyzer.html#brazilian-analyzer "brazilian analyzer"), [`bulgarian`](analysis-lang-analyzer.html#bulgarian-analyzer "bulgarian analyzer"), [`catalan`](analysis-lang-analyzer.html#catalan-analyzer "catalan analyzer"), [`cjk`](analysis-lang-analyzer.html#cjk-analyzer "cjk analyzer"), [`czech`](analysis-lang-analyzer.html#czech-analyzer "czech analyzer"), [`danish`](analysis-lang-analyzer.html#danish-analyzer "danish analyzer"), [`dutch`](analysis-lang-analyzer.html#dutch-analyzer "dutch analyzer"), [`english`](analysis-lang-analyzer.html#english-analyzer "english analyzer"), [`finnish`](analysis-lang-analyzer.html#finnish-analyzer "finnish analyzer"), [`french`](analysis-lang-analyzer.html#french-analyzer "french analyzer"), [`galician`](analysis-lang-analyzer.html#galician-analyzer "galician analyzer"), [`german`](analysis-lang-analyzer.html#german-analyzer "german analyzer"), [`greek`](analysis-lang-analyzer.html#greek-analyzer "greek analyzer"), [`hindi`](analysis-lang-analyzer.html#hindi-analyzer "hindi analyzer"), [`hungarian`](analysis-lang-analyzer.html#hungarian-analyzer "hungarian analyzer"), [`indonesian`](analysis-lang-analyzer.html#indonesian-analyzer "indonesian analyzer"), [`irish`](analysis-lang-analyzer.html#irish-analyzer "irish analyzer"), [`italian`](analysis-lang-analyzer.html#italian-analyzer "italian analyzer"), [`latvian`](analysis-lang-analyzer.html#latvian-analyzer "latvian analyzer"), [`lithuanian`](analysis-lang-analyzer.html#lithuanian-analyzer "lithuanian analyzer"), [`norwegian`](analysis-lang-analyzer.html#norwegian-analyzer "norwegian analyzer"), [`persian`](analysis-lang-analyzer.html#persian-analyzer "persian analyzer"), [`portuguese`](analysis-lang-analyzer.html#portuguese-analyzer "portuguese analyzer"), [`romanian`](analysis-lang-analyzer.html#romanian-analyzer "romanian analyzer"), [`russian`](analysis-lang-analyzer.html#russian-analyzer "russian analyzer"), [`sorani`](analysis-lang-analyzer.html#sorani-analyzer "sorani analyzer"), [`spanish`](analysis-lang-analyzer.html#spanish-analyzer "spanish analyzer"), [`swedish`](analysis-lang-analyzer.html#swedish-analyzer "swedish analyzer"), [`turkish`](analysis-lang-analyzer.html#turkish-analyzer "turkish analyzer"), [`thai`](analysis-lang-analyzer.html#thai-analyzer "thai analyzer").

### Configuring language analyzers

#### Stopwords

All analyzers support setting custom `stopwords` either internally in the config, or by using an external stopwords file by setting `stopwords_path`. Check [Stop Analyzer](analysis-stop-analyzer.html "Stop Analyzer") for more details.

#### Excluding words from stemming

The `stem_exclusion` parameter allows you to specify an array of lowercase words that should not be stemmed. Internally, this functionality is implemented by adding the [`keyword_marker` token filter](analysis-keyword-marker-tokenfilter.html "Keyword Marker Token Filter") with the `keywords` set to the value of the `stem_exclusion` parameter.

The following analyzers support setting custom `stem_exclusion` list: `arabic`, `armenian`, `basque`, `bulgarian`, `catalan`, `czech`, `dutch`, `english`, `finnish`, `french`, `galician`, `german`, `hindi`, `hungarian`, `indonesian`, `irish`, `italian`, `latvian`, `lithuanian`, `norwegian`, `portuguese`, `romanian`, `russian`, `sorani`, `spanish`, `swedish`, `turkish`.

### Reimplementing language analyzers

The built-in language analyzers can be reimplemented as `custom` analyzers (as described below) in order to customize their behaviour.

![Note](images/icons/note.png)

If you do not intend to exclude words from being stemmed (the equivalent of the `stem_exclusion` parameter above), then you should remove the `keyword_marker` token filter from the custom analyzer configuration.

#### `arabic` analyzer

The `arabic` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /arabic_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "arabic_stop": {
              "type":       "stop",
              "stopwords":  "_arabic_" ![](images/icons/callouts/1.png)
            },
            "arabic_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["مثال"] ![](images/icons/callouts/2.png)
            },
            "arabic_stemmer": {
              "type":       "stemmer",
              "language":   "arabic"
            }
          },
          "analyzer": {
            "arabic": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "arabic_stop",
                "arabic_normalization",
                "arabic_keywords",
                "arabic_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `armenian` analyzer

The `armenian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /armenian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "armenian_stop": {
              "type":       "stop",
              "stopwords":  "_armenian_" ![](images/icons/callouts/1.png)
            },
            "armenian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["օրինակ"] ![](images/icons/callouts/2.png)
            },
            "armenian_stemmer": {
              "type":       "stemmer",
              "language":   "armenian"
            }
          },
          "analyzer": {
            "armenian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "armenian_stop",
                "armenian_keywords",
                "armenian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `basque` analyzer

The `basque` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /armenian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "basque_stop": {
              "type":       "stop",
              "stopwords":  "_basque_" ![](images/icons/callouts/1.png)
            },
            "basque_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["Adibidez"] ![](images/icons/callouts/2.png)
            },
            "basque_stemmer": {
              "type":       "stemmer",
              "language":   "basque"
            }
          },
          "analyzer": {
            "basque": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "basque_stop",
                "basque_keywords",
                "basque_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `brazilian` analyzer

The `brazilian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /brazilian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "brazilian_stop": {
              "type":       "stop",
              "stopwords":  "_brazilian_" ![](images/icons/callouts/1.png)
            },
            "brazilian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplo"] ![](images/icons/callouts/2.png)
            },
            "brazilian_stemmer": {
              "type":       "stemmer",
              "language":   "brazilian"
            }
          },
          "analyzer": {
            "brazilian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "brazilian_stop",
                "brazilian_keywords",
                "brazilian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `bulgarian` analyzer

The `bulgarian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /bulgarian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "bulgarian_stop": {
              "type":       "stop",
              "stopwords":  "_bulgarian_" ![](images/icons/callouts/1.png)
            },
            "bulgarian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["пример"] ![](images/icons/callouts/2.png)
            },
            "bulgarian_stemmer": {
              "type":       "stemmer",
              "language":   "bulgarian"
            }
          },
          "analyzer": {
            "bulgarian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "bulgarian_stop",
                "bulgarian_keywords",
                "bulgarian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `catalan` analyzer

The `catalan` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /catalan_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "catalan_elision": {
              "type":       "elision",
              "articles":   [ "d", "l", "m", "n", "s", "t"]
            },
            "catalan_stop": {
              "type":       "stop",
              "stopwords":  "_catalan_" ![](images/icons/callouts/1.png)
            },
            "catalan_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemple"] ![](images/icons/callouts/2.png)
            },
            "catalan_stemmer": {
              "type":       "stemmer",
              "language":   "catalan"
            }
          },
          "analyzer": {
            "catalan": {
              "tokenizer":  "standard",
              "filter": [
                "catalan_elision",
                "lowercase",
                "catalan_stop",
                "catalan_keywords",
                "catalan_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `cjk` analyzer

The `cjk` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /cjk_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "english_stop": {
              "type":       "stop",
              "stopwords":  "_english_" ![](images/icons/callouts/1.png)
            }
          },
          "analyzer": {
            "cjk": {
              "tokenizer":  "standard",
              "filter": [
                "cjk_width",
                "lowercase",
                "cjk_bigram",
                "english_stop"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
#### `czech` analyzer

The `czech` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /czech_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "czech_stop": {
              "type":       "stop",
              "stopwords":  "_czech_" ![](images/icons/callouts/1.png)
            },
            "czech_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["příklad"] ![](images/icons/callouts/2.png)
            },
            "czech_stemmer": {
              "type":       "stemmer",
              "language":   "czech"
            }
          },
          "analyzer": {
            "czech": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "czech_stop",
                "czech_keywords",
                "czech_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `danish` analyzer

The `danish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /danish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "danish_stop": {
              "type":       "stop",
              "stopwords":  "_danish_" ![](images/icons/callouts/1.png)
            },
            "danish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["eksempel"] ![](images/icons/callouts/2.png)
            },
            "danish_stemmer": {
              "type":       "stemmer",
              "language":   "danish"
            }
          },
          "analyzer": {
            "danish": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "danish_stop",
                "danish_keywords",
                "danish_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `dutch` analyzer

The `dutch` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /detch_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "dutch_stop": {
              "type":       "stop",
              "stopwords":  "_dutch_" ![](images/icons/callouts/1.png)
            },
            "dutch_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["voorbeeld"] ![](images/icons/callouts/2.png)
            },
            "dutch_stemmer": {
              "type":       "stemmer",
              "language":   "dutch"
            },
            "dutch_override": {
              "type":       "stemmer_override",
              "rules": [
                "fiets=>fiets",
                "bromfiets=>bromfiets",
                "ei=>eier",
                "kind=>kinder"
              ]
            }
          },
          "analyzer": {
            "dutch": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "dutch_stop",
                "dutch_keywords",
                "dutch_override",
                "dutch_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `english` analyzer

The `english` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /english_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "english_stop": {
              "type":       "stop",
              "stopwords":  "_english_" ![](images/icons/callouts/1.png)
            },
            "english_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["example"] ![](images/icons/callouts/2.png)
            },
            "english_stemmer": {
              "type":       "stemmer",
              "language":   "english"
            },
            "english_possessive_stemmer": {
              "type":       "stemmer",
              "language":   "possessive_english"
            }
          },
          "analyzer": {
            "english": {
              "tokenizer":  "standard",
              "filter": [
                "english_possessive_stemmer",
                "lowercase",
                "english_stop",
                "english_keywords",
                "english_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `finnish` analyzer

The `finnish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /finnish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "finnish_stop": {
              "type":       "stop",
              "stopwords":  "_finnish_" ![](images/icons/callouts/1.png)
            },
            "finnish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["esimerkki"] ![](images/icons/callouts/2.png)
            },
            "finnish_stemmer": {
              "type":       "stemmer",
              "language":   "finnish"
            }
          },
          "analyzer": {
            "finnish": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "finnish_stop",
                "finnish_keywords",
                "finnish_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `french` analyzer

The `french` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /french_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "french_elision": {
              "type":         "elision",
              "articles_case": true,
              "articles": [
                  "l", "m", "t", "qu", "n", "s",
                  "j", "d", "c", "jusqu", "quoiqu",
                  "lorsqu", "puisqu"
                ]
            },
            "french_stop": {
              "type":       "stop",
              "stopwords":  "_french_" ![](images/icons/callouts/1.png)
            },
            "french_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["Exemple"] ![](images/icons/callouts/2.png)
            },
            "french_stemmer": {
              "type":       "stemmer",
              "language":   "light_french"
            }
          },
          "analyzer": {
            "french": {
              "tokenizer":  "standard",
              "filter": [
                "french_elision",
                "lowercase",
                "french_stop",
                "french_keywords",
                "french_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `galician` analyzer

The `galician` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /galician_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "galician_stop": {
              "type":       "stop",
              "stopwords":  "_galician_" ![](images/icons/callouts/1.png)
            },
            "galician_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplo"] ![](images/icons/callouts/2.png)
            },
            "galician_stemmer": {
              "type":       "stemmer",
              "language":   "galician"
            }
          },
          "analyzer": {
            "galician": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "galician_stop",
                "galician_keywords",
                "galician_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `german` analyzer

The `german` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /german_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "german_stop": {
              "type":       "stop",
              "stopwords":  "_german_" ![](images/icons/callouts/1.png)
            },
            "german_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["Beispiel"] ![](images/icons/callouts/2.png)
            },
            "german_stemmer": {
              "type":       "stemmer",
              "language":   "light_german"
            }
          },
          "analyzer": {
            "german": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "german_stop",
                "german_keywords",
                "german_normalization",
                "german_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `greek` analyzer

The `greek` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /greek_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "greek_stop": {
              "type":       "stop",
              "stopwords":  "_greek_" ![](images/icons/callouts/1.png)
            },
            "greek_lowercase": {
              "type":       "lowercase",
              "language":   "greek"
            },
            "greek_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["παράδειγμα"] ![](images/icons/callouts/2.png)
            },
            "greek_stemmer": {
              "type":       "stemmer",
              "language":   "greek"
            }
          },
          "analyzer": {
            "greek": {
              "tokenizer":  "standard",
              "filter": [
                "greek_lowercase",
                "greek_stop",
                "greek_keywords",
                "greek_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `hindi` analyzer

The `hindi` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /hindi_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "hindi_stop": {
              "type":       "stop",
              "stopwords":  "_hindi_" ![](images/icons/callouts/1.png)
            },
            "hindi_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["उदाहरण"] ![](images/icons/callouts/2.png)
            },
            "hindi_stemmer": {
              "type":       "stemmer",
              "language":   "hindi"
            }
          },
          "analyzer": {
            "hindi": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "indic_normalization",
                "hindi_normalization",
                "hindi_stop",
                "hindi_keywords",
                "hindi_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `hungarian` analyzer

The `hungarian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /hungarian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "hungarian_stop": {
              "type":       "stop",
              "stopwords":  "_hungarian_" ![](images/icons/callouts/1.png)
            },
            "hungarian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["példa"] ![](images/icons/callouts/2.png)
            },
            "hungarian_stemmer": {
              "type":       "stemmer",
              "language":   "hungarian"
            }
          },
          "analyzer": {
            "hungarian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "hungarian_stop",
                "hungarian_keywords",
                "hungarian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `indonesian` analyzer

The `indonesian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /indonesian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "indonesian_stop": {
              "type":       "stop",
              "stopwords":  "_indonesian_" ![](images/icons/callouts/1.png)
            },
            "indonesian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["contoh"] ![](images/icons/callouts/2.png)
            },
            "indonesian_stemmer": {
              "type":       "stemmer",
              "language":   "indonesian"
            }
          },
          "analyzer": {
            "indonesian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "indonesian_stop",
                "indonesian_keywords",
                "indonesian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `irish` analyzer

The `irish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /irish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "irish_elision": {
              "type":       "elision",
              "articles": [ "h", "n", "t" ]
            },
            "irish_stop": {
              "type":       "stop",
              "stopwords":  "_irish_" ![](images/icons/callouts/1.png)
            },
            "irish_lowercase": {
              "type":       "lowercase",
              "language":   "irish"
            },
            "irish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["sampla"] ![](images/icons/callouts/2.png)
            },
            "irish_stemmer": {
              "type":       "stemmer",
              "language":   "irish"
            }
          },
          "analyzer": {
            "irish": {
              "tokenizer":  "standard",
              "filter": [
                "irish_stop",
                "irish_elision",
                "irish_lowercase",
                "irish_keywords",
                "irish_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `italian` analyzer

The `italian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /italian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "italian_elision": {
              "type": "elision",
              "articles": [
                    "c", "l", "all", "dall", "dell",
                    "nell", "sull", "coll", "pell",
                    "gl", "agl", "dagl", "degl", "negl",
                    "sugl", "un", "m", "t", "s", "v", "d"
              ]
            },
            "italian_stop": {
              "type":       "stop",
              "stopwords":  "_italian_" ![](images/icons/callouts/1.png)
            },
            "italian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["esempio"] ![](images/icons/callouts/2.png)
            },
            "italian_stemmer": {
              "type":       "stemmer",
              "language":   "light_italian"
            }
          },
          "analyzer": {
            "italian": {
              "tokenizer":  "standard",
              "filter": [
                "italian_elision",
                "lowercase",
                "italian_stop",
                "italian_keywords",
                "italian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `latvian` analyzer

The `latvian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /latvian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "latvian_stop": {
              "type":       "stop",
              "stopwords":  "_latvian_" ![](images/icons/callouts/1.png)
            },
            "latvian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["piemērs"] ![](images/icons/callouts/2.png)
            },
            "latvian_stemmer": {
              "type":       "stemmer",
              "language":   "latvian"
            }
          },
          "analyzer": {
            "latvian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "latvian_stop",
                "latvian_keywords",
                "latvian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `lithuanian` analyzer

The `lithuanian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /lithuanian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "lithuanian_stop": {
              "type":       "stop",
              "stopwords":  "_lithuanian_" ![](images/icons/callouts/1.png)
            },
            "lithuanian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["pavyzdys"] ![](images/icons/callouts/2.png)
            },
            "lithuanian_stemmer": {
              "type":       "stemmer",
              "language":   "lithuanian"
            }
          },
          "analyzer": {
            "lithuanian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "lithuanian_stop",
                "lithuanian_keywords",
                "lithuanian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `norwegian` analyzer

The `norwegian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /norwegian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "norwegian_stop": {
              "type":       "stop",
              "stopwords":  "_norwegian_" ![](images/icons/callouts/1.png)
            },
            "norwegian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["eksempel"] ![](images/icons/callouts/2.png)
            },
            "norwegian_stemmer": {
              "type":       "stemmer",
              "language":   "norwegian"
            }
          },
          "analyzer": {
            "norwegian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "norwegian_stop",
                "norwegian_keywords",
                "norwegian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `persian` analyzer

The `persian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /persian_example
    {
      "settings": {
        "analysis": {
          "char_filter": {
            "zero_width_spaces": {
                "type":       "mapping",
                "mappings": [ "\\u200C=> "] ![](images/icons/callouts/1.png)
            }
          },
          "filter": {
            "persian_stop": {
              "type":       "stop",
              "stopwords":  "_persian_" ![](images/icons/callouts/2.png)
            }
          },
          "analyzer": {
            "persian": {
              "tokenizer":     "standard",
              "char_filter": [ "zero_width_spaces" ],
              "filter": [
                "lowercase",
                "arabic_normalization",
                "persian_normalization",
                "persian_stop"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Replaces zero-width non-joiners with an ASCII space.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
#### `portuguese` analyzer

The `portuguese` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /portuguese_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "portuguese_stop": {
              "type":       "stop",
              "stopwords":  "_portuguese_" ![](images/icons/callouts/1.png)
            },
            "portuguese_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplo"] ![](images/icons/callouts/2.png)
            },
            "portuguese_stemmer": {
              "type":       "stemmer",
              "language":   "light_portuguese"
            }
          },
          "analyzer": {
            "portuguese": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "portuguese_stop",
                "portuguese_keywords",
                "portuguese_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `romanian` analyzer

The `romanian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /romanian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "romanian_stop": {
              "type":       "stop",
              "stopwords":  "_romanian_" ![](images/icons/callouts/1.png)
            },
            "romanian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplu"] ![](images/icons/callouts/2.png)
            },
            "romanian_stemmer": {
              "type":       "stemmer",
              "language":   "romanian"
            }
          },
          "analyzer": {
            "romanian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "romanian_stop",
                "romanian_keywords",
                "romanian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `russian` analyzer

The `russian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /russian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "russian_stop": {
              "type":       "stop",
              "stopwords":  "_russian_" ![](images/icons/callouts/1.png)
            },
            "russian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["пример"] ![](images/icons/callouts/2.png)
            },
            "russian_stemmer": {
              "type":       "stemmer",
              "language":   "russian"
            }
          },
          "analyzer": {
            "russian": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "russian_stop",
                "russian_keywords",
                "russian_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `sorani` analyzer

The `sorani` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /sorani_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "sorani_stop": {
              "type":       "stop",
              "stopwords":  "_sorani_" ![](images/icons/callouts/1.png)
            },
            "sorani_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["mînak"] ![](images/icons/callouts/2.png)
            },
            "sorani_stemmer": {
              "type":       "stemmer",
              "language":   "sorani"
            }
          },
          "analyzer": {
            "sorani": {
              "tokenizer":  "standard",
              "filter": [
                "sorani_normalization",
                "lowercase",
                "sorani_stop",
                "sorani_keywords",
                "sorani_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `spanish` analyzer

The `spanish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /spanish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "spanish_stop": {
              "type":       "stop",
              "stopwords":  "_spanish_" ![](images/icons/callouts/1.png)
            },
            "spanish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["ejemplo"] ![](images/icons/callouts/2.png)
            },
            "spanish_stemmer": {
              "type":       "stemmer",
              "language":   "light_spanish"
            }
          },
          "analyzer": {
            "spanish": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "spanish_stop",
                "spanish_keywords",
                "spanish_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `swedish` analyzer

The `swedish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /swidish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "swedish_stop": {
              "type":       "stop",
              "stopwords":  "_swedish_" ![](images/icons/callouts/1.png)
            },
            "swedish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exempel"] ![](images/icons/callouts/2.png)
            },
            "swedish_stemmer": {
              "type":       "stemmer",
              "language":   "swedish"
            }
          },
          "analyzer": {
            "swedish": {
              "tokenizer":  "standard",
              "filter": [
                "lowercase",
                "swedish_stop",
                "swedish_keywords",
                "swedish_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `turkish` analyzer

The `turkish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /turkish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "turkish_stop": {
              "type":       "stop",
              "stopwords":  "_turkish_" ![](images/icons/callouts/1.png)
            },
            "turkish_lowercase": {
              "type":       "lowercase",
              "language":   "turkish"
            },
            "turkish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["örnek"] ![](images/icons/callouts/2.png)
            },
            "turkish_stemmer": {
              "type":       "stemmer",
              "language":   "turkish"
            }
          },
          "analyzer": {
            "turkish": {
              "tokenizer":  "standard",
              "filter": [
                "apostrophe",
                "turkish_lowercase",
                "turkish_stop",
                "turkish_keywords",
                "turkish_stemmer"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `thai` analyzer

The `thai` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /thai_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "thai_stop": {
              "type":       "stop",
              "stopwords":  "_thai_" ![](images/icons/callouts/1.png)
            }
          },
          "analyzer": {
            "thai": {
              "tokenizer":  "thai",
              "filter": [
                "lowercase",
                "thai_stop"
              ]
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
---|---
