# ndt-e2e-ansible
Ansible playbooks for NDT E2E Testing system

## Pre-Requisites

The user must:

* Have Ansible installed on their machine (preferably the [latest source version](http://docs.ansible.com/ansible/intro_installation.html#running-from-source)).
* Have access to the M-Lab testbed

## Getting Started

### Configuring the control node

To configure the control node to manage the machines in the testbed, run the
following command:

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
ansible-playbook prepare.yml -l mlab-linux-mini
```

The provisioning is idempotent, so running the provisioning script multiple
times on the same node is safe.

### Performing E2E tests

The following are examples of ways to perform tests and collect results using
the test execution playbook.

In all examples, the test results will appear on the control node in the folder
specified by the `local_archive_dir` variable.

##### Run a single test iteration under all configurations

This runs a single NDT E2E test on all remote nodes for with each supported test
type:

```bash
ansible-playbook run.yml
```

##### Run a single test on a single node

```bash
ansible-playbook run.yml -l mlab-linux-mini
```

##### Run a single test on all OS X nodes

```bash
ansible-playbook run.yml -l osx
```

##### Run only the NDT HTML5 reference client on a single node

This performs tests on a single node using only the NDT HTML5 reference client:

```bash
ansible-playbook run.yml -l mlab-linux-mini --tags "facts,html5,gather"
```

##### Perform 50 test iterations on a single node

```bash
ansible-playbook run.yml \
  -l mlab-linux-mini \
  --extra-vars "iterations=50"
```

##### Perform 50 test iterations on a single node with a specific configuration

This is a more advanced example. It runs:

* 50 test iterations
* using only the NDT HTML5 reference client
* only under the Chrome browser
* on the mlab-mac-capitan remote node

```bash
ansible-playbook run.yml \
  -l mlab-mac-capitan \
  --extra-vars "supported_browsers=chrome iterations=50" \
  --tags "facts,html5,gather"
```
