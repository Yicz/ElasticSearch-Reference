#!/bin/sh

dirNames=(Breaking_changes_in_5.2 Breaking_changes_in_5.0 )
files=(Breaking_changes_in_5.4.md Breaking_changes_in_5.3.md Breaking_changes_in_5.2/Shadow_Replicas_are_deprecated.md Breaking_changes_in_5.2/Breaking_changes_in_5.2.md Breaking_changes_in_5.1.md Breaking_changes_in_5.0/Search_and_Query_DSL_changes.md Breaking_changes_in_5.0/Mapping_changes.md Breaking_changes_in_5.0/Percolator_changes.md Breaking_changes_in_5.0/Suggester_changes.md Breaking_changes_in_5.0/Index_APIs_changes.md Breaking_changes_in_5.0/Document_API_changes.md Breaking_changes_in_5.0/Settings_changes.md Breaking_changes_in_5.0/Allocation_changes.md Breaking_changes_in_5.0/HTTP_changes.md Breaking_changes_in_5.0/REST_API_changes.md Breaking_changes_in_5.0/CAT_API_changes.md Breaking_changes_in_5.0/Java_API_changes.md Breaking_changes_in_5.0/Packaging.md Breaking_changes_in_5.0/Plugin_changes.md Breaking_changes_in_5.0/Filesystem_related_changes.md Breaking_changes_in_5.0/Path_to_data_on_disk.md Breaking_changes_in_5.0/Aggregation_changes.md Breaking_changes_in_5.0/Script_related_changes.md Breaking_changes_in_5.0/Breaking_changes_in_5.0.md )

for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
