creates: /etc/kubernetes/kubelet.conf

Au premier lancement :

Le fichier n'existe pas
        │
        ▼
kubeadm join est exécuté

Aux exécutions suivantes :

Le fichier existe
        │
        ▼
La tâche est ignorée

Cela rend le playbook idempotent.

À ce stade

Après les rôles master et worker, tu auras :

                 Kubernetes Cluster

         +---------------------------+
         |       Control Plane       |
         |---------------------------|
         | API Server                |
         | Scheduler                 |
         | Controller Manager        |
         | etcd                      |
         +------------+--------------+
                      |
                      |
             kubeadm join
                      |
        +-------------+-------------+
        |                           |
+------------------+       +------------------+
|   Master Node    |       |   Worker Node    |
| kubelet          |       | kubelet          |
| containerd       |       | containerd       |
+------------------+       +------------------+

Cependant, si tu fais :

kubectl get nodes

tu verras probablement les nœuds en état NotReady.

C'est normal.

Il manque encore le plugin réseau (CNI).