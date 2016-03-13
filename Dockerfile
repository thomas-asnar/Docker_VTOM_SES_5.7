# On se base sur l'image de la dernière debian
FROM debian:latest 

MAINTAINER thomas ASNAR <thomas.asnar@gmail.com>

# L'installation de VTOM nécessite ksh
RUN apt-get update
RUN apt-get install ksh

# On créé le répertoire d'installation de VTOM
RUN mkdir /opt/vtom 
# On créé le user d'administration vtom
RUN useradd -d /opt/vtom -s /usr/bin/ksh vtom
RUN chown vtom /opt/vtom

# On prépare les répertoires pour acceuilir les sources d'installation de VTOM
RUN mkdir /sources
RUN mkdir /sources/SES

# On copie les fichiers du repo dans SES/
COPY SES /sources/SES/

# on supprime les ^M si on utilise docker depuis windows
RUN sed -i 's/\r$//g' /sources/SES/install_vtom.ini
RUN sed -i 's/\r$//g' /sources/SES/dockerinit.ksh
RUN sed -i 's/\r$//g' /sources/SES/install_vtom

# A chaque lancement d'image, on commence le conteneur avec le script d'installation VTOM
ENTRYPOINT ["/usr/bin/ksh"]
CMD ["-c","/sources/SES/dockerinit.ksh ;/bin/bash"]
