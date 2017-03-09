{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm

server_log_file:
  file.managed:
    - name: {{ salt['pillar.get']('slurm:SlurmctldLogFile','/var/log/slurm/slurmctld.log') }}
    - user: slurm
    - group: slurm
    - dir_user: slurm
    - file_mode: 755
    - dir_mode: 777
    - makedirs: True
    - require:
    {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - pkg: {{ slurm.pkgMunge }}
    {% endif %}
      - user: slurm

Bug_rpm_no_create_default_environment:
  file.touch:
    - name: /etc/default/slurmctld
    - onlyif:  'test ! -e /etc/default/slurmctld'

server:
  service.running:
    - name: slurmctld
    - enable: True
    - reload: False
    - require:
      - file: Bug_rpm_no_create_default_environment

reload_slurmctld:
  cmd.run:
    - name: {{ slurm.scontrol }} reconfigure
    - require:
      - file: {{ slurm.config }}
    - onchanges:
      - file: {{ slurm.config }}
