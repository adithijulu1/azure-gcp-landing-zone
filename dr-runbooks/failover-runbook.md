# Disaster Recovery Failover Runbook

## Scope
Covers failover procedures for AKS workloads and Key Vault secrets in
the event of a regional Azure outage.

## Pre-requisites
- Secondary AKS cluster provisioned in paired region (`eastus2`)
- Key Vault geo-replication enabled
- Azure Traffic Manager configured with priority routing

## Failover Steps

1. **Detect outage**
   - Confirm via Azure Status page and Log Analytics alerts.

2. **Redirect traffic**
```bash
   az network traffic-manager endpoint update \
     --name secondary-endpoint \
     --profile-name landing-zone-tm \
     --resource-group landing-zone-rg \
     --type azureEndpoints \
     --endpoint-status Enabled
```

3. **Scale secondary AKS cluster**
```bash
   az aks scale --resource-group landing-zone-rg-dr \
     --name landing-zone-aks-dr \
     --node-count 5
```

4. **Verify application health**
```bash
   kubectl get pods --namespace production --context secondary-cluster
```

5. **Update DNS TTL** to confirm propagation, monitor Traffic Manager
   dashboard for endpoint health.

## Post-Incident
- Document root cause in `docs/incident-reports/`
- Run failback procedure once primary region is confirmed stable
- Review RTO/RPO metrics against SLA targets
