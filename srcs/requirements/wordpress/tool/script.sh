#!/usr/bin/env bash

wp --allow-root config create \
	--path=/var/www/html \
	--dbname="$WORDPRESS_DATABASE" \
	--dbuser="$WORDPRESS_USER" \
	--dbpass="$WORDPRESS_PASSWORD" \
	--dbhost=mariadb \
	--dbprefix="wp_"

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

exec php-fpm7.4 -F
