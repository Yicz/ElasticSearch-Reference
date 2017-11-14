#!/bin/sh

dirNames=(Request_Body_Search Suggesters Profile_API )
files=(Search.md URI_Search.md Request_Body_Search/Query.md Request_Body_Search/From_/_Size.md Request_Body_Search/Sort.md Request_Body_Search/Source_filtering.md Request_Body_Search/Fields.md Request_Body_Search/Script_Fields.md Request_Body_Search/Doc_value_Fields.md Request_Body_Search/Post_filter.md Request_Body_Search/Highlighting.md Request_Body_Search/Rescoring.md Request_Body_Search/Search_Type.md Request_Body_Search/Scroll.md Request_Body_Search/Preference.md Request_Body_Search/Explain.md Request_Body_Search/Version.md Request_Body_Search/Index_Boost.md Request_Body_Search/min_score.md Request_Body_Search/Named_Queries.md Request_Body_Search/Inner_hits.md Request_Body_Search/Field_Collapsing.md Request_Body_Search/Search_After.md Request_Body_Search/Request_Body_Search.md Search_Template.md Multi_Search_Template.md Search_Shards_API.md Suggesters/Term_suggester.md Suggesters/Phrase_Suggester.md Suggesters/Completion_Suggester.md Suggesters/Context_Suggester.md Suggesters/Returning_the_type_of_the_suggester.md Suggesters/Suggesters.md Multi_Search_API.md Count_API.md Validate_API.md Explain_API.md Profile_API/Profiling_Queries.md Profile_API/Profiling_Aggregations.md Profile_API/Profiling_Considerations.md Profile_API/Profile_API.md Percolator.md Field_stats_API.md Field_Capabilities_API.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
