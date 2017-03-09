## SLURM log file setup

{% from "slurm/map.jinja" import slurm with context %}

slurm_logdir:
  file.directory:
    - name: {{ slurm.logdir }}
    - user: slurm
    - group: slurm
    - mode: '0755'

