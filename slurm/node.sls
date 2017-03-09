{% from "slurm/map.jinja" import slurm with context %}

include:
  - slurm

slurm_node:
  {% if slurm.pkgSlurmNode is defined %}
  pkg.installed:
    - name: {{ slurm.pkgSlurmNode }}
  {% endif %}
  service.running:
    - enable: True
    - name: {{ slurm.slurmd }}
    - reload: False
    - require:
      - file: slurm_config
      - file: slurm_logdir
      {%  if salt['pillar.get']('slurm:AuthType', 'auth/munge') == 'auth/munge' %}
      - service: munge
      {%endif %}

slurm_logdir:
  file.directory:
    - name: {{ slurm.logdir }}
    - user: slurm
    - group: slurm
    - mode: '0755'
