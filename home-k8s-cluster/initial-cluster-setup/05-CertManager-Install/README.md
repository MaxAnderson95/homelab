# Cert Manager Install
1. Add the repo and update
    ```
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```

1. Install the chart
    ```
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.10.1 --values values.yaml
    ```

1. Create a secret to hold the DNS solver API key for DigitalOcean
    ```yaml
    apiVersion: v1
    kind: Secret
    type: Opaque
    metadata:
        name: digitalocean-dns
        namespace: cert-manager
    data:
        access-token: <Base64 Encoded Secret Here>
    ```

1. Seal (encrypt) the secret with Kubeseal
    ```
    kubeseal -f temp-secret.yaml -o yaml > do-token.sealedsecret.yaml
    ```

1. Delete the original secret file so it doesn't accidentally get commited to git or stolen

1. Apply the sealed secret object
    ```
    kubectl apply -f do-token.sealedsecret.yaml
    ```

1. Apply the CertManager cluster issuer
    ```
    kubectl apply -f ClusterIssuer.yaml
    ```

## Create a Wildcard Certificate

1. Create a wildcard certificate
    ```
    kubectl apply -f WildcardCert.yaml
    ```

1. Create a Treafik default TLS store that uses the wildcard cert
    ```
    kubectl apply -f TLSStore.yaml
    ```