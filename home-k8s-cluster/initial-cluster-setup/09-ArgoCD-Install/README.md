# ArgoCD Install

1. Create the namespace

   ```
   kubectl apply -f Namespace.yaml
   ```

1. Install with Helm

   ```
   helm install argocd argo/argo-cd --values=Values.yaml --namespace argocd
   ```

1. Install the Ingress

   ```
   kubectl apply -f Ingress.yaml -n argocd
   ```

1. Retreive the initial admin password
   ```
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
   ```
