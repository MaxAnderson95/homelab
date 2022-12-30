# Traefik Ingress Controller Install
1. Add the repo and update
    ```
    helm repo add traefik https://traefik.github.io/charts
    helm repo update
    ```

1. Install the chart
    ```
    helm install traefik traefik/traefik --values values.yaml --namespace=traefik --create-namespace
    ```