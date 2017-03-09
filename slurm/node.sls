{% from "slurm/map.jinja" import slurm with context %}

include:
  - slurm

slurm_node:
{% if slurm.pkgSlurmNode is defined %}
  pkg.installed:
    - name: {{ slurm.pkgSlurmNode }}
{% endif %}
  file.directory:
    - name: /var/log/slurm/
    - user: slurm
    - group: slurm
  service.running:
    - enable: True
    - name: {{ slurm.slurmd }}
    - reload: False
    - require:
      - pkg: {{  slurm.pkgSlurm }}
      {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - service: munge
      {%endif %}

