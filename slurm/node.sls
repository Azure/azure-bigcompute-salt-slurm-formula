## SLURM compute node config

{% from "slurm/map.jinja" import slurm with context %}

include:
  - slurm
  - slurm.logdir

slurm_node:
  {% if slurm.pkgSlurmNode is defined %}
  pkg.installed:
    - name: {{ slurm.pkgSlurmNode }}
  {% endif %}
  service.running:
    - name: {{ slurm.slurmd }}
    - enable: True
    - require:
      - file: slurm_config
      - file: slurm_logdir
      {%  if salt['pillar.get']('slurm:AuthType', 'munge') == 'munge' %}
      - service: munge
      {%endif %}

slurm_node_default:
  file.managed:
    - name: /etc/default/{{slurm.slurmd}}
    - require:
      - pkg: slurm_node
    - require_in:
      - service: slurm_node

slurm_node_state:
  file.directory:
    - name: {{slurm.slurmddir}}
    - require:
        - pkg: slurm_node
    - require_in:
        - service: slurm_node
    - user: slurm
    - group: slurm
    - mode: '0755'
    - makedirs: true



{% if slurm.use_cgroup %}
slurm_cgroup::
  file.managed:
    - name: {{slurm.etcdir}}/cgroup.conf 
    - user: slurm
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://slurm/files/cgroup.conf.jinja
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
    - source: salt://slurm/files/topology.conf.jinja
    - context:
        slurm: {{ slurm }}
    - require:
      - pkg: {{ slurm.pkgSlurm }}
{% endif %}


slurm_config_energy:
  file.managed:
    - name: {{slurm.etcdir}}/acct_gather.conf
    - user: slurm
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://slurm/files/acct_gather.conf.jinja
    - context:
        slurm: {{ slurm }}
    - require:
      - pkg: slurm_client

