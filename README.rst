=====
slurm
=====

Install the SLURM client, node, controller or database daemon.

.. note::

   The original version was tested under CentOS 7.  The port to
   Unbuntu 16.04 was a considerable change, including removal of the
   code that sets up a mariadb servers.  It should still work under Centos 7.
   
   See the full `Salt Formulas installation and usage instructions
   <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:


``slurm``
---------

Install the basic configuration for a client.  Note this is just
for e.g. a head node and does not include the execution daemon.


``slurm.node``
--------------

Configure and install compute node.


``slurm.server``
----------------

Install and configure the control daemon.


``slurm.db``
------------------

Install and configure database daemon.


``slurm.devel``
------------------

Install and configure SLURM development packages.


``slurm.db_devel``
------------------

Install and configure SLURM database development packages.

