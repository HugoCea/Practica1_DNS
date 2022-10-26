$TTL    3600
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