<!-- This was created with Claude Code -->

shadowman_terraform_azure
=========================

An Ansible role for shadowman terraform azure.

Requirements
------------

- Ansible 2.9 or higher
- Access to target systems with appropriate permissions

Role Variables
--------------

* **tf_build**: Variable used in: Create Terraform project
  - Default: `ansible01`

* **terraform_working_dir**: Configuration parameter for key_file task
  - Default: `/tmp/srv/`

* **terraform_state**: Variable used in: Creating Git Project
  - Default: `present`

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: all
  roles:
    - role: shadowman_terraform_azure
      vars:
        tf_build: <value>
        terraform_working_dir: <value>
        terraform_state: <value>
```

License
-------

GNU General Public License v3.0 or later

Author Information
------------------

Red Hat Ansible Automation Platform
