FROM cm2network/steamcmd:root

# Install required packages
RUN apt-get update && apt-get install -y gosu cron wget python3 libfreetype6

# Create non-root user with UID 1001 and GID 1002
RUN groupadd -g 1002 steamgroup && \
    useradd -m -u 1001 -g steamgroup steam

# Set environment variables
ENV STEAM_HOME="/home/steam" \
    STEAM_USER="steam" \
    STEAM_PATH="/home/steam/.steam/steam" \
    APPID=2394010

# Create necessary directories
RUN mkdir -p ${STEAM_PATH} && \
    mkdir -p ${STEAM_HOME}/compatibilitytools.d && \
    mkdir -p ${STEAM_HOME}/steamapps/compatdata/${APPID} && \
    mkdir -p ${STEAM_HOME}/.config/protonfixes

# Set working directory
WORKDIR ${STEAM_PATH}

# Install Proton build from Glorious Eggroll
ENV PROTON_VERSION=GE-Proton10-10
RUN wget -O - \
    https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${PROTON_VERSION}/${PROTON_VERSION}.tar.gz \
    | tar -xz -C ${STEAM_HOME}/compatibilitytools.d/
RUN cp -r ${STEAM_HOME}/compatibilitytools.d/${PROTON_VERSION}/files/share/default_pfx ${STEAM_HOME}/steamapps/compatdata/${APPID}

# Set ownership to steam user
RUN chown -R steam:steam ${STEAM_HOME}

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=${STEAM_HOME}
ENV STEAM_COMPAT_DATA_PATH=${STEAM_HOME}/steamapps/compatdata/${APPID}
ENV PROTON=${STEAM_HOME}/compatibilitytools.d/${PROTON_VERSION}/proton

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Switch to steam user
USER steam

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
