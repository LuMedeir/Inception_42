#!/usr/bin/env bash

# Esse script automatiza a configuração inicial do WordPress dentro 
# de um contêiner Docker, instalar o WordPress, configurar o banco de 
# dados e aguardar até que o banco de dados esteja pronto antes de iniciar 
# o PHP-FPM para servir o site WordPress.


# Configura o arquivo wp-config.php com as credenciais do banco de dados.
wp --allow-root config create \
	--path=/var/www/html \
	--dbname="$WORDPRESS_DATABASE" \
	--dbuser="$WORDPRESS_USER" \
	--dbpass="$WORDPRESS_PASSWORD" \
	--dbhost=mariadb \
	--dbprefix="wp_"

# Cria o usuário administrador do WordPress e configura outras opções básicas, como título do site e URL.
wp core install --allow-root \
	--path=/var/www/html \
	--title="Inception" \
	--url=lumedeir.42.fr \
	--admin_user=$WORDPRESS_USER \
	--admin_password=$WORDPRESS_PASSWORD \
	--admin_email=user@email.com

while ! wp db check --allow-root --path=/var/www/html/; do
	echo "Waiting for Database to be ready..."
	sleep 1
done


# O comando exec é utilizado no shell script para substituir o processo atual pelo processo especificado. 
exec php-fpm7.4 -F
