##
##
##



##_META
##



## <JINJA>
{% from tpldir ~"/map.jinja" import var_dct with context %}
## </JINJA>



#
install_fluentd_dependencies:
  pkg.installed:
    - pkgs: {{ fluentd.pkgs }}
    - update: True



#
install_fluentd_gem:
  gem.installed:
    - name: fluentd
    {% if fluentd.version %}
    - version: {{ fluentd.version }}
    {% endif %}



#
create_fluentd_user:
  user.present:
    - name: {{ fluentd.user }}
    - createhome: False
    - system: True



#
create_fluentd_group:
  group.present:
    - name: {{ fluentd.group }}
    - addusers:
        - {{ fluentd.user }}
    - system: True



#
configure_fluentd:
  file.managed:
    - name: /etc/fluent/fluent.conf
    - source: salt://fluentd/templates/fluent.conf
    - makedirs: True
    - user: {{ fluentd.user }}
    - group: {{ fluentd.group }}
    - template: jinja
    - context:
        log_level: {{ fluentd.global_log_level }}



#
fluentd_control_script:
  file.managed:
    - name: /usr/local/bin/fluentd.sh
    - source: salt://fluentd/files/fluentd.sh
    - mode: 0755
    - user: {{ fluentd.user }}
    - group: {{ fluentd.group }}



#
configure_fluentd_service:
  file.managed:
    - name: {{ fluentd_service.destination_path }}
    - source: salt://fluentd/files/{{ fluentd_service.source_path }}
    - context:
        user: {{ fluentd.user }}
        group: {{ fluentd. group }}



#
make_fluent_config_directory:
  file.directory:
    - name: {{ fluentd.conf_dir }}
    - makedirs: True 
    - require:
      - gem: install_fluentd_gem



## EOF
