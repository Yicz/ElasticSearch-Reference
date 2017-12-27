## Scripting

The scripting module enables you to use scripts to evaluate custom expressions. For example, you could use a script to return "script fields" as part of a search request or evaluate a custom score for a query.

The default scripting language is [`Painless`](modules-scripting-painless.html). Additional `lang` plugins enable you to run scripts written in other languages. Everywhere a script can be used, you can include a `lang` parameter to specify the language of the script.

### General-purpose languages:

These languages can be used for any purpose in the scripting APIs, and give the most flexibility.

Language | Sandboxed | Required plugin  
---|---|---    
[`painless`](modules-scripting-painless.html)| yes| built-in    
[`groovy`](modules-scripting-groovy.html)| [no](modules-scripting-security.html)| built-in    
[`javascript`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/lang-javascript.html)| [no](modules-scripting-security.html)| [`lang-javascript`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/lang-javascript.html)    
[`python`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/lang-python.html)| [no](modules-scripting-security.html)| [`lang-python`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/lang-python.html)  
  
### Special-purpose languages:

These languages are less flexible, but typically have higher performance for certain tasks.

Language | Sandboxed | Required plugin | Purpose  
---|---|---|---    
[`expression`](modules-scripting-expression.html)| yes| built-in| fast custom ranking and sorting    
[`mustache`](search-template.html)| yes| built-in| templates    
[`java`](modules-scripting-native.html)| n/a| you write it!| expert API  
  
![Warning](/images/icons/warning.png)

### Scripts and security

Languages that are sandboxed are designed with security in mind. However, non- sandboxed languages can be a security issue, please read [Scripting and security](modules-scripting-security.html) for more details.
