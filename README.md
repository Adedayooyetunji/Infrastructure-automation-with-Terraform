# Infrastructure-automation-with-Terraform

Use Terraform to automatically create, configure, and manage Docker
containers and networks instead of creating them manually.

## Overview

Provisions a private Docker bridge network with an nginx web service and a
Redis service with a persistent Docker volume. Both containers are created
through the reusable `modules/service` module, driven by `for_each` over the
service map in `main.tf`.

## Requirements

- Terraform 1.5 or later
- Docker Engine with its daemon running
- Graphviz (`dot`) to render the optional dependency graph

The Docker provider defaults to `unix:///var/run/docker.sock`, suitable for
Linux. Override `docker_host` in `terraform.tfvars` or with `-var` when using a
different Docker endpoint. For example, Docker Desktop on Windows uses
`npipe:////./pipe/docker_engine`.

## Usage

From the project directory:

    terraform init
    terraform fmt -recursive
    terraform validate
    terraform plan -out=tfplan
    terraform apply tfplan

Check the running services:

    docker ps
    curl -I http://localhost:8080
    docker exec lab-web ping -c 2 redis

To check drift, stop the web container and ask Terraform to refresh and plan:

    docker stop lab-web
    terraform plan
    terraform apply

The plan should show that the stopped container needs reconciliation. Applying
the plan returns the declared service to its configured state.

Remove the resources when finished:

    terraform destroy

This also removes the Redis volume managed by this configuration, including its
stored data.

## Configuration and outputs

The root variables in `variables.tf` configure the Docker endpoint, project
name, published web port, and network subnet. `terraform.tfvars` sets the
project name and web port for this lab.

Terraform reports the web URL, Docker network ID, and service IP addresses as
outputs after apply.

## Adding a service

Add an entry to `local.services` in `main.tf`; the module creates the image,
container, optional ports, volume, and health check based on the values
provided. No additional resource blocks are needed.

## State, dependencies, and provider lock file

Terraform's default local state is stored in `terraform.tfstate`. It records
the resource identities and attributes Terraform manages so future plans can
compare the configuration with the last known infrastructure state. State
files are excluded from version control because they can contain sensitive
values and machine-specific infrastructure details. For shared use, configure
a remote backend with access control and state locking rather than sharing a
local state file.

Terraform builds a dependency graph from resource references. For example,
the service containers depend on the Docker network name, and a container
depends on its image and optional volume. Inspect the graph with:

    terraform graph | dot -Tpng -o terraform-graph.png

The generated `.terraform.lock.hcl` records the selected provider version and
checksums so subsequent initializations use a consistent, verified provider.
Commit this lock file; do not commit `.terraform/`, plans, or state files.
