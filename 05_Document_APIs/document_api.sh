#!/bin/sh
dirNames=()
files=(Reading_and_Writing_documents.md Index_API.md Get_API.md Delete_API.md Delete_By_Query_API.md Update_API.md Update_By_Query_API.md Multi_Get_API.md Bulk_API.md Reindex_API.md Term_Vectors.md Multi_termvectors_API.md ?refresh.md )

for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
