##
##
##



##_META
##



## <JINJA>
{% from tpldir ~ "/map.jinja" import var_dct with context %}
## </JINJA>



# notes on Implementation Status
{#-
#}



#
"data_validation_var_dct":
  test.succeed_without_changes:
    - name: {{ var_dct|tojson }}



#
"data_validation_fluentd":
  test.succeed_without_changes:
    - name: {{ var_dct.fluentd|tojson }}



#
"data_validation_fluentd_service":
  test.succeed_without_changes:
    - name: {{ var_dct.fluentd.service|tojson }}



#
"data_validation_list_mangaged_config_keys":
  test.succeed_without_changes:
    - name: {{ var_dct.fluentd.configs|map(attribute='name')|list }}



#
"data_validation_list_existing_config_files_basename":
  test.succeed_without_changes:
    - name: {{ salt["file.find"](var_dct.fluentd.conf_dir ~ "/*.conf")|map('regex_replace', '.*\/(.*)\.conf', '\\1')|list|tojson }}



#
"data_validation_list_config_files_to_disable":
  test.succeed_without_changes:
    - name: {{ var_dct.fluentd.config_exists_lst|difference(var_dct.fluentd.config_managed_lst)|tojson }}



#
"data_validation_list_config_files_to_remove":
  test.succeed_without_changes:
    - name: {{ salt['file.find'](var_dct.fluentd.conf_dir ~ "/*.config.disabled") }}



#
"data_validate_managed_conf_lst":
  test.succeed_without_changes:
    - name: {{ var_dct.fluentd.configs|map(attribute='name')|list }}



## EOF
