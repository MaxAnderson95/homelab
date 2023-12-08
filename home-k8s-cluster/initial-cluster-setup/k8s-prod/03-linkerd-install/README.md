# Linkerd Install

1. Install the `step` CLI on your local workstation
1. Add the repo and update

   ```
   helm repo add linkerd https://helm.linkerd.io/stable
   helm repo update
   ```

1. Install the CRDs chart

   ```
   helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace
   ```

1. Use Step to generate a CA certificate

   ```
   step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure
   ```

1. Use Step to generate an intermediate CA certificate

   ```
   step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key
   ```

1. Install the Control Plane chart

   ```
   helm install linkerd-control-plane linkerd/linkerd-control-plane -n linkerd --set-file identityTrustAnchorsPEM=ca.crt --set-file identity.issuer.tls.crtPEM=issuer.crt --set-file identity.issuer.tls.keyPEM=issuer.key
   ```

1. Install the viz chart
   ```
   helm install linkerd-viz linkerd/linkerd-viz -n linkerd-viz --create-namespace
   ```
