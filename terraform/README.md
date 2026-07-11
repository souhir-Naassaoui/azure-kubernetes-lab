Azure Subscription
│
├── Resource Group (rg-k8s-lab)
│
├── Virtual Network (vnet-k8s)
│   ├── Subnet (subnet-private)
│
├── Network Security Group (NSG)
│   └── règles SSH limitées
│
├── Public IP (optionnel - seulement bastion)
│
├── NIC Master (privé)
├── NIC Worker (privé)
│
├── VM Master (kubeadm control plane)
└── VM Worker (node)

Le VPN Azure (Virtual Network Gateway) est exactement la solution “propre entreprise” pour accéder à des VM privées sans exposer SSH sur Internet

Azure VPN Gateway ? C’est un service qui crée un tunnel privé chiffré entre :

Ton PC (chez toi)
        │  VPN (IPSec/IKE)
        ▼
Azure Virtual Network (10.0.0.0/16)
        │
   VM privées (no public IP)

❌ Sans VPN
Ton PC
   │
   ├── Internet
   │
   └── VM Azure (public IP obligatoire)

👉 SSH passe par Internet → risqué

✅ Avec VPN
Ton PC
   │
   ─── VPN tunnel chiffré ───
   │
Azure VNet (10.0.0.0/16)
   │
   ├── VM Master (10.0.1.4)
   └── VM Worker (10.0.1.5)

👉 SSH passe comme si ton PC était dans Azure

Une fois connecté au VPN :
    tu peux SSH sur les VM privées
    elles n’ont AUCUNE IP publique
    ton réseau Azure devient comme ton réseau local

Architecture qu’on va construire ?
Resource Group
│
├── VNet 10.0.0.0/16
│   ├── subnet-vm (10.0.1.0/24)
│   ├── GatewaySubnet (obligatoire VPN)
│
├── VPN Gateway (AzureVpn)
├── Public IP (VPN only)
│
├── VM Master (private)
└── VM Worker (private)


Le VPN Azure nécessite :
    une subnet spéciale nommée GatewaySubnet
    une Public IP pour le VPN Gateway (pas pour les VM)
    du temps de provisioning (15–30 min)


Créer une branche
        |
        v
Pull Request vers main
        |
        v
GitHub Actions
        |
        └── terraform plan
              |
              v
        Review humaine
              |
              v
        Merge vers main
              |
              v
GitHub Actions
        |
        └── terraform apply
              |
              v
        Approval manuel avant apply