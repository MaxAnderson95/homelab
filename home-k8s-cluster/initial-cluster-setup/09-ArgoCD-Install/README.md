# ArgoCD Install

1. Create the namespace
   ```
   kubectl apply -f Namespace.yaml
   ```

1. Download the Argo install manifest

1. Within the manifest, edit the `argocd-cmd-params-cm` ConfigMap and set the `server.insecure` property to `true`. It should look like the following:
   ```yaml
      apiVersion: v1
   kind: ConfigMap
   metadata:
   labels:
      app.kubernetes.io/name: argocd-cmd-params-cm
      app.kubernetes.io/part-of: argocd
   name: argocd-cmd-params-cm
   data:
      server.insecure: "true"
   ```

1. Install the manifest from Argo's documentation
   ```
   kubectl apply -f Install.yaml -n argocd
   ```

1. Install the Ingress
   ```
   kubectl apply -f Ingress.yaml -n argocd
   ```

1. Retreive the initial admin password
   ```
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
   ```