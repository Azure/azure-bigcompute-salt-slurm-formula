slurm formula
================
0.0.3 (??????????)
 - ported to Ubuntu
 - fix munge issues with /var/log permission on Ubuntu 16.04
 - consistent state ID names that shouldn't clash with other states
 - move checkpointing to separate state
 - sorted out client state so it works
 - munge installation is now mandatory even if its use is not
 - creating slurm user is optional and default false
 - munge key created from base64 pillar value
 - deleted unused defaults.yaml
 - annotated config files as being managed by salt
 - slurmctld machines are not necessarily nodes
 - node-associated config files, e.g. cgroup.conf, are now in node.sls
 - cgroup use is now based on a map.jinja variable
 - packages for node and server
 - sorted out default locations for logs, pid files etc
 - pulled out mysql server setup
 - pulled out stuff that set up config on the salt minion!
 - slurmdbd config is in the slurmdbd pillar space
 - default slurmdbd storage type is mysql
 - default slurmdbd host localhost
 - put state files in somewhere more sensible than /tmp
0.0.2 (2015-12-14)
 - munge dependences repared
 - slurmd macro repared
 - delete old services pathc
 - addded new configuration denpendecis on slurm.conf
 - new reload method for slurmd and slurmctrl
 - mpi suport congi
 - new reload slurmd
0.0.1 (2015-03-03)
 - Initial version
