##
##
##



##_META
##



## <JINJA>
{%- from tpldir ~ '/map.jinja' import var_dct with context %}
{%- do raise('you\'ve selected an unknown install method')
    if var_dct.fluentd.install_method not in var_dct.fluentd.install_method_lst
%}
## </JINJA>



#
include:
  - .install_{{ var_dct.fluentd.install_method }}
  - .config_{{ var_dct.fluentd.install_method }}
  - .plugins_{{ var_dct.fluentd.install_method }}



## EOF
