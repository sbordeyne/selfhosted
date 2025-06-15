# selfhosted

Flux v2 repository for my self hosted stack. Everything runs with kubernetes on Debian 12 nodes.

## Stack

- Flux: GitOps controller for kubernetes
- GitHub Actions:
  - build-docker-images.yaml: builds the docker images with buildx for the customizations this repo needs
- Terraform: terraform workspaces and modules to configure the stack before / after a deployment
- Ansible: configure master/worker kubernetes nodes from my laptop.

## Operators

- cert-manager: for certificate generation for ingresses mostly
- external-dns: to manage local and remote DNS records
- external-secrets: to centralize secret management in Hashicorp Vault
- kyverno: to write cluster policies for automated backups to borgbackup
- victoriametrics: for perfomant monitoring
- flux-iac/tofu-controller: gitops'd terraform for configuration of my self-hosted stack
