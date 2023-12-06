# Home K8s Environment

These are the manifests for my two home K8s clusters. We have `k8s-prod` and `k8s-dev`.

`k8s-prod` is a single-node cluster that runs my home services like DNS, unifi controller, monitoring, etc.

`k8s-dev` is a three-node cluster that is for testing and experimentation.

All 4 nodes are Dell OptiPlex mini-PCs with quad core i5 CPUs, 16GB of RAM, and 128GB of SSD storage.

The `k8s-prod` cluster uses K3s runing on Ubuntu 22.04. The `k8s-dev` cluster still isn't setup yet but I plan to use Talos for the OS and K8s.

`k8s-prod` has an instance of ArgoCD which is keeping the manifests in sync with the cluster.
