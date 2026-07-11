Le rôle master a une seule responsabilité :

Transformer une VM Ubuntu en Control Plane Kubernetes.

Il ne doit jamais installer kubelet ou containerd (c'est déjà fait par les rôles précédents).

Que fait kubeadm init ?

Lorsque tu exécutes :

sudo kubeadm init

Il ne fait pas "une seule chose". Il réalise de nombreuses étapes :

             kubeadm init
                   │
                   ▼
        Vérifie les prérequis
                   │
                   ▼
        Génère les certificats TLS
                   │
                   ▼
        Initialise etcd
                   │
                   ▼
        Démarre kube-apiserver
                   │
                   ▼
        Démarre controller-manager
                   │
                   ▼
        Démarre scheduler
                   │
                   ▼
        Démarre kubelet
                   │
                   ▼
        Génère le kubeconfig
                   │
                   ▼
        Génère le token de join

À la fin, ton master est créé, mais aucun pod ne peut encore communiquer tant qu'un plugin réseau (Calico, Cilium, Flannel...) n'est pas installé.


Après kubeadm init, le fichier :

/etc/kubernetes/admin.conf

est créé.

C'est le fichier que kubectl utilise pour savoir :

où se trouve l'API Server ;
quel certificat utiliser ;
quel utilisateur employer.

Par défaut, seul root y a accès.

En le copiant dans :

/home/azureuser/.kube/config

tu pourras utiliser simplement :

kubectl get nodes

avec ton utilisateur azureuser.

Pourquoi générer le token ?

À la fin de kubeadm init, Kubernetes affiche une commande semblable à :

kubeadm join 10.0.1.4:6443 \
  --token abcdef.0123456789abcdef \
  --discovery-token-ca-cert-hash sha256:...

Le worker aura besoin exactement de cette commande.

Au lieu de la copier manuellement, Ansible la récupère automatiquement avec :

register: join_command

Résultat

Après ce rôle :

Master

✓ etcd

✓ API Server

✓ Scheduler

✓ Controller Manager

✓ kubelet

✓ kubectl

✓ admin.conf

✓ Join command

Le cluster existe, mais il n'a encore qu'un seul nœud.

Ce qui reste

Il restera deux rôles :

worker
récupère automatiquement kube_join_command ;
exécute kubeadm join.
network
installe Calico ;
rend les pods capables de communiquer.