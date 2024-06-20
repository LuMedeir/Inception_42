# Define a imagem base para construir a partir dela
FROM debian:oldstable

ARG WORDPRESS_DATABASE
ARG WORDPRESS_USER
ARG WORDPRESS_PASSWORD

# Define o diretório de trabalho para os comandos RUN, COPY e ENTRYPOINT que seguem
WORKDIR /var/www/html/

# Atualiza os repositórios e instala os pacotes necessários
RUN apt update -y && \
    apt upgrade -y && \
    apt install php7.4 php-fpm php-mysql mariadb-client wget -y

# Baixa o WP-CLI (WordPress Command Line Interface) e configura o WordPress
RUN wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp \
	&& wp core download --allow-root --path=/var/www/html

# Cria o diretório onde o php-fpm irá armazenar o arquivo pid
RUN mkdir /run/php

# Define as permissões do diretório /var/www/html para garantir que ele seja acessível e seguro para o servidor web (Nginx) dentro do container.
RUN chown -R www-data:www-data /var/www/html \
	&& chmod 755 /var/www/html

# Copia o arquivo de configuração do php-fpm para o diretório correto dentro do container
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copia um script de configuração para o diretório temporário dentro do container
COPY tool/script.sh /tmp/wp_setup.sh

RUN chmod +x /tmp/wp_setup.sh

ENTRYPOINT ["/tmp/wp_setup.sh"]

