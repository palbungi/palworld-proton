FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y gosu cron wget python3 libfreetype6

ARG APPID=2394010
ARG USER=steam

ENV USER=${USER}
ENV STEAM_HOME="/home/${USER}" \
    STEAM_USER="${USER}" \
    STEAM_PATH="/home/${USER}/.steam/steam" \
    APPID=$APPID

RUN mkdir -p ${STEAM_PATH} /app/PalServer

# 권한을 1001:1002로 설정
RUN chown -R 1001:1002 ${STEAM_PATH} /app/PalServer

WORKDIR ${STEAM_PATH}

ENV PROTON_VERSION=GE-Proton10-10

RUN mkdir -p compatibilitytools.d/
RUN wget -O - \
    https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${PROTON_VERSION}/${PROTON_VERSION}.tar.gz \
    | tar -xz -C compatibilitytools.d/
RUN mkdir -p steamapps/compatdata/${APPID}
RUN cp -r compatibilitytools.d/${PROTON_VERSION}/files/share/default_pfx steamapps/compatdata/${APPID}
RUN mkdir -p .config/protonfixes

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_PATH
ENV STEAM_COMPAT_DATA_PATH=${STEAM_PATH}/steamapps/compatdata/${APPID}
ENV PROTON=${STEAM_PATH}/compatibilitytools.d/${PROTON_VERSION}/proton

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# 컨테이너 실행 사용자 설정
USER 1001:1002

ENTRYPOINT ["/docker-entrypoint.sh"]
