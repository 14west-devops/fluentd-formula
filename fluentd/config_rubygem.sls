##
##
##



##_META
##



## <JINJA>
{% from "fluentd/map.jinja" import var_dct with context %}
## </JINJA>



#
{% for config in var_dct.fluentd.configs %}
add_fluent_{{ config.name }}_config:
  file.managed:
    - name: /etc/fluent/fluent.d/{{ config.name }}.conf
    - source: salt://fluentd/templates/fluent-config-template.conf
    - template: jinja
    - context:
        settings: {{ config.settings | tojson }}
    - watch_in:
        - service: reload_fluentd_service
{% endfor %}



#
{% for name, path in var_dct.fluentd.persistent_directories.items()|default({}, True) %}
create_directory_for_{{ name }}_logs:
  file.directory:
   - name: {{ path }}
   - makedirs: True
   - user: {{ var_dct.fluentd.user }}
   - group: {{ var_dct.fluentd.group }}
   - recurse:
     - user
     - group
{% endfor %}



#
reload_fluentd_service:
  service.running:
    - name: fluentd
    - enable: True
    - reload: True



## EOF
