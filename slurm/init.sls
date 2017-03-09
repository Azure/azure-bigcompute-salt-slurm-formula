## SLURM common config

{% from "slurm/map.jinja" import slurm with context %}

slurm_client:
  pkg.installed:
    - pkgs:
      - {{ slurm.pkgSlurm }}
      - {{ slurm.pkgSlurmPlugins }}
    - refresh: True

slurm_config:
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
slurm_user:
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
        - file: slurm_topology
        - file: slurm_cgroup
        - file: slurm_config_energy
{% endif %}

    

slurm_munge:
  pkg.installed:
    - name: {{ slurm.pkgMunge }}

slurm_munge_key64:
  file.managed:
    - name: /etc/munge/munge.key64
    - user: munge
    - group: munge
    - mode: '0400'
    - contents_pillar: slurm:MungeKey64
    - require:
        - pkg: slurm_munge

slurm_munge_key:
  cmd.wait:
    - name: base64 -d /etc/munge/munge.key64 >/etc/munge/munge.key
    - watch:
        - file: /etc/munge/munge.key64
  file.managed:
    - name: /etc/munge/munge.key
    - requre:
        - cmd: slurm_munge_key
    - replace: false
    - mode: '0400'

slurm_munge_service:
  service.running:
    - name: munge
    - enambe: true
    - watch:
      - file: slurm_munge_key
    - require:
      - pkg: slurm_munge
    - require_in:
      - pkg: slurm_client


## The default Ubuntu 16.04 version of munge breaks because of permissions
## on /var/log/.  We have to override this with --force at service startup
## time.  We need to install this before the package as the package
## tries to start itself.

{% if grains.os=='Ubuntu' and grains.osrelease=='16.04' %}
slurm_munge_service_config:
  file.managed:
    - name: /etc/systemd/system/munge.service
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://slurm/files/munge.service
    - require_in:
        - pkg: slurm_munge
{% endif %}

