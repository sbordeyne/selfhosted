# Ansible

Directory for the ansible playbooks required to setup the cluster in a declarative way.

These playbooks are in charge of:

- Installing kubernetes
- Making worker nodes join the cluster
- Installing an NFS server on nodes
- Installing PostgreSQL on nodes
- Bootstrapping the kubernetes cluster by:
  - Adding and synchronizing a ConfigMap in the kube-system namespace for NFS server IPs
  - Adding and synchronizing a ConfigMap in the kube-system namespace for PostgreSQL server IPs

The playbook is made idempotent, running it twice should not affect the state of the nodes after
the initial run.

## Host variables

<!-- TODO -->
