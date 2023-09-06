# crossplane-demo

This repo contains a simple example showcasing how [Crossplane](https://www.crossplane.io/) can be used to manage New Relic alerts via Terraform.

# Prerequisites

- Minikube (or cluster of your choice)
- [Crossplane](https://docs.crossplane.io/v1.13/software/install/)

# Setup

Rename the `./module/terraform.tfvars.json.example` file to `./module/terraform.tfvars.json` and modify the values.  Then, create a Kubernetes Secret with the data.

```
kubectl create secret generic terraform --from-file=./module/terraform.tfvars.json
```

Create the provider.

```
kubectl apply -f ./crossplane-config/provider.yaml
```

Create the provider config.

```
kubectl apply -f ./crossplane-config/providerconfig.yaml
```

Create the Terraform workspace.

```
kubectl apply -f ./crossplane-config/workspace-remote.yaml
```

Validate that the workspace is ready and synced.

```
$ kubectl get workspaces
NAME              READY   SYNCED   AGE
newrelic-alerts   True    True     11m
```

# Validation

If successful, you should see the `Crossplane Demo` alert policy created in your New Relic account.

![alert condition](https://p191.p3.n0.cdn.getcloudapp.com/items/7KuXeXOj/d3e4c04a-084a-4f57-986f-227c2ba31958.jpg?v=0fac78c1954335a22f3222d8244e755b)