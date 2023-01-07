# Initial Cluster Setup with KubeVIP

## KubeVIP
On Node 1:
1. Create manifests directory

    ```
    sudo mkdir -p /var/lib/rancher/rke2/server/manifests/
    ```

On your Linux workstation:
1. Set some env variables

    ```
    export VIP=192.168.1.10
    export INTERFACE=eno1
    KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
    ```

1. Run a temporary docker container which will generate the manifest for us based on our requested settings.

    ```
    alias kube-vip="docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"
            
    kube-vip manifest daemonset \
        --interface $INTERFACE \
        --address $VIP \
        --inCluster \
        --taint \
        --controlplane \
        --services \
        --arp \
        --leaderElection
    ```

Back on Node 1:
1. Save the output to `/var/lib/rancher/rke2/server/manifests/vip.yaml` (Example can be found in this repo)

1. Download the RBAC manifests for kube-vip and place them in the manifests folder
        
    ```
    sudo sh -c 'curl -sL https://kube-vip.io/manifests/rbac.yaml > /var/lib/rancher/rke2/server/manifests/kubevip-rbac.yaml'
    ```
    
## Install RKE2 Server on Node 1
1. Create the RKE2 config directory

    ```
    sudo mkdir -p /etc/rancher/rke2
    ```

1. Set env vars
    
    ```
    export INSTALL_RKE2_CHANNEL=stable
    export INSTALL_RKE2_TYPE=server
    ```

1. Create the RKE2 config 
    
    ```
    export VIP_DNS=k8s.home.maxanderson.tech #This should point to the KubeVIP VIP
    export NODE_IP=192.168.1.11
    sudo touch /etc/rancher/rke2/config.yaml
    sudo chmod 777 /etc/rancher/rke2/config.yaml
    echo "write-kubeconfig-mode: \"0644\"" >> /etc/rancher/rke2/config.yaml
    echo "tls-san:" >> /etc/rancher/rke2/config.yaml 
    echo "  - ${HOSTNAME}" >> /etc/rancher/rke2/config.yaml
    echo "  - ${VIP_DNS}" >> /etc/rancher/rke2/config.yaml
    echo "  - ${NODE_IP}" >> /etc/rancher/rke2/config.yaml
    echo "disable:" >> /etc/rancher/rke2/config.yaml
    echo "  - rke2-ingress-nginx" >> /etc/rancher/rke2/config.yaml
    echo "control-plane-resource-requests: kube-apiserver-cpu=0m,kube-scheduler-cpu=0m,kube-controller-manager-cpu=0m,kube-proxy-cpu=0m,etcd-cpu=0m,cloud-controller-manager-cpu=0m" >> /etc/rancher/rke2/config.yaml
    sudo chmod 644 /etc/rancher/rke2/config.yaml
    ```

1. Configure Kubectl
    
    ```
    echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml' >> ~/.bashrc ; echo 'export PATH=${PATH}:/var/lib/rancher/rke2/bin' >> ~/.bashrc ; echo 'alias k=kubectl' >> ~/.bashrc ; source ~/.bashrc ;
    ```

1. Install RKE2 Server
    
    ```
    curl -sfL https://get.rke2.io | sudo sh -
    systemctl enable rke2-server.service
    systemctl start rke2-server.service
    ```

1. Run the following command to see a list of nodes. Wait until the node's status is listed as **Ready**
    ```
    kubectl get nodes
    ```

1. Ensure you can ping your VIP address

1. Find your join token in `/var/lib/rancher/rke2/server/token` and save to a safe place

## Install RKE2 Server on the other two nodes

1. Create the RKE2 config directory

    ```
    sudo mkdir -p /etc/rancher/rke2
    ```

1. Create the config file
    
    ```
    sudo mkdir -p /etc/rancher/rke2
    export TOKEN="K108429c9286235fbb9711f0dada3c44e405c8876bcfd82c878deb618e3e1f985e0::server:d1e7e9ca0e38019d6c5dfb182385b08a"
    export VIP_DNS=k8s.home.maxanderson.tech #This should point to the KubeVIP VIP
    sudo touch /etc/rancher/rke2/config.yaml
    sudo chmod 777 /etc/rancher/rke2/config.yaml
    echo "token: ${TOKEN}" >> /etc/rancher/rke2/config.yaml
    echo "server: https://${VIP_DNS}:9345" >> /etc/rancher/rke2/config.yaml
    echo "write-kubeconfig-mode: \"0644\"" >> /etc/rancher/rke2/config.yaml
    echo "tls-san:" >> /etc/rancher/rke2/config.yaml 
    echo "  - ${HOSTNAME}" >> /etc/rancher/rke2/config.yaml
    echo "  - ${VIP_DNS}" >> /etc/rancher/rke2/config.yaml
    echo "disable:" >> /etc/rancher/rke2/config.yaml
    echo "  - rke2-ingress-nginx" >> /etc/rancher/rke2/config.yaml
    echo "control-plane-resource-requests: kube-apiserver-cpu=0m,kube-scheduler-cpu=0m,kube-controller-manager-cpu=0m,kube-proxy-cpu=0m,etcd-cpu=0m,cloud-controller-manager-cpu=0m" >> /etc/rancher/rke2/config.yaml
    sudo chmod 644 /etc/rancher/rke2/config.yaml
    ```

1. Set env vars
    
    ```
    export INSTALL_RKE2_CHANNEL=stable
    export INSTALL_RKE2_TYPE=server
    ```

1. Install RKE2 Server
    
    ```
    curl -sfL https://get.rke2.io | sudo sh -
    systemctl enable rke2-server.service
    systemctl start rke2-server.service
    ```