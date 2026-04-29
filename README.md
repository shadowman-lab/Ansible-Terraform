<!-- This was created with Claude Code -->

# Terraform Automation

[![Contribute](https://img.shields.io/badge/OpenShift-Dev%20Spaces-525C86?logo=redhatopenshift&labelColor=EE0000)](https://devspaces.apps.ocp.shadowman.dev/#https://github.com/shadowman-lab/Ansible-Terraform)


This directory contains Ansible automation for terraform management and operations.

## Overview

The Terraform automation provides playbooks and roles for managing and configuring
terraform infrastructure and services.

## Roles

| Role | Description |
| ---- | ----------- |
| [shadowman_hostnameset](roles/shadowman_hostnameset/README.md) | Role for shadowman hostnameset |
| [shadowman_terraform_aws](roles/shadowman_terraform_aws/README.md) | Role for shadowman terraform aws |
| [shadowman_terraform_azure](roles/shadowman_terraform_azure/README.md) | Role for shadowman terraform azure |
| [shadowman_terraform_cloud](roles/shadowman_terraform_cloud/README.md) | Role for shadowman terraform cloud |
| [shadowman_terraform_cloud_destroy](roles/shadowman_terraform_cloud_destroy/README.md) | Role for shadowman terraform cloud destroy |
| [shadowman_terraform_cloud_post_apply](roles/shadowman_terraform_cloud_post_apply/README.md) | Role for shadowman terraform cloud post apply |
| [shadowman_terraform_cloud_pre_apply](roles/shadowman_terraform_cloud_pre_apply/README.md) | Role for shadowman terraform cloud pre apply |
| [shadowman_terraform_vsphere](roles/shadowman_terraform_vsphere/README.md) | Role for shadowman terraform vsphere |

## Playbooks

| Playbook | Description | Target Hosts |
| -------- | ----------- | ------------ |
| terraform_aws_create.yml | Playbook for terraform aws create | localhost |
| terraform_aws_destroy.yml | Playbook for terraform aws destroy | localhost |
| terraform_azure_create.yml | Playbook for terraform azure create | localhost |
| terraform_azure_destroy.yml | Playbook for terraform azure destroy | localhost |
| terraform_cloud_destroy.yml | Playbook for terraform cloud destroy | localhost |
| terraform_cloud_plan_apply.yml | Playbook for terraform cloud plan apply | localhost |
| terraform_cloud_post_apply.yml | Playbook for terraform cloud post apply | localhost |
| terraform_cloud_pre_apply.yml | Playbook for terraform cloud pre apply | localhost |
| terraform_vsphere_create.yml | Playbook for terraform vsphere create | localhost, just_created |
| terraform_vsphere_destroy.yml | Playbook for terraform vsphere destroy | localhost |

## Usage

### Running with ansible-navigator

```bash
# Run a playbook
ansible-navigator run terraform_aws_create.yml

# Run in stdout mode
ansible-navigator run terraform_aws_create.yml -m stdout
```

### Using roles

```yaml
- hosts: target_hosts
  roles:
    - shadowman_hostnameset
```

## Requirements

- Ansible 2.9 or higher (via ansible-navigator)
- Required collections (see `collections/requirements.yml` if present)
- Appropriate access credentials configured via environment variables

## Directory Structure

```
Ansible-Terraform/
├── roles/              # Ansible roles
├── *.yml               # Playbooks
├── collections/        # Collection dependencies (if present)
└── ansible-navigator.yml  # Navigator configuration
```
