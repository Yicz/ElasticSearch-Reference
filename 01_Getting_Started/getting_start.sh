#!/bin/sh

files=(Basic_Concepts Installation Conclusion) 
dirNames=(Exploring_Your_Cluster Modifying_Your_Data Exploring_Your_Data)
Exploring_Your_Cluster_files=(Cluster_Health List_All_Indices Create_an_Index Index_and_Query_a_Document Delete_an_Index) 
Modifying_Your_Data_files=(Updating_Documents Deleting_Documents Batch_Processing) 
Exploring_Your_Data_files=(The_Search_API Introducing_the_Query_Language Executing_Searches Executing_Filters Executing_Aggregations)

for file in ${files[@]}
do
	touch $file
	echo "To be Continue!">$file
done

for dirName in ${dirNames[@]}
do
	mkdir $dirName
	if [ $dirName == "Exploring_Your_Cluster" ]
	then
		for file in ${Exploring_Your_Cluster_files[@]}
		do
			touch "$dirName/$file"
			echo "To be Continue!">"$dirName/$file"
		done
	fi

	if [ $dirName == "Modifying_Your_Data" ]
	then
		for file in ${Modifying_Your_Data_files[@]}
		do
			touch "$dirName/$file"
			echo "To be Continue!">"$dirName/$file"
		done
	fi


	if [ $dirName == "Exploring_Your_Data" ]
	then
		for file in ${Exploring_Your_Data_files[@]}
		do
			touch "$dirName/$file"
			echo "To be Continue!">"$dirName/$file"
		done
	fi
done

