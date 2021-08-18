# Ansible Role ACNG
[![Tests](https://github.com/samk/ansible-role-acng/workflows/Test/badge.svg)](https://github.com/samk/ansible-role-acng/actions)

Install and configure [APT-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/)

## Role Variables

```yaml
acng_config: {}
```
The configuration of `acng.conf`.
You usually want to use this one.
It is merged with `acng_config_default`.
See below for the format of this variable.

```yaml
acng_config_default: {}
```
The configuration of `acng.conf`
You usually don't need this one.
See below for the format of this variable.

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

### The variables `acng_config_default` and `acng_config`

These variables contain the configuration settings of the `acng.conf` file.
The type is a dictionnary.

The two variables are merged before writing `acng.conf`.
*This might be useful if you have to manage multiple servers with
common settings to all servers (put them in `acng_config_default`)
and unique settings for specific servers (put them in `acng_config`).*

The keys are the params of the `acng.conf` file.

The value of each key is another dictionnary which allows these keys:

* `value`: the value of the param; it can be ommited if the `ensure` key contains `absent`
* `ensure`: can be `present` (default)  or `absent`

If all of this is too confusing, refer to the examples below.

## Example Playbooks

a minimal working playbook:

```yaml
- hosts: apt_proxy
  roles:
     - acng
```

allow HTTPS, remove the `Debug` param:

```yaml
- hosts: apt_proxy
  vars:
    acng_config:
      PassThroughPattern:
        value: '^(.*):443$'
      Debug:
        ensure: absent
  roles:
     - acng
```
