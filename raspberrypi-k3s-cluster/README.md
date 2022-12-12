# Homelab K3s Server
*Currently a work in progress*

## Install

### Install of Sealed Secrets
1. Apply the deployment
    ```
    kubectl apply -f ./sealed-secrets/sealed-secrets.deployment.yaml -n kube-system
    ```

### Install Cert Manager
1. Generate sealed secret for digitalocean dns secret
    ```
    kubeseal -f ./cert-manager/digitalocean-dns.secret.yaml -o yaml > ./cert-manager/digitalocean-dns.sealedsecret.yaml
    ```
1. Apply the sealed secret, then the sealed secret operator will decrypt it and place it in a standard Kubernetes secret object automatically.
    ```
    kubectl apply -f ./cert-manager/digitalocean-dns.sealedsecret.yaml
    ```
1. Create the Namespace
    ```
    kubectl apply -f ./cert-manager/namespace.yaml 
    ```
1. Create the CRDs
    ```
    kubectl apply -f ./cert-manager/cert-manager.crds.yaml
    ```
1. Install the helm chart
    ```
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --values=values.yaml --version v1.10.1
    ```
1. Install the cluster issuer that gets certs from letsencrypt using dns verification with Digital Ocean
    ```
    kubectl apply -f ./cert-manager/letsencrypt-prod.clusterissuer.yaml
    ```

### Install ArgoCD
1. Create the namespace
    ```
    kubectl apply -f ./argocd/namespace.yaml
    ```
1. Create the certificate for ingress
    ```
    kubectl apply -f ./argocd/certificate.yaml
    ```
1. Install the manifests
    ```
    kubectl apply -f ./argocd/install.yaml -n argocd
    ```
1. Create the ingress route in Traefik
    ```
    kubectl apply -f ./argocd/ingressroute.yaml
    ```
1. Retreive the argocd default password
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    ```
1. Login to argocd cli
    ```
    argocd login argocd.home.maxanderson.tech
    ```