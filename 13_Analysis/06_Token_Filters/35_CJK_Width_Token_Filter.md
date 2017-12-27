## CJK Width Token Filter

The `cjk_width` token filter normalizes CJK width differences:

  * Folds fullwidth ASCII variants into the equivalent basic Latin 
  * Folds halfwidth Katakana variants into the equivalent Kana 



![Note](/images/icons/note.png)

This token filter can be viewed as a subset of NFKC/NFKD Unicode normalization. See the [`analysis-icu` plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/analysis-icu-normalization-charfilter.html) for full normalization support.
