# Byte Haven

Welcome to the Byte Haven, my homelab setup repository. This repository provides Ansible playbooks to help set up and manage my homelab environment. It uses Ansible to automate server configuration, base setup, and Kubernetes (k3s) installation. 

## Prerequisites

Before you begin, make sure you have the following tools installed:

- [1Password CLI](https://developer.1password.com/docs/cli) (for retrieving secrets from the vault)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
- SSH access to your homelab servers

### Secrets

The setup uses 1Password to retrieve secrets stored in the `sg-k8s` vault. You will need to have the following items stored:

- **admin-user**: The username and initial password for the admin user.
- **my_user**: The username and password for your primary user.
- **k3s-token**: Token used for k3s installation.

## Makefile Tasks

### 1. `ansible-first-run`

This task sets up the base configuration for your homelab by retrieving the admin credentials from 1Password and running the Ansible playbook with sudo privileges.

```bash
make ansible-first-run
```

- Retrieves the admin user's initial password and username.
- Executes the `ansible/base.yaml` playbook to configure the server.
- Uses SSH keys for secure login, bypassing host key checking for ease of use.

### 2. `ansible-base`

This task runs the base configuration playbook without the admin password setup (useful after the initial run).

```bash
make ansible-base
```

- Executes the `ansible/base.yaml` playbook.
- Uses the primary user’s credentials stored in 1Password.

### 3. `ansible-k3s`

This task installs k3s, a lightweight Kubernetes distribution, on your server.

```bash
make ansible-k3s
```

- Installs any required Ansible collections.
- Retrieves the k3s token from 1Password and installs k3s using the `ansible/k3s-install.yaml` playbook.

## Getting Started

1. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Ensure SSH Access**

   Make sure you have SSH access to the hosts defined in `ansible/inventory/hosts.yaml`. You may need to adjust your inventory file to point to your homelab servers.

3. **Configure 1Password CLI**

   Log in to 1Password CLI to retrieve the necessary credentials:

   ```bash
   eval $(op signin)
   ```

4. **Run the Playbooks**

   Start with the base configuration:

   ```bash
   make ansible-first-run
   ```

   Afterward, you can re-run tasks like `ansible-base` or `ansible-k3s` as needed to continue configuring your homelab.

---

Let me know if you need to tweak this further!