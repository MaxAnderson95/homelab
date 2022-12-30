# Sealed Secrets Operator Install
1. Add the repo and update
    ```
    helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
    helm repo update
    ```

1. Install the chart
    ```
    helm install sealed-secrets sealed-secrets/sealed-secrets --values values.yaml
    ```