Les 3 éléments fondamentaux

Un projet Ansible est composé de seulement trois éléments :

inventory
playbook
roles

C'est tout.

1. L'inventory

Il répond à une seule question :

Sur quelles machines dois-je travailler ?

2. Le playbook

Le playbook répond à une autre question :

Que dois-je faire sur ces machines ?

Par exemple :

Installer containerd

Installer kubeadm

Installer kubelet

Désactiver le swap

C'est une suite d'actions.

3. Les rôles (roles)

Les rôles permettent d'éviter d'avoir un énorme fichier YAML de plusieurs centaines de lignes.

Au lieu de ça :

site.yml

appelle plusieurs rôles :

common

containerd

kubernetes

master

worker

Chaque rôle a une responsabilité unique.

C'est exactement le même principe que les modules Terraform.
4. Les tâches (tasks)

Chaque rôle contient des tâches.

Par exemple :

containerd

↓

Installer package

↓

Créer configuration

↓

Démarrer service


ansible-playbook -i inventory.ini site.yml
Et Ansible fera automatiquement :

installation des dépendances
désactivation du swap
installation de containerd
installation de kubelet
installation de kubeadm
configuration du noyau Linux
initialisation du master
récupération de la commande kubeadm join
exécution de cette commande sur le worker
installation du plugin réseau (par exemple Calico)

Imagine que tu es administratrice de 100 serveurs Ubuntu.

Sans Ansible :

SSH serveur1
apt update

SSH serveur2
apt update

SSH serveur3
apt update

...

Tu passes des heures.

Avec Ansible :

ansible-playbook site.yml

Ansible se connecte automatiquement à tous les serveurs en SSH et exécute les mêmes tâches.

Donc Ansible est simplement un orchestrateur SSH.



Les modules

Tu verras rarement des commandes shell dans un bon playbook.

On utilise des modules.

Par exemple :

Module	Sert à
apt	Installer des paquets
service	Démarrer un service
copy	Copier un fichier
template	Générer un fichier de configuration
file	Créer un dossier ou changer des permissions
user	Gérer des utilisateurs

On n'utilise shell ou command que lorsqu'il n'existe pas de module adapté (par exemple kubeadm init).


Les rôles

Imagine que ton playbook fait 600 lignes.

Impossible à maintenir.

On découpe alors par responsabilité.

roles/

    common/

    containerd/

    kubernetes/

    master/

    worker/

Chaque rôle fait une seule chose.

Par exemple :

containerd

installe uniquement containerd.

master

initialise uniquement le control plane.

worker

rejoint uniquement le cluster.



Terraform
    │
    ▼
Création des VM
    │
    ▼
Ansible (rôle common)
    │
    ├── apt update
    ├── installer paquets
    ├── désactiver swap
    ├── charger overlay
    ├── charger br_netfilter
    └── configurer sysctl
    │
    ▼
Ansible (rôle containerd)
    │
    ▼
Ansible (rôle kubernetes)
    │
    ├── installer kubelet
    ├── installer kubeadm
    └── installer kubectl
    │
    ▼
Ansible (rôle master)
    │
    └── kubeadm init
    │
    ▼
Ansible (rôle worker)
    │
    └── kubeadm join
    │
    ▼
Installation de Calico
    │
    ▼
Pods fonctionnels