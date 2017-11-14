#!/bin/sh

dirNames=(Full_text_queries Term_level_queries Compound_queries Joining_queries Geo_queries Specialized_queries Span_queries )
files=(Query_and_filter_context.md Match_All_Query.md Full_text_queries/Match_Query.md Full_text_queries/Match_Phrase_Query.md Full_text_queries/Match_Phrase_Prefix_Query.md Full_text_queries/Multi_Match_Query.md Full_text_queries/Common_Terms_Query.md Full_text_queries/Query_String_Query.md Full_text_queries/Simple_Query_String_Query.md Full_text_queries/Full_text_queries.md Term_level_queries/Term_Query.md Term_level_queries/Terms_Query.md Term_level_queries/Range_Query.md Term_level_queries/Exists_Query.md Term_level_queries/Prefix_Query.md Term_level_queries/Wildcard_Query.md Term_level_queries/Regexp_Query.md Term_level_queries/Fuzzy_Query.md Term_level_queries/Type_Query.md Term_level_queries/Ids_Query.md Term_level_queries/Term_level_queries.md Compound_queries/Constant_Score_Query.md Compound_queries/Bool_Query.md Compound_queries/Dis_Max_Query.md Compound_queries/Function_Score_Query.md Compound_queries/Boosting_Query.md Compound_queries/Indices_Query.md Compound_queries/Compound_queries.md Joining_queries/Nested_Query.md Joining_queries/Has_Child_Query.md Joining_queries/Has_Parent_Query.md Joining_queries/Parent_Id_Query.md Joining_queries/Joining_queries.md Geo_queries/GeoShape_Query.md Geo_queries/Geo_Bounding_Box_Query.md Geo_queries/Geo_Distance_Query.md Geo_queries/Geo_Distance_Range_Query.md Geo_queries/Geo_Polygon_Query.md Geo_queries/Geo_queries.md Specialized_queries/More_Like_This_Query.md Specialized_queries/Template_Query.md Specialized_queries/Script_Query.md Specialized_queries/Percolate_Query.md Specialized_queries/Specialized_queries.md Span_queries/Span_Term_Query.md Span_queries/Span_Multi_Term_Query.md Span_queries/Span_First_Query.md Span_queries/Span_Near_Query.md Span_queries/Span_Or_Query.md Span_queries/Span_Not_Query.md Span_queries/Span_Containing_Query.md Span_queries/Span_Within_Query.md Span_queries/Span_Field_Masking_Query.md Span_queries/Span_queries.md Minimum_Should_Match.md Multi_Term_Query_Rewrite.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
