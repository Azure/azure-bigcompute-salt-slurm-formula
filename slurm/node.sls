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

{% if slurm.use_cgroup %}
slurm_cgroup::
  file.managed:
    - name: {{slurm.etcdir}}/cgroup.conf   
    - user: slurm
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://slurm/files/cgroup.conf 
    - context:
        slurm: {{ slurm }}
    - require_in:
      - service: slurm_node
{% endif %}


{% if salt['pillar.get']('slurm:TopologyPlugin') in ['tree','3d_torus'] -%}
slurm_topolgy:
  file.managed:
    - name: {{slurm.etcdir}}/topology.conf
    - user: slurm
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://slurm/files/topology.conf
    - context:
        slurm: {{ slurm }}
    - require:
      - pkg: {{ slurm.pkgSlurm }}
{% endif %}


{% if salt['pillar.get']('slurm:AcctGatherEnergyType') in ['none','ipmi','ibmaem','cray','rapi'] -%}
slurm_config_energy:
  file.managed:
    - name: {{slurm.etcdir}}/acct_gather.conf
    - user: slurm
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://slurm/files/acct_gather.conf
    - context:
        slurm: {{ slurm }}
    - require:
      - pkg: slurm_client
{% endif %}
