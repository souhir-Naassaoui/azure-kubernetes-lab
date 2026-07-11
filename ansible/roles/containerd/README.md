2. containerd

C'est la prochaine étape.

Pourquoi ?

Parce qu'un pod Kubernetes est constitué de conteneurs.

Quelqu'un doit créer ces conteneurs.

Ce n'est pas kubelet.

Ce n'est pas kubeadm.

C'est le runtime.

Kubelet
      │
      ▼
Containerd
      │
      ▼
Container Linux

Containerd est donc indispensable avant Kubernetes.

Le rôle containerd fera notamment :

Installer containerd

↓

Créer /etc/containerd/config.toml

↓

Activer SystemdCgroup=true

↓

Démarrer le service

↓

systemctl enable containerd

Cette configuration est importante, car kubelet et containerd doivent utiliser le même pilote de cgroups.