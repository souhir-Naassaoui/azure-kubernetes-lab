Pourquoi un rôle common ?

Parce qu'il y a des actions identiques sur le master et le worker.

Par exemple :

mise à jour des paquets,
désactivation du swap,
chargement des modules du noyau,
configuration de sysctl,
installation de paquets de base.

On ne veut pas copier ces tâches deux fois.

Le rôle common les exécutera sur toutes les VM.