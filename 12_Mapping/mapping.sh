#!/bin/sh

dirNames=(Field_datatypes Meta-Fields Mapping_parameters Dynamic_Mapping )
files=(Field_datatypes/Array_datatype.md Field_datatypes/Binary_datatype.md Field_datatypes/Range_datatypes.md Field_datatypes/Boolean_datatype.md Field_datatypes/Date_datatype.md Field_datatypes/Geo-point_datatype.md Field_datatypes/Geo-Shape_datatype.md Field_datatypes/IP_datatype.md Field_datatypes/Keyword_datatype.md Field_datatypes/Nested_datatype.md Field_datatypes/Numeric_datatypes.md Field_datatypes/Object_datatype.md Field_datatypes/String_datatype.md Field_datatypes/Text_datatype.md Field_datatypes/Token_count_datatype.md Field_datatypes/Percolator_type.md Field_datatypes/Field_datatypes.md Meta-Fields/_all_field.md Meta-Fields/_field_names_field.md Meta-Fields/_id_field.md Meta-Fields/_index_field.md Meta-Fields/_meta_field.md Meta-Fields/_parent_field.md Meta-Fields/_routing_field.md Meta-Fields/_source_field.md Meta-Fields/_type_field.md Meta-Fields/_uid_field.md Meta-Fields/Meta-Fields.md Mapping_parameters/analyzer.md Mapping_parameters/normalizer.md Mapping_parameters/boost.md Mapping_parameters/coerce.md Mapping_parameters/copy_to.md Mapping_parameters/doc_values.md Mapping_parameters/dynamic.md Mapping_parameters/enabled.md Mapping_parameters/fielddata.md Mapping_parameters/format.md Mapping_parameters/ignore_above.md Mapping_parameters/ignore_malformed.md Mapping_parameters/include_in_all.md Mapping_parameters/index.md Mapping_parameters/index_options.md Mapping_parameters/fields.md Mapping_parameters/norms.md Mapping_parameters/null_value.md Mapping_parameters/position_increment_gap.md Mapping_parameters/properties.md Mapping_parameters/search_analyzer.md Mapping_parameters/similarity.md Mapping_parameters/store.md Mapping_parameters/term_vector.md Mapping_parameters/Mapping_parameters.md Dynamic_Mapping/_default__mapping.md Dynamic_Mapping/Dynamic_field_mapping.md Dynamic_Mapping/Dynamic_templates.md Dynamic_Mapping/Override_default_template.md Dynamic_Mapping/Dynamic_Mapping.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
