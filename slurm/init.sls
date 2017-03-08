{% from "slurm/map.jinja" import slurm with context %}

slurm_client:
  pkg.installed:
    - pkgs:
      - {{ slurm.pkgSlurm }}
      {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - {{ slurm.pkgSlurmMuge }}
      {% endif %}
      - {{ slurm.pkgSlurmPlugins }}
    - refresh: True
  file.managed:
    - name: {{slurm.etcdir}}/slurm.conf
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja 
    - source: salt://slurm/files/slurm.conf
    - context:
        slurm: {{ slurm }}

{% if slurm.user_create|default(False) == True %}
  user.present:
    - name: slurm
{% if slurm.homedir is defined %}
    - home: {{ slurm.user_homedir }}
{% endif %}
{% if slurm.user_uid is defined %}
    - uid: {{ slurm.user_uid }}
{% endif %}
{% if slurm.user_gid is defined %}
    - gid: {{ slurm.user_gid }}
{% else %}
    - gid_from_name: True
{% endif %}
    - require_in:
        - pkg: slurm_client
{% endif %}

    

{%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
slurm_munge:
  pkg:
    - name: {{ slurm.pkgMunge }}
  service:
    - name: munge
    - enable: True
    - reload: True
    - watch:
      - file: /etc/munge/munge.key
    - require:
      - pkg: {{ slurm.pkgMunge }}
      - file: /etc/munge/munge.key
  file.managed:
    - name: /etc/munge/munge.key
    - user: munge
    - group: munge
    - mode: 400
    - template: jinja
    - source: salt://slurm/files/munge.key 
    - require:
      - pkg: {{ slurm.pkgMunge }}
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

{% if salt['pillar.get']('slurm:TaskPlugin') in ['cgroup'] -%}
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
    - require:
      - pkg: slurm_client
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
