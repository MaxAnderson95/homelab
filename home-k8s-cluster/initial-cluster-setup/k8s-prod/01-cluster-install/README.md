# Initial Cluster Setup

## Install K3S on the only node

1. Create the K3S config directory

   ```
   sudo mkdir -p /etc/rancher/k3s/config.yaml
   ```

1. Create the K3S
   config

   ```
   sudo touch /etc/rancher/k3s/config.yaml
   sudo chmod 777 /etc/rancher/k3s/config.yaml
   echo "write-kubeconfig-mode: \"0644\"" >> /etc/rancher/k3s/config.yaml
   echo "tls-san:" >> /etc/rancher/k3s/config.yaml
   echo "  - k8s-prod.home.maxanderson.tech" >> /etc/rancher/rke2/config.yaml
   sudo chmod 644 /etc/rancher/k3s/config.yaml
   ```

1. Install K3S

   ```
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.28.3+k3s2 sh -
   ```

1. Run the following command to see a list of nodes. Wait until the node's status is listed as **Ready**

   ```
   kubectl get nodes
   ```

1. Apply the sealed secret decryption key

   ```
   kubectl apply -f sealed-secrets-key.yaml
   ```
