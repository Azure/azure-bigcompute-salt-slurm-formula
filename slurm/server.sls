## SLURM control daemon config

{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm

slurm_server:
  {% if slurm.pkgSlurmServer is defined %}
  pkg.installed:
    - name: {{ slurm.pkgSlurmServer }}
  {% endif %}
  service.running:
    - enable: True
    - name: {{ slurm.slurmctld }}
    - require:
      - file: slurm_config
      - file: slurm_logdir
      {%  if salt['pillar.get']('slurm:AuthType', 'munge') == 'munge' %}
      - service: munge
      {%endif %}


{########

slurm_server_log:
  file.managed:
    - name: {{ salt['pillar.get']('slurm:SlurmctldLogFile','/var/log/slurm/slurmctld.log') }}
    - user: slurm
    - group: slurm
    - dir_user: slurm
    - file_mode: 755
    - dir_mode: 777
    - makedirs: True

###########}

slurm_server_default:
  file.managed:
    - name: /etc/default/{{slurm.slurmctld}}
    - require:
      - pkg: slurm_server
    - require_in:
      - service: slurm_server


slurm_server_reload:
  cmd.run:
    - name: {{ slurm.scontrol }} reconfigure
    - require:
      - file: {{ slurm.config }}
    - onchanges:
      - file: {{ slurm.config }}
