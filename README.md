# ElasticSearch-Reference（非权威指南）

本项目翻译自：[https://www.elastic.co/guide/en/elasticsearch/reference/5.4/index.html](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/index.html)

本项目地址：[https://github.com/rainplus/ElasticSearch-Reference](https://github.com/rainplus/ElasticSearch-Reference)

本项目阅读地址：[https://elasticsearch.rainplus.xyz/](https://elasticsearch.rainplus.xyz/)

本项目新版本草稿地址(与主分支重构了文档目录结构，使用python转换官方原本格式)：[https://elasticsearch.rainplus.xyz/](https://elasticsearch.rainplus.xyz/v/drafts)

本项目官方原版gitbook模式阅读地址：[https://elasticsearch.rainplus.xyz/](https://elasticsearch.rainplus.xyz/v/english)


官方各个版本权威指南地址：[https://www.elastic.co/guide/en/elasticsearch/reference/index.html](https://www.elastic.co/guide/en/elasticsearch/reference/index.html)

说明：本人**太\(hen\)忙\(lan\)**,极其有可能只写下了README.md,同时说明不定期更新。

**版本选择说明**：公司一个同事要去其他地方高就。ES模块架构师说要丢给我，因为我之前弄过lucene和solr。公司原来的es是1.6版,我大致看了一下，这个版是上个世纪的事情了，现在lucene都6.6.2了\(2017-11-13\)\[lucene 7.+已经在路上\]lucene 6.+ 中 lucene 7.+之间的版差别的特性很大。重点是elasticserch 1.6 切换到 elasticsearch 5.4.3,中间的差别也很大，也是因为lucene的改动，所以近期，我的主要工作是熟悉elasticsearch和深入lucene的原理。

elasticsearch 5.4.0+ 对应的lucene 6.5.0+，所以elasticsearch 5.4.3实际的lucene版本是 lucene 6.5.1,我的目标也就是深入了解应用这两个版本，所以选择了elasticsearhc 5.4 的文档进行了翻译

**项目内的代码示例，有kibana语法和curl的语法，本翻译的内容尽量采用了curl的方式**
# 翻译进度说明

| 模块 | 完成情况 |
|---|---|
| [入门指南](01_Getting_Started/Getting_Started.md) | 待校验（2017-11-13） |
| [配置elasticsearch](02_Setup_Elasticsearch/Setup_Elasticsearch.md) | 待校验（2017-11-14） |
| [版本变更记录](03_Breaking_changes/Breaking_changes.md) | 可能不会进行翻译 |
| [API 约定](04_API_Conventions/API_Conventions.md)| 待校验 （2017-11-15）|
| [文档API](05_Document_APIs/Document_APIs.md) | 进行中 |
| [搜索API](06_Search_APIs/Search_APIs.md) | 未开始 |
| [聚合（Aggregations）APIs](07_Aggregations/Aggregations.md) | 未开始 |
| [索引 APIs](08_Indices_APIs/Indices_APIs.md)| 未开始 |
| [_cat APIs](09_cat_APIs/cat_APIs.md)  | 未开始 |
| [集群（clusters）](10_Cluster_APIs/Cluster_APIs.md)  | 未开始 |
| [询查特定领域语言（Domain Special Language）](11_Query_DSL/Query_DSL.md)| 未开始 |
| [映射（Mapping）](12_Mapping/Mapping.md) | 未开始 |
| [分析（Analysis）](13_Analysis/Analysis.md) | 未开始 |
| [模块（Modules）](14_Modules/Modules.md) | 未开始 |
| [索引模块（Index Modules）](15_Index_Modules/Index_Modules.md)  | 未开始 |
| [吸收结点（Ingest Node）](16_Ingest_Node/Ingest_Node.md)| 未开始 |
| [How To](17_How_To/How_To.md) | 未开始 |
| [测试（Testing）](18_Testing/Testing.md) | 未开始 |
| [专业术语（Glossary of terms）](19_Glossary_of_terms/Glossary_of_terms.md) | 完成 |
| [发布说明（Release Notes）](20_Release_Notes/Release_Notes.md) | 暂时照搬 |

# 项目的全部文件结构

```sh
ElasticSearch-Reference
├── 01_Getting_Started
│   ├── Basic_Concepts.md
│   ├── Conclusion.md
│   ├── Exploring_Your_Cluster
│   │   ├── Cluster_Health.md
│   │   ├── Create_an_Index.md
│   │   ├── Delete_an_Index.md
│   │   ├── Exploring_Your_Cluster.md
│   │   ├── Index_and_Query_a_Document.md
│   │   └── List_All_Indices.md
│   ├── Exploring_Your_Data
│   │   ├── Executing_Aggregations.md
│   │   ├── Executing_Filters.md
│   │   ├── Executing_Searches.md
│   │   ├── Exploring_Your_Data.md
│   │   ├── Introducing_the_Query_Language.md
│   │   └── The_Search_API.md
│   ├── Getting_Started.md
│   ├── Installation.md
│   ├── Modifying_Your_Data
│   │   ├── Batch_Processing.md
│   │   ├── Deleting_Documents.md
│   │   ├── Modifying_Your_Data.md
│   │   └── Updating_Documents.md
│   └── getting_start.sh
├── 02_Setup_Elasticsearch
│   ├── Bootstrap_Checks
│   │   ├── Bootstrap_Checks.md
│   │   ├── Client_JVM_check.md
│   │   ├── Early-access_check.md
│   │   ├── File_descriptor_check.md
│   │   ├── G1GC_check.md
│   │   ├── Heap_size_check.md
│   │   ├── Maximum_map_count_check.md
│   │   ├── Maximum_number_of_threads_check.md
│   │   ├── Maximum_size_virtual_memory_check.md
│   │   ├── Memory_lock_check.md
│   │   ├── OnError_and_OnOutOfMemoryError_checks.md
│   │   ├── System_call_filter_check.md
│   │   └── Use_serial_collector_check.md
│   ├── Configuring_Elasticsearch.md
│   ├── Important_Elasticsearch_configuration.md
│   ├── Important_System_Configuration
│   │   ├── Configuring_system_settings.md
│   │   ├── Disable_swapping.md
│   │   ├── File_Descriptors.md
│   │   ├── Important_System_Configuration.md
│   │   ├── Number_of_threads.md
│   │   ├── Set_JVM_heap_size_via_jvm.options.md
│   │   └── Virtual_memory.md
│   ├── Installing_Elasticsearch
│   │   ├── Install_Elasticsearch_on_Windows.md
│   │   ├── Install_Elasticsearch_with_.zip_or_.tar.gz.md
│   │   ├── Install_Elasticsearch_with_Debian_Package.md
│   │   ├── Install_Elasticsearch_with_Docker.md
│   │   ├── Install_Elasticsearch_with_RPM.md
│   │   └── Installing_Elasticsearch.md
│   ├── Secure_Settings.md
│   ├── Setup_Elasticsearch.md
│   ├── Stopping_Elasticsearch.md
│   ├── Upgrading_Elasticsearch
│   │   ├── Full_cluster_restart_upgrade.md
│   │   ├── Reindex_to_upgrade.md
│   │   ├── Rolling_upgrades.md
│   │   └── Upgrading_Elasticsearch.md
│   └── setup_elasticsearch.sh
├── 03_Breaking_changes
│   ├── Breaking_changes.md
│   ├── Breaking_changes_in_5.0
│   │   ├── Aggregation_changes.md
│   │   ├── Allocation_changes.md
│   │   ├── Breaking_changes_in_5.0.md
│   │   ├── CAT_API_changes.md
│   │   ├── Document_API_changes.md
│   │   ├── Filesystem_related_changes.md
│   │   ├── HTTP_changes.md
│   │   ├── Index_APIs_changes.md
│   │   ├── Java_API_changes.md
│   │   ├── Mapping_changes.md
│   │   ├── Packaging.md
│   │   ├── Path_to_data_on_disk.md
│   │   ├── Percolator_changes.md
│   │   ├── Plugin_changes.md
│   │   ├── REST_API_changes.md
│   │   ├── Script_related_changes.md
│   │   ├── Search_and_Query_DSL_changes.md
│   │   ├── Settings_changes.md
│   │   └── Suggester_changes.md
│   ├── Breaking_changes_in_5.1.md
│   ├── Breaking_changes_in_5.2
│   │   ├── Breaking_changes_in_5.2.md
│   │   └── Shadow_Replicas_are_deprecated.md
│   ├── Breaking_changes_in_5.3.md
│   ├── Breaking_changes_in_5.4.md
│   └── breaking_changes.sh
├── 04_API_Conventions
│   ├── API_Conventions.md
│   ├── Common_options.md
│   ├── Date_math_support_in_index_names.md
│   ├── Multiple_Indices.md
│   ├── URL-based_access_control.md
│   └── api_conventions.sh
├── 05_Document_APIs
│   ├── Document_APIs.md
│   └── document_api.sh
├── 06_Search_APIs
│   ├── Count_API.md
│   ├── Explain_API.md
│   ├── Field_Capabilities_API.md
│   ├── Field_stats_API.md
│   ├── Multi_Search_API.md
│   ├── Multi_Search_Template.md
│   ├── Percolator.md
│   ├── Profile_API
│   │   ├── Profile_API.md
│   │   ├── Profiling_Aggregations.md
│   │   ├── Profiling_Considerations.md
│   │   └── Profiling_Queries.md
│   ├── Request_Body_Search
│   │   ├── Doc_value_Fields.md
│   │   ├── Explain.md
│   │   ├── Field_Collapsing.md
│   │   ├── Fields.md
│   │   ├── From_&_Size.md
│   │   ├── Highlighting.md
│   │   ├── Index_Boost.md
│   │   ├── Inner_hits.md
│   │   ├── Named_Queries.md
│   │   ├── Post_filter.md
│   │   ├── Preference.md
│   │   ├── Query.md
│   │   ├── Request_Body_Search.md
│   │   ├── Rescoring.md
│   │   ├── Script_Fields.md
│   │   ├── Scroll.md
│   │   ├── Search_After.md
│   │   ├── Search_Type.md
│   │   ├── Sort.md
│   │   ├── Source_filtering.md
│   │   ├── Version.md
│   │   └── min_score.md
│   ├── Search.md
│   ├── Search_APIs.md
│   ├── Search_Shards_API.md
│   ├── Search_Template.md
│   ├── Suggesters
│   │   ├── Completion_Suggester.md
│   │   ├── Context_Suggester.md
│   │   ├── Phrase_Suggester.md
│   │   ├── Returning_the_type_of_the_suggester.md
│   │   ├── Suggesters.md
│   │   └── Term_suggester.md
│   ├── URI_Search.md
│   ├── Validate_API.md
│   └── search_api.sh
├── 07_Aggregations
│   ├── Aggregation_Metadata.md
│   ├── Aggregations.md
│   ├── Bucket_Aggregations
│   │   ├── Adjacency_Matrix_Aggregation.md
│   │   ├── Bucket_Aggregations.md
│   │   ├── Children_Aggregation.md
│   │   ├── Date_Histogram_Aggregation.md
│   │   ├── Date_Range_Aggregation.md
│   │   ├── Diversified_Sampler_Aggregation.md
│   │   ├── Filter_Aggregation.md
│   │   ├── Filters_Aggregation.md
│   │   ├── GeoHash_grid_Aggregation.md
│   │   ├── Geo_Distance_Aggregation.md
│   │   ├── Global_Aggregation.md
│   │   ├── Histogram_Aggregation.md
│   │   ├── IP_Range_Aggregation.md
│   │   ├── Missing_Aggregation.md
│   │   ├── Nested_Aggregation.md
│   │   ├── Range_Aggregation.md
│   │   ├── Reverse_nested_Aggregation.md
│   │   ├── Sampler_Aggregation.md
│   │   ├── Significant_Terms_Aggregation.md
│   │   └── Terms_Aggregation.md
│   ├── Caching_heavy_aggregations.md
│   ├── Matrix_Aggregations
│   │   ├── Matrix_Aggregations.md
│   │   └── Matrix_Stats.md
│   ├── Metrics_Aggregations
│   │   ├── Avg_Aggregation.md
│   │   ├── Cardinality_Aggregation.md
│   │   ├── Extended_Stats_Aggregation.md
│   │   ├── Geo_Bounds_Aggregation.md
│   │   ├── Geo_Centroid_Aggregation.md
│   │   ├── Max_Aggregation.md
│   │   ├── Metrics_Aggregations.md
│   │   ├── Min_Aggregation.md
│   │   ├── Percentile_Ranks_Aggregation.md
│   │   ├── Percentiles_Aggregation.md
│   │   ├── Scripted_Metric_Aggregation.md
│   │   ├── Stats_Aggregation.md
│   │   ├── Sum_Aggregation.md
│   │   ├── Top_hits_Aggregation.md
│   │   └── Value_Count_Aggregation.md
│   ├── Pipeline_Aggregations
│   │   ├── Avg_Bucket_Aggregation.md
│   │   ├── Bucket_Script_Aggregation.md
│   │   ├── Bucket_Selector_Aggregation.md
│   │   ├── Cumulative_Sum_Aggregation.md
│   │   ├── Derivative_Aggregation.md
│   │   ├── Extended_Stats_Bucket_Aggregation.md
│   │   ├── Max_Bucket_Aggregation.md
│   │   ├── Min_Bucket_Aggregation.md
│   │   ├── Moving_Average_Aggregation.md
│   │   ├── Percentiles_Bucket_Aggregation.md
│   │   ├── Pipeline_Aggregations.md
│   │   ├── Serial_Differencing_Aggregation.md
│   │   ├── Stats_Bucket_Aggregation.md
│   │   └── Sum_Bucket_Aggregation.md
│   ├── Returning_only_aggregation_results.md
│   ├── Returning_the_type_of_the_aggregation.md
│   └── aggregations.sh
├── 08_Indices_APIs
│   ├── Analyze
│   │   ├── Analyze.md
│   │   └── Explain_Analyze.md
│   ├── Clear_Cache.md
│   ├── Create_Index.md
│   ├── Delete_Index.md
│   ├── Flush
│   │   ├── Flush.md
│   │   └── Synced_Flush.md
│   ├── Force_Merge.md
│   ├── Get_Field_Mapping.md
│   ├── Get_Index.md
│   ├── Get_Mapping.md
│   ├── Get_Settings.md
│   ├── Index_Aliases.md
│   ├── Index_Templates.md
│   ├── Indices_APIs.md
│   ├── Indices_Exists.md
│   ├── Indices_Recovery.md
│   ├── Indices_Segments.md
│   ├── Indices_Shard_Stores.md
│   ├── Indices_Stats.md
│   ├── Open_&_Close_Index_API.md
│   ├── Put_Mapping.md
│   ├── Refresh.md
│   ├── Rollover_Index.md
│   ├── Shadow_replica_indices
│   │   ├── Node_level_settings_related_to_shadow_replicas.md
│   │   └── Shadow_replica_indices.md
│   ├── Shrink_Index.md
│   ├── Types_Exists.md
│   ├── Update_Indices_Settings.md
│   └── indices_apis.sh
├── 09_cat_APIs
│   ├── cat_APIs.md
│   ├── cat_aliases.md
│   ├── cat_allocation.md
│   ├── cat_apis.sh
│   ├── cat_count.md
│   ├── cat_fielddata.md
│   ├── cat_health.md
│   ├── cat_indices.md
│   ├── cat_master.md
│   ├── cat_nodeattrs.md
│   ├── cat_nodes.md
│   ├── cat_pending_tasks.md
│   ├── cat_plugins.md
│   ├── cat_recovery.md
│   ├── cat_repositories.md
│   ├── cat_segments.md
│   ├── cat_shards.md
│   ├── cat_snapshots.md
│   ├── cat_templates.md
│   └── cat_thread_pool.md
├── 10_Cluster_APIs
│   ├── Cluster_APIs.md
│   ├── Cluster_Allocation_Explain_API.md
│   ├── Cluster_Health.md
│   ├── Cluster_Reroute.md
│   ├── Cluster_State.md
│   ├── Cluster_Stats.md
│   ├── Cluster_Update_Settings.md
│   ├── Nodes_Info.md
│   ├── Nodes_Stats.md
│   ├── Nodes_hot_threads.md
│   ├── Pending_cluster_tasks.md
│   ├── Remote_Cluster_Info.md
│   ├── Task_Management_API.md
│   └── cluster_apis.sh
├── 11_Query_DSL
│   ├── Compound_queries
│   │   ├── Bool_Query.md
│   │   ├── Boosting_Query.md
│   │   ├── Compound_queries.md
│   │   ├── Constant_Score_Query.md
│   │   ├── Dis_Max_Query.md
│   │   ├── Function_Score_Query.md
│   │   └── Indices_Query.md
│   ├── Full_text_queries
│   │   ├── Common_Terms_Query.md
│   │   ├── Full_text_queries.md
│   │   ├── Match_Phrase_Prefix_Query.md
│   │   ├── Match_Phrase_Query.md
│   │   ├── Match_Query.md
│   │   ├── Multi_Match_Query.md
│   │   ├── Query_String_Query.md
│   │   └── Simple_Query_String_Query.md
│   ├── Geo_queries
│   │   ├── GeoShape_Query.md
│   │   ├── Geo_Bounding_Box_Query.md
│   │   ├── Geo_Distance_Query.md
│   │   ├── Geo_Distance_Range_Query.md
│   │   ├── Geo_Polygon_Query.md
│   │   └── Geo_queries.md
│   ├── Joining_queries
│   │   ├── Has_Child_Query.md
│   │   ├── Has_Parent_Query.md
│   │   ├── Joining_queries.md
│   │   ├── Nested_Query.md
│   │   └── Parent_Id_Query.md
│   ├── Match_All_Query.md
│   ├── Minimum_Should_Match.md
│   ├── Multi_Term_Query_Rewrite.md
│   ├── Query_DSL.md
│   ├── Query_and_filter_context.md
│   ├── Span_queries
│   │   ├── Span_Containing_Query.md
│   │   ├── Span_Field_Masking_Query.md
│   │   ├── Span_First_Query.md
│   │   ├── Span_Multi_Term_Query.md
│   │   ├── Span_Near_Query.md
│   │   ├── Span_Not_Query.md
│   │   ├── Span_Or_Query.md
│   │   ├── Span_Term_Query.md
│   │   ├── Span_Within_Query.md
│   │   └── Span_queries.md
│   ├── Specialized_queries
│   │   ├── More_Like_This_Query.md
│   │   ├── Percolate_Query.md
│   │   ├── Script_Query.md
│   │   ├── Specialized_queries.md
│   │   └── Template_Query.md
│   ├── Term_level_queries
│   │   ├── Exists_Query.md
│   │   ├── Fuzzy_Query.md
│   │   ├── Ids_Query.md
│   │   ├── Prefix_Query.md
│   │   ├── Range_Query.md
│   │   ├── Regexp_Query.md
│   │   ├── Term_Query.md
│   │   ├── Term_level_queries.md
│   │   ├── Terms_Query.md
│   │   ├── Type_Query.md
│   │   └── Wildcard_Query.md
│   └── query_dsl.sh
├── 12_Mapping
│   ├── Dynamic_Mapping
│   │   ├── Dynamic_Mapping.md
│   │   ├── Dynamic_field_mapping.md
│   │   ├── Dynamic_templates.md
│   │   ├── Override_default_template.md
│   │   └── _default__mapping.md
│   ├── Field_datatypes
│   │   ├── Array_datatype.md
│   │   ├── Binary_datatype.md
│   │   ├── Boolean_datatype.md
│   │   ├── Date_datatype.md
│   │   ├── Field_datatypes.md
│   │   ├── Geo-Shape_datatype.md
│   │   ├── Geo-point_datatype.md
│   │   ├── IP_datatype.md
│   │   ├── Keyword_datatype.md
│   │   ├── Nested_datatype.md
│   │   ├── Numeric_datatypes.md
│   │   ├── Object_datatype.md
│   │   ├── Percolator_type.md
│   │   ├── Range_datatypes.md
│   │   ├── String_datatype.md
│   │   ├── Text_datatype.md
│   │   └── Token_count_datatype.md
│   ├── Mapping.md
│   ├── Mapping_parameters
│   │   ├── Mapping_parameters.md
│   │   ├── analyzer.md
│   │   ├── boost.md
│   │   ├── coerce.md
│   │   ├── copy_to.md
│   │   ├── doc_values.md
│   │   ├── dynamic.md
│   │   ├── enabled.md
│   │   ├── fielddata.md
│   │   ├── fields.md
│   │   ├── format.md
│   │   ├── ignore_above.md
│   │   ├── ignore_malformed.md
│   │   ├── include_in_all.md
│   │   ├── index.md
│   │   ├── index_options.md
│   │   ├── normalizer.md
│   │   ├── norms.md
│   │   ├── null_value.md
│   │   ├── position_increment_gap.md
│   │   ├── properties.md
│   │   ├── search_analyzer.md
│   │   ├── similarity.md
│   │   ├── store.md
│   │   └── term_vector.md
│   ├── Meta-Fields
│   │   ├── Meta-Fields.md
│   │   ├── _all_field.md
│   │   ├── _field_names_field.md
│   │   ├── _id_field.md
│   │   ├── _index_field.md
│   │   ├── _meta_field.md
│   │   ├── _parent_field.md
│   │   ├── _routing_field.md
│   │   ├── _source_field.md
│   │   ├── _type_field.md
│   │   └── _uid_field.md
│   └── mapping.sh
├── 13_Analysis
│   ├── Analysis.md
│   ├── Analyzers
│   │   ├── Analyzers.md
│   │   ├── Configuring_built-in_analyzers.md
│   │   ├── Custom_Analyzer.md
│   │   ├── Fingerprint_Analyzer.md
│   │   ├── Keyword_Analyzer.md
│   │   ├── Language_Analyzers.md
│   │   ├── Pattern_Analyzer.md
│   │   ├── Simple_Analyzer.md
│   │   ├── Standard_Analyzer.md
│   │   ├── Stop_Analyzer.md
│   │   └── Whitespace_Analyzer.md
│   ├── Anatomy_of_an_analyzer.md
│   ├── Character_Filters
│   │   ├── Character_Filters.md
│   │   ├── HTML_Strip_Char_Filter.md
│   │   ├── Mapping_Char_Filter.md
│   │   └── Pattern_Replace_Char_Filter.md
│   ├── Normalizers.md
│   ├── Testing_analyzers.md
│   ├── Token_Filters
│   │   ├── ASCII_Folding_Token_Filter.md
│   │   ├── Apostrophe_Token_Filter.md
│   │   ├── CJK_Bigram_Token_Filter.md
│   │   ├── CJK_Width_Token_Filter.md
│   │   ├── Classic_Token_Filter.md
│   │   ├── Common_Grams_Token_Filter.md
│   │   ├── Compound_Word_Token_Filters.md
│   │   ├── Decimal_Digit_Token_Filter.md
│   │   ├── Delimited_Payload_Token_Filter.md
│   │   ├── Edge_NGram_Token_Filter.md
│   │   ├── Elision_Token_Filter.md
│   │   ├── Fingerprint_Token_Filter.md
│   │   ├── Flatten_Graph_Token_Filter.md
│   │   ├── Hunspell_Token_Filter.md
│   │   ├── KStem_Token_Filter.md
│   │   ├── Keep_Types_Token_Filter.md
│   │   ├── Keep_Words_Token_Filter.md
│   │   ├── Keyword_Marker_Token_Filter.md
│   │   ├── Keyword_Repeat_Token_Filter.md
│   │   ├── Length_Token_Filter.md
│   │   ├── Limit_Token_Count_Token_Filter.md
│   │   ├── Lowercase_Token_Filter.md
│   │   ├── Minhash_Token_Filter.md
│   │   ├── NGram_Token_Filter.md
│   │   ├── Normalization_Token_Filter.md
│   │   ├── Pattern_Capture_Token_Filter.md
│   │   ├── Pattern_Replace_Token_Filter.md
│   │   ├── Phonetic_Token_Filter.md
│   │   ├── Porter_Stem_Token_Filter.md
│   │   ├── Reverse_Token_Filter.md
│   │   ├── Shingle_Token_Filter.md
│   │   ├── Snowball_Token_Filter.md
│   │   ├── Standard_Token_Filter.md
│   │   ├── Stemmer_Override_Token_Filter.md
│   │   ├── Stemmer_Token_Filter.md
│   │   ├── Stop_Token_Filter.md
│   │   ├── Synonym_Graph_Token_Filter.md
│   │   ├── Synonym_Token_Filter.md
│   │   ├── Token_Filters.md
│   │   ├── Trim_Token_Filter.md
│   │   ├── Truncate_Token_Filter.md
│   │   ├── Unique_Token_Filter.md
│   │   ├── Uppercase_Token_Filter.md
│   │   ├── Word_Delimiter_Graph_Token_Filter.md
│   │   └── Word_Delimiter_Token_Filter.md
│   ├── Tokenizers
│   │   ├── Classic_Tokenizer.md
│   │   ├── Edge_NGram_Tokenizer.md
│   │   ├── Keyword_Tokenizer.md
│   │   ├── Letter_Tokenizer.md
│   │   ├── Lowercase_Tokenizer.md
│   │   ├── NGram_Tokenizer.md
│   │   ├── Path_Hierarchy_Tokenizer.md
│   │   ├── Pattern_Tokenizer.md
│   │   ├── Standard_Tokenizer.md
│   │   ├── Thai_Tokenizer.md
│   │   ├── Tokenizers.md
│   │   ├── UAX_URL_Email_Tokenizer.md
│   │   └── Whitespace_Tokenizer.md
│   └── analysis.sh
├── 14_Modules
│   ├── Cluster
│   │   ├── Cluster.md
│   │   ├── Cluster_Level_Shard_Allocation.md
│   │   ├── Disk-based_Shard_Allocation.md
│   │   ├── Miscellaneous_cluster_settings.md
│   │   ├── Shard_Allocation_Awareness.md
│   │   └── Shard_Allocation_Filtering.md
│   ├── Cross_Cluster_Search.md
│   ├── Discovery
│   │   ├── Azure_Classic_Discovery.md
│   │   ├── Discovery.md
│   │   ├── EC2_Discovery.md
│   │   ├── Google_Compute_Engine_Discovery.md
│   │   └── Zen_Discovery.md
│   ├── HTTP.md
│   ├── Indices
│   │   ├── Circuit_Breaker.md
│   │   ├── Fielddata.md
│   │   ├── Indexing_Buffer.md
│   │   ├── Indices.md
│   │   ├── Indices_Recovery.md
│   │   ├── Node_Query_Cache.md
│   │   └── Shard_request_cache.md
│   ├── Local_Gateway.md
│   ├── Modules.md
│   ├── Network_Settings.md
│   ├── Node.md
│   ├── Plugins.md
│   ├── Scripting
│   │   ├── Accessing_document_fields_and_special_variables.md
│   │   ├── Advanced_text_scoring_in_scripts.md
│   │   ├── Groovy_Scripting_Language.md
│   │   ├── How_to_use_scripts.md
│   │   ├── Lucene_Expressions_Language.md
│   │   ├── Native_(Java)_Scripts.md
│   │   ├── Painless_Debugging.md
│   │   ├── Painless_Scripting_Language.md
│   │   ├── Painless_Syntax.md
│   │   ├── Scripting.md
│   │   └── Scripting_and_security.md
│   ├── Snapshot_And_Restore.md
│   ├── Thread_Pool.md
│   ├── Transport.md
│   ├── Tribe_node.md
│   └── modules.sh
├── 15_Index_Modules
│   ├── Analysis.md
│   ├── Index_Modules.md
│   ├── Index_Shard_Allocation
│   │   ├── Delaying_allocation_when_a_node_leaves.md
│   │   ├── Index_Shard_Allocation.md
│   │   ├── Index_recovery_prioritization.md
│   │   ├── Shard_Allocation_Filtering.md
│   │   └── Total_Shards_Per_Node.md
│   ├── Mapper.md
│   ├── Merge.md
│   ├── Similarity_module.md
│   ├── Slow_Log.md
│   ├── Store
│   │   ├── Pre-loading_data_into_the_file_system_cache.md
│   │   └── Store.md
│   ├── Translog.md
│   └── index_modules.sh
├── 16_Ingest_Node
│   ├── Accessing_Data_in_Pipelines.md
│   ├── Handling_Failures_in_Pipelines.md
│   ├── Ingest_APIs
│   │   ├── Delete_Pipeline_API.md
│   │   ├── Get_Pipeline_API.md
│   │   ├── Ingest_APIs.md
│   │   ├── Put_Pipeline_API.md
│   │   └── Simulate_Pipeline_API.md
│   ├── Ingest_Node.md
│   ├── Pipeline_Definition.md
│   ├── Processors
│   │   ├── Append_Processor.md
│   │   ├── Convert_Processor.md
│   │   ├── Date_Index_Name_Processor.md
│   │   ├── Date_Processor.md
│   │   ├── Dot_Expander_Processor.md
│   │   ├── Fail_Processor.md
│   │   ├── Foreach_Processor.md
│   │   ├── Grok_Processor.md
│   │   ├── Gsub_Processor.md
│   │   ├── JSON_Processor.md
│   │   ├── Join_Processor.md
│   │   ├── KV_Processor.md
│   │   ├── Lowercase_Processor.md
│   │   ├── Processors.md
│   │   ├── Remove_Processor.md
│   │   ├── Rename_Processor.md
│   │   ├── Script_Processor.md
│   │   ├── Set_Processor.md
│   │   ├── Sort_Processor.md
│   │   ├── Split_Processor.md
│   │   ├── Trim_Processor.md
│   │   └── Uppercase_Processor.md
│   └── ingest_node.sh
├── 17_How_To
│   ├── General_recommendations.md
│   ├── How_To.md
│   ├── Recipes.md
│   ├── Tune_for_disk_usage.md
│   ├── Tune_for_indexing_speed.md
│   ├── Tune_for_search_speed.md
│   └── how_to.sh
├── 18_Testing
│   ├── Java_Testing_Framework
│   │   ├── Assertions.md
│   │   ├── Java_Testing_Framework.md
│   │   ├── Randomized_testing.md
│   │   ├── Using_the_elasticsearch_test_classes.md
│   │   ├── integration_tests.md
│   │   ├── unit_tests.md
│   │   └── why_randomized_testing?.md
│   ├── Testing.md
│   └── testing.sh
├── 19_Glossary_of_terms
│   └── Glossary_of_terms.md
├── 20_Release_Notes
│   └── Release_Notes.md
├── README.md
└── init.sh

63 directories, 562 files
```



