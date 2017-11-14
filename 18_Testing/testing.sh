#!/bin/sh

dirNames=(Java_Testing_Framework )
files=(Java_Testing_Framework/why_randomized_testing?.md Java_Testing_Framework/Using_the_elasticsearch_test_classes.md Java_Testing_Framework/unit_tests.md Java_Testing_Framework/integration_tests.md Java_Testing_Framework/Randomized_testing.md Java_Testing_Framework/Assertions.md Java_Testing_Framework/Java_Testing_Framework.md )




for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
