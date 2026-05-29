Layla Shabi
29/05/2026

SCHEMA ASCII

Client
|
v
HAProxy (load balancer)
| |
| |--> API1 (nginx)
| |--> API2 (nginx)
| |--> API3 (nginx)


lancer le cluster :
./scripts/deploy.sh start
./scripts/deploy.sh status


tester le failover:
lancer la commande while true; do curl -s http://localhost; done
laisser tourner

Dans un nouveau terminal, on retourne sur le réseau et on simule une panne d'un des container :
docker stop api2

observation : les 2 autres containers 1 et 3 prennent ils le relais ?
si oui : réussite 

ensuite on relance notre api2 : 
docker start api2



Difficultés rencontrées :
Il est possible que, lors de la création d’un conteneur, le port soit déjà utilisé par un autre service. Dans ce cas, il est nécessaire soit de supprimer le conteneur ou le service qui utilise ce port, soit de modifier le port d’exposition afin d’éviter le conflit.

Lors de plusieurs relances du TP, des conteneurs portant déjà les mêmes noms existaient, ce qui empêchait leur recréation. Une suppression préalable des anciens conteneurs a été nécessaire.

Une mauvaise configuration du fichier haproxy.cfg (syntaxe invalide ou commandes non supportées) empêchait le démarrage du service.

=======
Projet Streamflix - Cluster web en Haute Disponibilité

Création d'un cluster en roundbind avec 3 container via docker, afin d'assurer la haute disponibilité
>>>>>>> b35580c259dbcc22ecbfef6592a237376ca5c6a8
