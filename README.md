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


## Orchestration / Installation runbook

- Install ansible dependencies: `ansible-galaxy install -r ansible/requirements.yaml`
- (Optional) Edit the `ansible/inventory.yaml` file with your custom variables
- Run ansible playbook `ansible-playbook -i ansible/inventory.yaml ansible/playbook.yaml`
- Wait for the setup to complete, you should be able to connect with `kubectl` to the cluster
- Run `kubectl apply -k clusters/kubernetes/flux-system`
  - This will bootstrap fluxcd, and start deploying the manifests in this repo
  - /!\ Vault will need to be unsealed before everything can run properly. /!\
  - Flux will then deploy operators from the `clusters/kubernetes/operators` directory
  - Flux will then plan and apply terraform manifests from the `clusters/kubernetes/terraform` directory
    - The terraform workspaces live under `terraform/workspaces`
  - Flux will then deploy the apps from the `clusters/kubernetes/apps` directory

All of the secrets are in the vault instance running locally on the cluster, except for:

- Vault unseal keys (obtained with `kubectl exec -ti vault-0 -n vault -- vault operator init`)
- Vault root token

## Scripts

Scripts living in the `scripts/` directory are helper scripts writtent for CI purposes, or to help manage the cluster.


## Docker

The `docker/` directory contains Dockerfiles to build custom images for some of the services running in the cluster, namely:

- `docker/keycloak`: keycloak instance on the cluster. Built in advance to speed up pod start time
- `docker/tf-runner`: terraform runner on the instance, to keep it up to date with upstream terraform releases

## CI/CD

- `.github/workflows/ansible-lint.yaml`: lints the ansible files in the `ansible` subdirectory
- `.github/workflows/build-docker-images.yaml`: workflow that builds the images in the `docker` directory and pushes them to `ghcr.io`
- `.github/workflows/check-file-names.yaml`: Enforces the convention `<kind>-<metadata.name>` on the kubernetes manifests in this directory.
- `.github/workflows/kube-lint.yaml`: kubernetes linter to enforce best practices
- `.github/workflows/update-flux.yaml`: flux updater through the official github action

In addition, renovate is also installed on this repo, the config being at `renovate.json`

In the future, there will be workflows for:
- Terraform lint
- Terraform docs
- Bash script linting / testing

## Development environment

<!-- TODO: use nix-->

Run `nix shell`

Tools required:

- `kubectl`
- `helm`
- `yq`
- `jq`
- `flux`
- `ansible-galaxy`
- `just`
- `ansible-playbook`
- `docker`
- `d2`
- `yamllint`
- `yamlfix`
- `kube-lint`
- `terraform`
- `terraform-docs`

## Outside secrets

- `secrets/cloudflare/credentials`:
  - `email`: CloudFlare account Email
  - `token`: CloudFlare API token
  - `api_key`: CloudFlare API key
- `secrets/anticaptcha/credentials`:
  - `email`: AntiCaptcha account Email
  - `api_key`: AntiCaptcha API key
- `secrets/borgbase/credentials`
  - `api_key`: Borgbase API key (Full Access)
