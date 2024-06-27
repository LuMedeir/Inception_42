# Define a imagem base a ser utilizada como ponto de partida
FROM debian:oldstable

# Atualiza os pacotes existentes e instala o Nginx e OpenSSL
RUN apt update -y && apt upgrade -y && \
    apt install nginx openssl -y

# Gera um certificado autoassinado para SSL/TLS
RUN openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 \
# Define o local e nome do arquivo da chave privada.
-keyout /etc/ssl/private/private.key \
# Define o local e nome do arquivo do certificado.
-out /etc/ssl/certs/certificate.crt \
# Especifica os detalhes do certificado, como país, estado, localidade, organização e nome comum.
-subj "/C=BR/ST=SP/L=Sao Paulo/O=42sp/CN=lumedeir.42.fr"

# Copia o arquivo de configuração do Nginx para dentro do container
COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN chmod 755 /var/www
RUN chown -R www-data:www-data /var/www

# inicia o servidor Nginx com a opção -g "daemon off;", que mantém 
# o processo do Nginx em primeiro plano para que o Docker possa 
# gerenciar seu ciclo de vida corretamente.
CMD ["nginx", "-g", "daemon off;"]
