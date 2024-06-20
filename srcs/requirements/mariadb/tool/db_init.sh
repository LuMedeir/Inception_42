#!/bin/bash

# Esse script automatiza a configuração inicial do MariaDB para um ambiente onde 
# o WordPress será configurado posteriormente. Ele inicia o serviço do MariaDB, 
# cria um banco de dados, um usuário específico para o WordPress, concede todos 
# os privilégios necessários ao usuário sobre o banco de dados e garante que as 
# alterações sejam aplicadas imediatamente.

service mariadb start

mariadb -u root -e \
    "CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DATABASE}; \
    CREATE USER '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}'; \
    GRANT ALL ON ${WORDPRESS_DATABASE}.* TO '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}'; \
    FLUSH PRIVILEGES;"
