# MetalLB Install
1. Add the MetalLB repo and update
    ```
    helm repo add metallb https://metallb.github.io/metallb
    helm repo update
    ```

1. Install the MetalLB helm chart
    ```
    helm install metallb metallb/metallb --namespace metallb-system --create-namespace
    ```

1. Create an IP address pool to hand out
    ```
    kubectl apply -f IPAddressPool.yaml
    ```

1. Create a Layer 2 Advertisement to advertise the pool
    ```
    kubectl apply -f L2Advertisement.yaml
    ```