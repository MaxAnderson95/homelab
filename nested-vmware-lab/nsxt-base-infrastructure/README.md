Before running some resources must be created by hand as they cannot be created in Terraform:

For each site
1. Install the manager
2. License the manager
3. Add compute manager
4. Create IP pools
    1. Create a Host TEP pool 
        - 10.X.175.10-10.X.175.49
    2. Create an Edge TEP pool
        - 10.X.175.50-10.X.175.79
    3. Create an Edge RTEP pool
        - 10.X.176.50-10.X.176.79
5. Set the Tunnel Endpoint MTU to 9000
6. Set the Remote Tunnel Endpoint MTU to 1500 
7. Create transport zones (or use the existing)
    1. One overlay TZ
    2. One VLAN TZ used for edge uplinks
8. Create uplink profiles
    1. One for hosts
    2. One for edges
9. Create Transport Node Profile for hosts
10. Prepare the hosts for NSX using the tn profile