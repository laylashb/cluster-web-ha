# **Projet Streamflix - Cluster web en Haute Disponibilité**


### Mise en place d’un cluster de 3 conteneurs Docker avec un équilibrage de charge en round-robin via HAProxy, afin d’assurer la haute disponibilité et la répartition du trafic entre les services.


Par Layla Shabi
*Le 29/05/2026*


## SCHEMA ASCII

Client
|
v
HAProxy (load balancer)
| |
| |--> API1 (nginx)
| |--> API2 (nginx)
| |--> API3 (nginx)


## lancer le cluster :
**./scripts/deploy.sh start
./scripts/deploy.sh status**


## Test du failover

Pour tester le mécanisme de failover, exécuter la commande suivante afin de simuler un flux continu vers le load balancer :
**while true; do curl -s http://localhost; done**
Laisser la commande s’exécuter.

Dans un second terminal, simuler une panne d’un des conteneurs :
**docker stop api2**

Observation
Vérifier si les conteneurs restants (api1 et api3) prennent automatiquement le relais dans la rotation.

Si oui : le failover fonctionne correctement ✔
Si non : il y a un problème de configuration du load balancer
Réintégration du service

Relancer le conteneur arrêté :
**docker start api2**

Observer ensuite sa réintégration automatique dans la rotation du load balancing.



## Difficultés rencontrées :

1-conflit de ports 
Il est possible que, lors de la création d’un conteneur, le port soit déjà utilisé par un autre service. Dans ce cas, il est nécessaire soit de supprimer le conteneur ou le service qui utilise ce port, soit de modifier le port d’exposition afin d’éviter le conflit.

2- Conflits de noms de conteneurs
Lors de plusieurs relances du TP, des conteneurs portant déjà les mêmes noms existaient, ce qui empêchait leur recréation. Une suppression préalable des anciens conteneurs a été nécessaire.

3- Configuration haproxy.cfg défaillante
Une mauvaise configuration du fichier haproxy.cfg (syntaxe invalide ou commandes non supportées) empêchait le démarrage du service.
