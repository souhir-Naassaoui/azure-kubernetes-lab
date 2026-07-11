Sans CNI, Kubernetes fonctionne mais les pods ne peuvent pas communiquer, et les nœuds restent généralement en état NotReady.

Pourquoi Kubernetes a besoin d'un CNI ?

Quand kubeadm init se termine, Kubernetes a créé :

API Server
etcd
Scheduler
Controller Manager
kubelet

Mais il n'a pas créé le réseau des pods.

Imagine deux pods :

Pod nginx  --------->  Pod redis
192.168.1.2          192.168.2.5

Qui crée ces IP ? Qui configure les routes ? Qui crée les interfaces réseau ?

👉 Ce n'est pas Kubernetes lui-même.

C'est le plugin CNI (Calico, Cilium, Flannel...).

Pourquoi Calico ?

Pour un lab, Calico est un excellent choix :

très utilisé en production ;
bien documenté ;
compatible avec kubeadm ;
supporte les Network Policies.


Terraform
│
├── Resource Group
├── Virtual Network
├── Subnet
├── NSG
├── Public IP
├── NIC
└── VM Master + VM Worker
         │
         ▼
Ansible
│
├── common
│     ├── Désactivation du swap
│     ├── sysctl
│     └── modules kernel
│
├── containerd
│     └── Installation et configuration du runtime
│
├── kubernetes
│     └── Installation de kubeadm, kubelet et kubectl
│
├── master
│     └── kubeadm init
│
├── worker
│     └── kubeadm join
│
└── network
      └── Installation de Calico