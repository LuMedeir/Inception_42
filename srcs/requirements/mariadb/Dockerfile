# Define a imagem base a ser utilizada como ponto de partida
FROM debian:oldstable

ARG WORDPRESS_DATABASE
ARG WORDPRESS_USER
ARG WORDPRESS_PASSWORD

# Atualiza os repositórios e instala o servidor MariaDB
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install mariadb-server -y

# Cria o diretório onde o MariaDB irá armazenar o arquivo de pid e define as permissões
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Copia o arquivo de configuração my.cnf para dentro do contêiner
COPY conf/my.cnf /etc/mysql/my.cnf
# Copia um script de inicialização do banco de dados para dentro do contêiner
COPY tool/db_init.sh /tmp/db_init.sh

RUN chmod 777 /tmp/db_init.sh && bash /tmp/db_init.sh

# Define o comando padrão que será executado ao iniciar o contêiner Docker. 
# Neste caso, mysqld_safe é utilizado para iniciar o servidor MariaDB de forma segura.
CMD ["mysqld_safe"]

