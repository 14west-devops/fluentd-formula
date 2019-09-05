##
##
##



##_META
##



## <JINJA>
{% from tpldir ~"/map.jinja" import var_dct with context %}
## </JINJA>



# http://packages.treasuredata.com/3/redhat/\$releasever/\$basearch
fluentd:
  pkgrepo.managed:
    - humanname: Fluentd Repository
    {% if grains['os_family'] == 'Debian' %}
    - name: deb http://packages.treasuredata.com/3/{{ grains['os'].lower() }}/{{ grains['oscodename'] }}/ {{ grains['oscodename'] }} contrib
    - file: /etc/apt/sources.list.d/fluentd.list
    - key_url: https://packages.treasuredata.com/GPG-KEY-td-agent
    {% elif grains['os_family'] == 'RedHat' %}
    - baseurl: http://packages.treasuredata.com/3/redhat/{{ grains['osrelease_info'][0] }}/{{ grains['cpuarch'] }}
    - gpgcheck: 1
    - gpgkey: https://packages.treasuredata.com/GPG-KEY-td-agent
    {% endif %}



#
install_fluentd:
  pkg.installed:
    - name: td-agent
    - require:
      - pkgrepo: fluentd



#
make_fluent_config_directory:
  file.directory:
    - name: {{ var_dct.fluentd.conf_dir }}
    - makedirs: True 
    - require:
      - pkg: install_fluentd



## EOF
