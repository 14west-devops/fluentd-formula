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
    - require_in:
      - gem: install_fluentd_plugins
{% endif %}



#
{% if var_dct.fluentd.install_method == "rubygem" %}
install_fluentd_plugins:
  gem.installed:
    - names: {{ var_dct.fluentd.plugins }}
    - require:
      - file: configure_fluentd
    - watch_in:
        service: start_fluentd_service
{%- endif %}



## EOF
