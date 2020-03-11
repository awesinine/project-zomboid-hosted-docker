FROM ubuntu:19.10

ENV SERVERNAME "servername"
ENV ADMINPASSWORD "adminpassword"
ENV RCON_PASSWORD "rconpassword"

ENV STEAMPORT1  8766
ENV STEAMPORT2  8767
ENV GAMEPORT   16261

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	curl \
    lib32gcc1 \
	default-jre \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN adduser \
	--disabled-login \
	--shell /bin/bash \
	--gecos "" \
	steam

COPY update.sh /home/steam/update.sh
COPY rcon /home/steam/rcon

RUN chmod 777 /home/steam/update.sh
RUN chmod 777 /home/steam/rcon
RUN mkdir -p /home/steam/Zomboid && chown -R steam /home/steam/Zomboid
RUN mkdir -p /home/steam/projectzomboid && chown -R steam /home/steam/projectzomboid

RUN ln -s /home/steam/projectzomboid /server-files && chown -R steam /server-files
RUN ln -s /home/steam/Zomboid /server-data && chown -R steam /server-data

USER steam

RUN mkdir /home/steam/steamcmd &&\
	cd /home/steam/steamcmd &&\
	curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -vxz

RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +quit

EXPOSE ${STEAMPORT1}
EXPOSE ${STEAMPORT2}
EXPOSE ${GAMEPORT}
EXPOSE 27015

VOLUME /server-files
VOLUME /server-data

ENTRYPOINT ["/home/steam/update.sh"]