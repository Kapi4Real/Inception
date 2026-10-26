Petit guide pour un dev qui veut lancer le projet rapidement.

Prérequis :
    Installer Docker et Docker Compose.
    Git pour cloner le repo.

1) Cloner et aller dans le dossier :

```bash
git clone <repo-url> inception
cd inception
```

2) Vérifier / modifier les variables dans `.env` si nécessaire.

3) Lancer tout (build + démarre) :

```bash
make up
```

4) Arrêter :

```bash
make stop
```

5) Tout supprimer (conteneurs + volumes) :

```bash
make down
```

Commandes utiles directes (sans Makefile) :
    `docker-compose ps` — lister   conteneurs
    `docker-compose logs -f`
suivre les logs
    `docker-compose exec wordpress sh` — ouvrir un shell dans WordPress

Où sont les données ?
    `volumes/mariadb` (base de données)
    `volumes/wordpress` (uploads, thèmes)

Astuce debug :
    Si 502 → vérifier que PHP-FPM écoute (dans `wordpress`) et que `nginx` pointe sur le bon port.
