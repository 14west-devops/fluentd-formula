##
##
##



##_META
##



## <JINJA>
{%- from tpldir ~ "/map.jinja" import var_dct with context %}
## </JINJA>



#
configure_fluentd:
  file.managed:
    - name: {{ var_dct.fluentd.conf_file }}
    - source: salt://fluentd/templates/fluent.conf
    - makedirs: True
    - template: jinja
    - context:
        log_level: {{ var_dct.fluentd.global_log_level }}
        conf_dir: {{ var_dct.fluentd.conf_dir }}
    - watch_in:
        service: start_fluentd_service



#
{% for config in var_dct.fluentd.configs %}
add_fluent_{{ config.name }}_config:
  file.managed:
    - name: {{ var_dct.fluentd.conf_dir }}/{{ config.name }}.conf
    - source: salt://fluentd/templates/fluent-config-template.conf
    - template: jinja
    - context:
        settings: {{ config.settings }}
    - watch_in:
        service: start_fluentd_service
{% endfor %}



#
{%- for config_name in var_dct.fluentd.config_exists_lst|difference(var_dct.fluentd.config_managed_lst) %}
disable_unmanaged_config:
  file.rename:
    - name: {{ var_dct.fluentd.conf_dir }}/{{ config_name }}.conf.disabled
    - source: {{ var_dct.fluentd.conf_dir }}/{{ config_name }}.conf
    - onlyif: {{ "true" if var_dct.fluentd.config_disable_unmanaged|default(False, True) else "false" }}
{%- endfor %}



#
remove_disabled_config:
  file.tidied:
    - name: {{ var_dct.fluentd.conf_dir }}
    - matches:
      - '.*\.conf\.disabled'
    - onlyif: {{ "true" if var_dct.fluentd.config_remove_disabled|default("false", True) else "false" }}



#
start_fluentd_service:
  service.running:
    - name: {{ var_dct.fluentd.service.unit_name }}
    - enable: True
    - require:
      - pkg: install_fluentd



## EOF
