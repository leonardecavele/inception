SUBJECT :

- use docker compose
- use docker-compose.yml in makefiles
- docker image must have the same name as corresponding service
- docker image must be penultimate stable version of debian


- A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
- A Docker container that contains WordPress + php-fpm (it must be installed and configured) only, without nginx.
- A Docker container that contains MariaDB only, without nginx.
- A volume that contains your WordPress database.
- A second volume that contains your WordPress website files.

- You must use Docker named volumes for these two persistent storages. Bind mounts are not allowed for these volumes.
- Both named volumes must store their data inside /home/login/data on the host machine. Replace "login" with your learner’s username.
- A docker-network that establishes the connection between your containers.
- Your containers have to restart in case of a crash.

- In your WordPress database, there must be two users, one of them being the administrator. The administrator’s username can’t contain admin/Admin or administrator/Administrator (e.g., admin, administrator, Administrator, admin-123, and so forth).
- Your volumes will be available in the /home/login/data folder of the host machine using Docker. Of course, you have to replace the login with yours.
- To make things simpler, you have to configure your domain name so it points to your local IP address. This domain name must be login.42.fr

NOTE :

- When PID1 stops, the docker closes. Use foreground instead of default daemon mode of commands.

- How to establish network :
```yml
services:
  backend:
    image: mon-backend
    networks:
      - mon-reseau

  database:
    image: postgres
    networks:
      - mon-reseau

networks:
  mon-reseau:
```

- The volumes are like a symlink between the docker and the host:
```yml
services:
  database:
    image: postgres
    volumes:
      - /home/ton_login/data/postgres:/var/lib/postgresql/data
    networks:
      - mon-reseau

networks:
  mon-reseau:
```

- It is mandatory to use environment variables.  Also, it is mandatory to use a .env file to store environment variables. It is strongly recommended that you use Docker secrets to store any confidential information. Any credentials, API keys, or passwords found in your Git repository (outside of properly configured secrets) will result in project failure.  Your NGINX container must be the only entrypoint into your infrastructure via the port 443 only, using the TLSv1.2 or TLSv1.3 protocol.
