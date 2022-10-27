# Práctica DNS

## Lineas del docker-compose explicada
Lo primero que haremos será crear la carpeta "conf" con los archivos (named.conf , named.conf.local , named.conf.options) y la carpeta "zonas" con el archivo (db.asripractica1.com) además de crear el "docker-compose.yml" y el Readme.md que es donde estoy escribiendo ahora.

Lo primero que haremos será crear la subnet "bind9_subnetasir" con el siguiente comando

~~~
docker network create --subnet 10.28.0.0/16 --gateway 10.28.0.1 bind9_subnetasir
~~~

Después dentro del docker-compose creamos el services "asir_bind9_practica" y "asir_cliente_practica"

Para la configuracion de el primero, pondremos:

1. El nombre
2. La imagen
3. Los puertos (udp y tcp),
4. Una network a la que asignamos una IP fija
5. Los volumenes donde asignamos la conf y las zonas.

Para la configuracion de el cliente, pondremos:

1. El nombre
2. La imagen 
3. Una network donde pondremos un nombre
4. stdin_open y tty que pondremos en: True
5. Un DNS donde pondremos la Ip de arriba

Para acabar con el Docker-compose pondremos fuera de los services "networks"
Ahí pondremos lo mismo que en la network del cliente junto con un "external" que pondremos en True.

Código:

~~~
version: '3.3'
services:
  asir_bind9_practica:
    container_name: asir_bind9_practica
    image: internetsystemsconsortium/bind9:9.16
    ports:
      - 5300:53/udp
      - 5300:53/tcp
    networks:
      bind9_subnetasir:
        ipv4_address: 10.28.0.254
    volumes:
      - /home/hugo/Documentos/SRI/practica1/conf:/etc/bind
      - /home/hugo/Documentos/SRI/practica1/zonas:/var/lib/bind
  asir_cliente_practica:
    container_name: asir_cliente_practica
    image: alpine
    networks:
      - bind9_subnetasir
    stdin_open: true
    tty: true
    dns:
      -10.28.0.254
networks:
  bind9_subnetasir:
    external: true
~~~

## Archivos Carpeta /conf
Crearemos los siguientes 3 archivos para la configuración

### Named.conf
Pondremos los siguiente para separar la configuración en esos dos archivos

~~~
include "/etc/bind/named.conf.options";

include "/etc/bind/named.conf.local";
~~~

### Named.conf.local
Aquí colocaremos la zona

zone "asirpractica1.com

con lo siguiente
~~~
type master;
        file "/var/lib/bind/db.asirpractica1.com";
        notify explicit;
        allow-query {
                any;
                };
    };
~~~


### Named.conf.options

~~~
options {
        directory "/var/cache/bind";
        listen-on { any; };
        listen-on-v6 { any; };
        forwarders {
                8.8.8.8;
                8.8.4.4;
        };
        forward only;
        allow-recursion {
                none;
        };
        allow-transfer {
                none;
        };
        allow-update {
                none;
        };
        allow-query {
                any;
        };
};
~~~

## Archivos Carpeta /zonas
Crearemos el archivo

db.asirpractica1.com

Asignamos el TTL
~~~
$TTL    3600
~~~
Y crearemos los registros de todos los tipos que se nos pide

~~~
@       IN      SOA     ns.asirpractica1.com. hceamarin.danielcastelao.org. (
                   2022051001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.asirpractica1.com.
ns      IN      A       10.28.0.254
test    IN      A       10.28.0.2
alias   IN      A       11.11.11.11
ABC   	IN      TXT	    texto de muestra

pop     IN      CNAME   sid
www     IN      CNAME   sid
mail    IN      CNAME   sid
~~~

## Comprobar funcionamiento

Entramos en el cliente y usamo "ifconfig" para ver su ip, la cual es 10.20.0.2 que es la que asignamos en uno de los registros. 

Y con esa ip vamos al servidor y hacemos un ping.

![Si lees esto es que el link que use no funciona, por lo que para ver el ping entra en la imagen del Git](https://github.com/HugoCea/Practica1_DNS/blob/master/Ping.png)
