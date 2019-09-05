##
##
##



##_META
##



## <JINJA>
{%- from tpldir ~ '/map.jinja' import var_dct with context %}
## </JINJA>



#
{% if var_dct.fluentd.plugin_dependencies %}
install_fluentd_plugin_dependencies:
  pkg.installed:
    - pkgs: {{ var_dct.fluentd.plugin_dependencies }}
    - refresh: True
{% endif %}



#
{% for plugin in var_dct.fluentd.plugins|default({}, True) %}
install_fluentd_plugin_{{ plugin }}:
  cmd.run:
    - name: td-agent-gem install {{ plugin }}
    - unless: td-agent-gem list {{ plugin }} -i
    - require:
      - file: configure_fluentd
    - watch_in:
        service: start_fluentd_service
{% endfor %}



## EOF
