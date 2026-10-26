Ce que contient la stack:
    `nginx` : sert le site (https) et redirige vers PHP.
    `wordpress` : le site WordPress (PHP-FPM).
    `mariadb` : la base de données.

Comment démarrer rapidement :

```bash
cd /home/kapi/Bureau/cpp/CPP/inception
docker-compose up --build -d
```

Comment arrêter :

```bash
docker-compose stop
```

Supprimer tout (conteneurs + volumes) :

```bash
docker-compose down -v --remove-orphans
```

Où va le site ?
    Ouvre : https://localhost
    Admin WP : https://localhost/wp-admin

Où sont les mots de passe ?
    Regarde le fichier `.env` à la racine. Exemple :

```
DB_USER=wordpress
DB_PASSWORD=wordpress123
WP_ADMIN=admin
WP_ADMIN_PASSWORD=admin123
```

Ne laisse pas de vrais mots de passe dans le dépôt si c'est public.

Comment vérifier si tout va bien :
    Voir les conteneurs : `docker-compose ps`
    Suivre les logs : `docker-compose logs -f`
    Tester le site : `curl -k -I https://localhost`

Où sont les données ?
    MariaDB : `volumes/mariadb`
    WordPress (uploads) : `volumes/wordpress`

Besoin d'aide pour une étape (installer un thème, créer l'utilisateur admin) ? Dis‑moi et je détaille.
