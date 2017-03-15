slurm formula
================
0.0.3 (??????????)
 - ported to Ubuntu
 - way more config file options and much more sensible defaults
 - fix munge issues with /var/log permission on Ubuntu 16.04
 - pulled out mysql server setup
 - pulled out stuff that set up config on the salt minion!
 - sorted out map.jinja pkg* - now lists and renamed
 - renamed slurm.slurmdbd to slurm.db
 - new slurm.devel and slurm.db_devel states
 - munge key created from base64 pillar value
 - put state files in somewhere more sensible than /tmp
 - slurmdbd config is in the slurm.db pillar space
 - packages for node and server
 - sorted out default locations for logs, pid files etc
 - cgroup use is now based on a map.jinja variable
 - node-associated config files, e.g. cgroup.conf, are now in node.sls
 - slurmctld machines are not necessarily nodes
 - consistent state ID names that shouldn't clash with other states
 - move checkpointing to separate state
 - renamed template sources
 - sorted out client state so it works
 - munge installation is now mandatory even if its use is not
 - creating slurm user is optional and default false
 - deleted unused defaults.yaml
 - annotated config files as being managed by salt
 - default slurmdbd storage type is mysql
 - default slurmdbd host localhost
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
