# Salty VCF: Photon OS 5 Automation Image

This repository builds and maintains a custom Photon OS 5 image pre-configured with [Salt 3008.x](https://saltproject.io/) and the `saltext-vcf` extension.

The goal of this project is to provide a ready-to-deploy environment (both as a container and a Virtual Machine OVA) specifically targeted for managing and automating VMware Cloud Foundation (VCF) and vSphere infrastructure via VCF APIs.

## Features

* **Base OS**: Photon OS 5
* **Automation**: Salt Master and Salt Minion pre-installed (v3008.x).
* **VCF Integration**: `saltext-vcf` installed via `salt-pip`.
* **Pre-Configured**:
  * The local Minion is already keyed and accepted by the local Master.
  * Standard Salt directory structures (`/srv/salt` and `/srv/pillar`) are established.

## Artifacts & Usage

This repository automatically builds and releases two types of artifacts on version tags:

### 1. OVA (For vSphere / VCF)

The OVA is exclusively targeted for VCF and vSphere deployments. It acts as a turnkey Salt Master/Minion appliance.
* **Download**: Navigate to the [Releases](https://github.com/scriptautomate-bc/ova-and-container-gen-testing/releases) page and download the ZIP file associated with the latest tag. Unzip to retrieve the `.ova` file.
* **Deploy**: Deploy directly into your vCenter environment.
* **Credentials**: The default root password is `changeme123!` (Make sure to change this upon first login).

### 2. Container Image

The containerized version is available on the GitHub Container Registry (GHCR) and is ideal for CI/CD pipelines or lightweight execution.
* **Pull**: `docker pull ghcr.io/scriptautomate-bc/ova-and-container-gen-testing:latest`
* **Run**: Start the container and manually initialize the Salt daemons, or map your state files directly to `/srv/salt` using volume mounts.
