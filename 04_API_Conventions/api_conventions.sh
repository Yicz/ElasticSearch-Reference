#!/bin/sh

dirNames=()

files=(Multiple_Indices.md Date_math_support_in_index_names.md Common_options.md URL-based_access_control.md )

for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
