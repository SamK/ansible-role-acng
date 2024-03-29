# Ansible Role: Apt-Cacher NG
[![Tests](https://github.com/samk/ansible-role-acng/workflows/Test/badge.svg)](https://github.com/samk/ansible-role-acng/actions)

Install and configure [APT-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/)

## Installation

See https://galaxy.ansible.com/samk/acng

## Role Variables

```yaml
acng_config: {}
```
The configuration of `acng.conf`.
See chapter below for specification.

```yaml
acng_service_name: apt-cacher-ng
```
The name of the service.

```yaml
acng_config_file: /etc/apt-cacher-ng/acng.conf
```
The path to the config file.

```yaml
acng_service_state: started
```
The state of the service.

```yaml
acng_service_enabled: true
```
Determine if the service is started on boot.

```yaml
acng_admin_name:
```
The username of the admin account

```yaml
acng_admin_password:
```
The password of the admin account

```yaml
acng_admin_state: present
```
Enable authentication against the web page.
Ignored when `acng_admin_name` is not be set.

## The `acng_config` variable format

The key is the config param.
The value can be either the value of the param or a dict.
The dict understands these values:

* `ensure`: can be `present` (default)  or `absent`
* `value`: the value of the param; ignored when the `ensure` key is `absent`

Example:
```yaml
acng_config:
  PassThroughPattern: '^(.*):443$'
  NetworkTimeout: 30
  FreshIndexMaxAge:
    ensure: present
    value: 20
  Debug:
    ensure: absent
```

These three examples are identical:
```yaml
acng_config:
  Debug: 3
```
```yaml
acng_config:
  Debug:
    value: 3
```
```yaml
acng_config:
  Debug:
    ensure: present
    value: 3
```

## Example Playbooks

allow HTTPS, remove the `Debug` param, set network timeout to 30s:

```yaml
- hosts: apt_cacher_ng
  roles:
     - acng
  vars:
    acng_config:
      NetworkTimeout: 30
      PassThroughPattern:
        value: '^(.*):443$'
      Debug:
        ensure: absent
```

## Test

The [GitHub workflow](.github/workflows/ansible.yml) is using a matrix test against multiple
Ansible major versions and operating systems.
The test procedure below does not allow this.

1. Create and activate a virtual environment

1. Install and run the linters
   ```shell
   pip install yamllint ansible-lint
   yamllint .
   ansible-lint
   ```

1. Define which Ansible version you want to test.
   The list of major Ansible versions tested by GitHub worflow is located in the
   [molecule/requirements](molecule/requirements) folder.
   * This example installs Ansible 2.13:

      ```shell
      pip install -r molecule/requirements/ansible-2.13.txt
      ```

   * This example installs the latest version of Ansible:

      ```shell
      pip install -r molecule/requirements/ansible-latest.txt
      ```

   * You can install any version you want to test:

      ```shell
      pip install 'molecule[docker]' ansible-core==2.13.4
       ```

1. Execute molecule

   ```shell
   MOLECULE_DISTRO=ubuntu2004 molecule test --all
   ```

   This environment variable is used by [molecule.yml](molecule/default/molecule.yml)
   to pull the appropriate Docker image.

   Note: this command below executes all scenarios on all the distros:
   ```shell
   ./molecule/test-all.sh
   ```
