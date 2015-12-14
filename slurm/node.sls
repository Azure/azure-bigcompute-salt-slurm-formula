{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm

slurm_service:
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

{% if salt['pillar.get']('slurm:CheckpointType') == 'blcr' -%}
Install_pkg_checkpoint:
  pkg.installed:
    - pkgs:
      - slurm-blcr
      - blcr
{% endif %}

Bash_environment_mpi:
  file.managed:
    - name: /etc/profile.d/mpi.sh
    - user: root
    - group: root
    - mode: '644'
    - source: salt://slurm/files/profile_mpi.sh

