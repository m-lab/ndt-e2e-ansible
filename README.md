# ndt-e2e-ansible
Ansible playbooks for NDT E2E Testing system

## Overview

These playbooks automate end-to-end testing of NDT, including:

* Provisioning nodes for NDT end-to-end testing
* Executing NDT end-to-end tests
* Gathering test results and copying them back to the control machine

Configurations include:

* Control Machine - prepares the control machine to facilitate management of
  nodes in the NDT testbed
* Testbed Nodes - provisions nodes in the testbed for end-to-end testing.

Test execution options include:

* Run NDT using single client or multiple clients.
* Run a single iteration for each configuration or N iterations.
* Run all NDT tests that fit given client conditions (e.g. OS type, browser
  type).

## Pre-Requisites

The user must:

* Have Ansible installed on their control machine (preferably the
[latest source version](http://docs.ansible.com/ansible/intro_installation.html#running-from-source)).
* Have access to the M-Lab testbed

## Getting Started

### Configuring the control machine

The "control machine" in Ansible terms is the machine from which the operator
runs Ansible commands and executes playbooks. To configure your machine to be a
control machine for the NDT E2E testing playbooks so that you can manage the
M-Lab NDT testbed, run the following command from your local machine:

```bash
ansible-playbook configure_control.yml
```

### Provisioning client worker nodes

To provision the testbed nodes so that they can perform automated NDT E2E
testing, run the following command:

```bash
ansible-playbook prepare.yml
```

To provision a single testbed node (e.g. `mlab-linux-mini`), run the following:

```bash
ansible-playbook prepare.yml --limit mlab-linux-mini
```

The provisioning is idempotent, so running the provisioning script multiple
times on the same node is safe.

### Performing E2E tests

The following are examples of ways to perform tests and collect results using
the test execution playbook.

In all examples, the test results will appear on the control machine in the
folder specified by the `local_archive_dir` variable.

##### Run a single test iteration under all configurations

This runs a single NDT E2E test on all remote nodes for with each supported test
type:

```bash
ansible-playbook run.yml
```

##### Run a single test on a single node

Note: We always include mlabmeddlebox so that traffic shaping rules are
enforced.

```bash
ansible-playbook run.yml --limit mlab-linux-mini:mlabmeddlebox
```

##### Run a single test on all OS X nodes

```bash
ansible-playbook run.yml --limit osx:mlabmeddlebox
```

##### Run on a single node, but skip the banjo client

This performs tests on a single node, but  using only the NDT HTML5 reference client:

```bash
ansible-playbook run.yml \
  --limit mlab-linux-mini:mlabmeddlebox \
  --skip-tags "banjo"
```

##### Perform 50 test iterations on a single node

```bash
ansible-playbook run.yml \
  --limit mlab-linux-mini:mlabmeddlebox \
  --extra-vars "iterations=50"
```

##### Perform 50 test iterations on each node, traffic throttled to 25 Mbps

```bash
ansible-playbook run.yml \
  --extra-vars "iterations=50 throttle_mbps=25"
```

##### Perform 50 test iterations on a single node with a specific configuration

This is a more advanced example. It runs:

* 50 test iterations
* excluding the Banjo client
* only under the Chrome browser
* on the mlab-mac-capitan remote node

```bash
ansible-playbook run.yml \
  --limit mlab-mac-capitan:mlabmeddlebox \
  --extra-vars "supported_browsers=chrome iterations=50" \
  --skip-tags "banjo"
```

### Just configure meddlebox throttling

This configures the meddlebox to throttle traffic to the specified speed. This
might be useful when configuring the testbed for manual testing. Be aware that
these settings will be overwritten by any subsequent execution of the run.yml
playbook:

```bash
ansible-playbook run.yml \
  --extra-vars "throttle_mbps=50" \
  --tags "facts,throttle"
```
