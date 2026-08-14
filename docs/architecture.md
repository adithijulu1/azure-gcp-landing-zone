# Architecture Overview

## Purpose
This landing zone establishes a governed, secure baseline environment
across Azure and GCP for hosting production workloads, enforcing
compliance guardrails via policy-as-code and enabling automated
disaster recovery.

## Components

### Infrastructure Layer
- **Terraform** provisions the Azure resource group, AKS cluster, and
  Key Vault, with remote state in Azure Storage.
- **Bicep** defines the core networking baseline (VNets, subnets).
- **ARM Templates** enforce network security group defaults
  (deny-all-inbound by default).

### Identity & Access
- **Microsoft Entra ID** groups drive RBAC assignments to AKS and
  Key Vault, avoiding individual user grants.
- **Azure RBAC** is enabled natively on the AKS cluster rather than
  relying solely on Kubernetes-native RBAC.

### Governance Layer
- **Azure Policy** definitions (see `governance/azure-policy/`) block
  non-compliant resource creation, e.g. public IP addresses, at
  deployment time — not just via post-hoc audit.

### CI/CD Layer
- **Azure DevOps Pipelines** handle the primary validate -> plan ->
  apply workflow for Terraform.
- **GitHub Actions** run format/lint checks on every PR as a fast
  feedback loop independent of the Azure DevOps environment.
- **Jenkins** provides an alternate on-prem-friendly pipeline option,
  including a policy compliance scan step before apply.

### Monitoring & DR
- **Azure Monitor + Log Analytics** (KQL queries in `monitoring/`)
  track pod failures, Key Vault access denials, and node resource
  trends.
- **DR runbook** (`dr-runbooks/failover-runbook.md`) documents the
  manual/scripted failover procedure to a paired-region AKS cluster
  via Traffic Manager.

## Data Flow
1. Engineer opens a PR -> GitHub Actions validates Terraform/Bicep syntax.
2. On merge to `main`, Azure DevOps pipeline runs plan -> apply.
3. Azure Policy evaluates every resource against compliance rules in
   real time, denying non-compliant deployments.
4. Log Analytics continuously monitors cluster and Key Vault health.
5. On regional outage, DR runbook is executed to fail over via
   Traffic Manager to the secondary AKS cluster.
