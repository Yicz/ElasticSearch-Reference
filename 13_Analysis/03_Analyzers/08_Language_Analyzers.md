## Language Analyzers

A set of analyzers aimed at analyzing specific language text. The following types are supported: 

[`arabic`](analysis-lang-analyzer.html#arabic-analyzer)
 
[`armenian`](analysis-lang-analyzer.html#armenian-analyzer)
 
[`basque`](analysis-lang-analyzer.html#basque-analyzer)
 
[`brazilian`](analysis-lang-analyzer.html#brazilian-analyzer)
 
[`bulgarian`](analysis-lang-analyzer.html#bulgarian-analyzer)
 
[`catalan`](analysis-lang-analyzer.html#catalan-analyzer)
 
[`cjk`](analysis-lang-analyzer.html#cjk-analyzer)
 
[`czech`](analysis-lang-analyzer.html#czech-analyzer)
 
[`danish`](analysis-lang-analyzer.html#danish-analyzer)
 
[`dutch`](analysis-lang-analyzer.html#dutch-analyzer)
 
[`english`](analysis-lang-analyzer.html#english-analyzer)
 
[`finnish`](analysis-lang-analyzer.html#finnish-analyzer)
 
[`french`](analysis-lang-analyzer.html#french-analyzer)
 
[`galician`](analysis-lang-analyzer.html#galician-analyzer)
 
[`german`](analysis-lang-analyzer.html#german-analyzer)
 
[`greek`](analysis-lang-analyzer.html#greek-analyzer)
 
[`hindi`](analysis-lang-analyzer.html#hindi-analyzer)
 
[`hungarian`](analysis-lang-analyzer.html#hungarian-analyzer)
 
[`indonesian`](analysis-lang-analyzer.html#indonesian-analyzer)
 
[`irish`](analysis-lang-analyzer.html#irish-analyzer)
 
[`italian`](analysis-lang-analyzer.html#italian-analyzer)
 
[`latvian`](analysis-lang-analyzer.html#latvian-analyzer)
 
[`lithuanian`](analysis-lang-analyzer.html#lithuanian-analyzer)
 
[`norwegian`](analysis-lang-analyzer.html#norwegian-analyzer)
 
[`persian`](analysis-lang-analyzer.html#persian-analyzer)
 
[`portuguese`](analysis-lang-analyzer.html#portuguese-analyzer)
 
[`romanian`](analysis-lang-analyzer.html#romanian-analyzer)
 
[`russian`](analysis-lang-analyzer.html#russian-analyzer)
 
[`sorani`](analysis-lang-analyzer.html#sorani-analyzer)
 
[`spanish`](analysis-lang-analyzer.html#spanish-analyzer)
 
[`swedish`](analysis-lang-analyzer.html#swedish-analyzer)
 
[`turkish`](analysis-lang-analyzer.html#turkish-analyzer)
 
[`thai`](analysis-lang-analyzer.html#thai-analyzer)


### Configuring language analyzers

#### Stopwords

All analyzers support setting custom `stopwords` either internally in the config, or by using an external stopwords file by setting `stopwords_path`. Check [Stop Analyzer](analysis-stop-analyzer.html) for more details.

#### Excluding words from stemming

The `stem_exclusion` parameter allows you to specify an array of lowercase words that should not be stemmed. Internally, this functionality is implemented by adding the [`keyword_marker` token filter](analysis-keyword-marker-tokenfilter.html) with the `keywords` set to the value of the `stem_exclusion` parameter.

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
              "stopwords":  "_arabic_" #1
            },
            "arabic_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["مثال"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `armenian` analyzer

The `armenian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /armenian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "armenian_stop": {
              "type":       "stop",
              "stopwords":  "_armenian_" #1
            },
            "armenian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["օրինակ"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `basque` analyzer

The `basque` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /armenian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "basque_stop": {
              "type":       "stop",
              "stopwords":  "_basque_" #1
            },
            "basque_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["Adibidez"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `brazilian` analyzer

The `brazilian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /brazilian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "brazilian_stop": {
              "type":       "stop",
              "stopwords":  "_brazilian_" #1
            },
            "brazilian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplo"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `bulgarian` analyzer

The `bulgarian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /bulgarian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "bulgarian_stop": {
              "type":       "stop",
              "stopwords":  "_bulgarian_" #1
            },
            "bulgarian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["пример"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
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
              "stopwords":  "_catalan_" #1
            },
            "catalan_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemple"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `cjk` analyzer

The `cjk` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /cjk_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "english_stop": {
              "type":       "stop",
              "stopwords":  "_english_" #1
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
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
              "stopwords":  "_czech_" #1
            },
            "czech_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["příklad"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `danish` analyzer

The `danish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /danish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "danish_stop": {
              "type":       "stop",
              "stopwords":  "_danish_" #1
            },
            "danish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["eksempel"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `dutch` analyzer

The `dutch` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /detch_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "dutch_stop": {
              "type":       "stop",
              "stopwords":  "_dutch_" #1
            },
            "dutch_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["voorbeeld"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `english` analyzer

The `english` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /english_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "english_stop": {
              "type":       "stop",
              "stopwords":  "_english_" #1
            },
            "english_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["example"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `finnish` analyzer

The `finnish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /finnish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "finnish_stop": {
              "type":       "stop",
              "stopwords":  "_finnish_" #1
            },
            "finnish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["esimerkki"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
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
              "stopwords":  "_french_" #1
            },
            "french_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["Exemple"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `galician` analyzer

The `galician` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /galician_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "galician_stop": {
              "type":       "stop",
              "stopwords":  "_galician_" #1
            },
            "galician_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplo"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `german` analyzer

The `german` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /german_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "german_stop": {
              "type":       "stop",
              "stopwords":  "_german_" #1
            },
            "german_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["Beispiel"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `greek` analyzer

The `greek` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /greek_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "greek_stop": {
              "type":       "stop",
              "stopwords":  "_greek_" #1
            },
            "greek_lowercase": {
              "type":       "lowercase",
              "language":   "greek"
            },
            "greek_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["παράδειγμα"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `hindi` analyzer

The `hindi` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /hindi_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "hindi_stop": {
              "type":       "stop",
              "stopwords":  "_hindi_" #1
            },
            "hindi_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["उदाहरण"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `hungarian` analyzer

The `hungarian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /hungarian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "hungarian_stop": {
              "type":       "stop",
              "stopwords":  "_hungarian_" #1
            },
            "hungarian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["példa"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `indonesian` analyzer

The `indonesian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /indonesian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "indonesian_stop": {
              "type":       "stop",
              "stopwords":  "_indonesian_" #1
            },
            "indonesian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["contoh"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
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
              "stopwords":  "_irish_" #1
            },
            "irish_lowercase": {
              "type":       "lowercase",
              "language":   "irish"
            },
            "irish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["sampla"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
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
              "stopwords":  "_italian_" #1
            },
            "italian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["esempio"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `latvian` analyzer

The `latvian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /latvian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "latvian_stop": {
              "type":       "stop",
              "stopwords":  "_latvian_" #1
            },
            "latvian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["piemērs"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `lithuanian` analyzer

The `lithuanian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /lithuanian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "lithuanian_stop": {
              "type":       "stop",
              "stopwords":  "_lithuanian_" #1
            },
            "lithuanian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["pavyzdys"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `norwegian` analyzer

The `norwegian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /norwegian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "norwegian_stop": {
              "type":       "stop",
              "stopwords":  "_norwegian_" #1
            },
            "norwegian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["eksempel"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `persian` analyzer

The `persian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /persian_example
    {
      "settings": {
        "analysis": {
          "char_filter": {
            "zero_width_spaces": {
                "type":       "mapping",
                "mappings": [ "\\u200C=> "] #1
            }
          },
          "filter": {
            "persian_stop": {
              "type":       "stop",
              "stopwords":  "_persian_" #2
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

#1| Replaces zero-width non-joiners with an ASCII space.     
---|---    
#2| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.   
  
#### `portuguese` analyzer

The `portuguese` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /portuguese_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "portuguese_stop": {
              "type":       "stop",
              "stopwords":  "_portuguese_" #1
            },
            "portuguese_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplo"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `romanian` analyzer

The `romanian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /romanian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "romanian_stop": {
              "type":       "stop",
              "stopwords":  "_romanian_" #1
            },
            "romanian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exemplu"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `russian` analyzer

The `russian` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /russian_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "russian_stop": {
              "type":       "stop",
              "stopwords":  "_russian_" #1
            },
            "russian_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["пример"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `sorani` analyzer

The `sorani` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /sorani_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "sorani_stop": {
              "type":       "stop",
              "stopwords":  "_sorani_" #1
            },
            "sorani_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["mînak"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `spanish` analyzer

The `spanish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /spanish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "spanish_stop": {
              "type":       "stop",
              "stopwords":  "_spanish_" #1
            },
            "spanish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["ejemplo"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `swedish` analyzer

The `swedish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /swidish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "swedish_stop": {
              "type":       "stop",
              "stopwords":  "_swedish_" #1
            },
            "swedish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["exempel"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---    
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `turkish` analyzer

The `turkish` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /turkish_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "turkish_stop": {
              "type":       "stop",
              "stopwords":  "_turkish_" #1
            },
            "turkish_lowercase": {
              "type":       "lowercase",
              "language":   "turkish"
            },
            "turkish_keywords": {
              "type":       "keyword_marker",
              "keywords":   ["örnek"] #2
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---  
#2| This filter should be removed unless there are words which should be excluded from stemming.   
  
#### `thai` analyzer

The `thai` analyzer could be reimplemented as a `custom` analyzer as follows:
    
    
    PUT /thai_example
    {
      "settings": {
        "analysis": {
          "filter": {
            "thai_stop": {
              "type":       "stop",
              "stopwords":  "_thai_" #1
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

#1| The default stopwords can be overridden with the `stopwords` or `stopwords_path` parameters.     
---|---
