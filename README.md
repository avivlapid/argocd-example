# ArgoCD Organization Pod ApplicationSet

This ArgoCD ApplicationSet monitors the repository https://github.com/avivlapid/argocd-example and dynamically creates identical empty pods for each organization defined in `organizations.yaml`. Each organization gets its own pod and namespace.

## Prerequisites

- ArgoCD installed and running in your Kubernetes cluster
- Access to ArgoCD UI or CLI
- kubectl configured to access your cluster

## How It Works

1. **Organization Whitelist**: The ApplicationSet reads `organizations.yaml` from your git repository
2. **One Pod Per Organization**: For each organization in the whitelist, it creates a separate ArgoCD Application
3. **Identical Empty Pods**: Each organization gets the same type of empty pod (busybox with sleep)
4. **GitOps Workflow**: Any changes to `organizations.yaml` trigger redeployment

## Setup

### Step 1: Add Organization Configuration to Your Git Repository

Place the `organizations.yaml` file in the root of your git repository (https://github.com/avivlapid/argocd-example). This file defines the organizations in your system.

### Step 2: Deploy the ApplicationSet

```bash
kubectl apply -f argocd-applicationset.yaml
```

## Configuration Format

Each organization in `organizations.yaml` should have:

```yaml
organization: organization-name
description: "Description of the organization"
```

## Example Organizations

The included example creates pods for 6 organizations:
- **acme-corp**: ACME Corporation - Main business unit
- **tech-innovations**: Tech Innovations - R&D division
- **marketing-dept**: Marketing Department - Customer outreach
- **finance-team**: Finance Team - Financial operations
- **hr-department**: Human Resources - Employee management
- **support-center**: Support Center - Customer support operations

## Features

- **Organization-Based**: One identical empty pod per organization
- **Automated Sync**: Applications automatically sync when the repository changes
- **Self-Healing**: If resources are manually modified, ArgoCD restores them
- **Namespace Isolation**: Each organization gets its own namespace (`org-{organization}`)
- **Environment Variables**: Each pod has ORGANIZATION and ORG_DESCRIPTION env vars

## Pod Specifications

All pods are identical with:
- **Image**: `busybox:1.35`
- **Command**: `sleep 3600` (keeps pod running for 1 hour)
- **Resources**: 100m CPU / 128Mi Memory (requests), 200m CPU / 256Mi Memory (limits)
- **Environment Variables**:
  - `ORGANIZATION`: The organization name
  - `ORG_DESCRIPTION`: The organization description
  - `POD_PURPOSE`: "empty-pod-for-org"

## Monitoring

Monitor the ApplicationSet and generated applications:

```bash
# Check the ApplicationSet
kubectl get applicationsets -n argocd

# List all generated applications
kubectl get applications -n argocd

# Check pods across all organization namespaces
kubectl get pods --all-namespaces | grep org-

# Check applications being created
kubectl get applications -n argocd

# Check pods being deployed
kubectl get pods --all-namespaces | grep org-

# Check ApplicationSet status
kubectl get applicationsets -n argocd
```

## Adding New Organizations

To add a new organization:

1. Edit `organizations.yaml` in your git repository
2. Add a new organization entry
3. Commit and push the changes
4. ArgoCD will automatically detect and deploy a pod for the new organization

## Removing Organizations

To remove an organization:

1. Delete the organization from `organizations.yaml`
2. Commit and push the changes
3. The ApplicationSet will automatically remove the corresponding application and resources 