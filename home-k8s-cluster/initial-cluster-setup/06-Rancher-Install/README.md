# Rancher Install
1. Create a namespace for Rancher
    ```
    kubectl apply -f Namespace.yaml
    ```
1. Create a certificate since rancher manages its own certificate during installation
    ```
    kubectl apply -f Certificate.yaml
    ```

1. Add the repo and update
    ```
    helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
    helm repo update
    ```

1. Install the chart
    ```
    helm install rancher rancher-stable/rancher --namespace cattle-system --values values.yaml
    ```