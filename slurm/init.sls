{% from "slurm/map.jinja" import slurm with context %}

client:
  pkg.installed:
    - name: {{ slurm.pkgSlurm }}
    - pkgs:
      - {{ slurm.pkgSlurm }}
      {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - {{ slurm.pkgSlurmMuge }}
      {% endif %}
      - {{ slurm.pkgSlurmPlugins }}
    - refresh: True
  file.managed:
    - name: {{ slurm.config }}
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja 
    - source: salt://slurm/files/slurm.conf

  user.present:
    - name: slurm
    - home: /localhome/slurm
    - uid: 550
    - gid: 510
    - gid_from_name: True

    
{{ slurm.env }}:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://slurm/files/slurmd
    
#because the rpm not create directory
/var/run/slurm/:
  file.directory:
    - name: 
    - user: slurm
    - group: root
    - makedirs: true


{%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
munge:
  pkg:
   - installed
  service:
    - running
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
topolgy:
  file.managed:
    - name: /etc/slurm/topology.conf
    - user: slurm
    - group: root
    - mode: '0644'
    - source: salt://slurm/files/topology.conf
    - require:
      - pkg: {{ slurm.pkgSlurm }}
{% endif %}

{% if salt['pillar.get']('slurm:TaskPlugin') in ['cgroup'] -%}
cgroup::
  file.managed:
    - name: /etc/slurm/cgroup.conf   
    - user: slurm
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://slurm/files/cgroup.conf 
{% endif %}


{% if salt['pillar.get']('slurm:AcctGatherEnergyType') in ['none','ipmi','ibmaem','cray','rapi'] -%}
config_energy:
  file.managed:
    - name: /etc/slurm/acct_gather.conf
    - user: slurm
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://slurm/files/acct_gather.conf
{% endif %}
