# Salty VCF: Photon OS 5 Automation Image

This repository builds and maintains a custom Photon OS 5 image pre-configured with [Salt 3008.x](https://saltproject.io/) and the `saltext-vcf` extension.

The goal of this project is to provide a ready-to-deploy environment (both as a container and a Virtual Machine OVA) specifically targeted for managing and automating VMware Cloud Foundation (VCF) and vSphere infrastructure via VCF APIs.

## Features

* **Base OS**: Photon OS 5
* **Automation**: Salt Master and Salt Minion pre-installed (v3008.x).
* **VCF Integration**: `saltext-vcf` installed via `salt-pip`.
* **Pre-Configured**:
  * On first start, the local Minion generates its own unique keypair and the local Master automatically verifies and accepts it (no shared/baked-in keys, no manual steps).
  * Standard Salt directory structures (`/srv/salt` and `/srv/pillar`) are established.

## Artifacts & Usage

This repository automatically builds two types of artifacts on version tags:

### 1. OVA (For vSphere / VCF)

The OVA is exclusively targeted for VCF and vSphere deployments. It acts as a turnkey Salt Master/Minion appliance.
* **Download**: Pushing a `v*.*.*` tag creates a **draft** release on the [Releases](https://github.com/scriptautomate-bc/ova-and-container-gen-testing/releases) page with the OVA (zipped) attached. A maintainer must publish the draft (via the GitHub UI, or `gh release edit <tag> --draft=false`) before it's visible/downloadable to anyone without write access. Once published, download the ZIP associated with the tag and unzip to retrieve the `.ova` file.
* **Test builds**: Manually triggering the workflow (`workflow_dispatch`, e.g. to validate changes before cutting a real tag) does not create a release. Instead, the built OVA is uploaded as a CI artifact (2-day retention) on that workflow run's "Artifacts" list, for internal testing only.
* **Deploy**: Deploy directly into your vCenter environment.
* **Credentials**: The default root password is `changeme123!` (Make sure to change this upon first login).

### 2. Container Image

The containerized version is available on the GitHub Container Registry (GHCR) and is ideal for CI/CD pipelines or lightweight execution.
* **Pull**: `docker pull ghcr.io/scriptautomate-bc/ova-and-container-gen-testing:latest`
* **Run**: `docker run -d ghcr.io/scriptautomate-bc/ova-and-container-gen-testing:latest` — the entrypoint starts the Salt daemons and completes key acceptance automatically. Map your state files directly to `/srv/salt` using volume mounts as needed.
