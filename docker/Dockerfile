FROM cm2network/steamcmd:root

# Install required packages
RUN apt-get update && apt-get install -y gosu cron wget python3 libfreetype6

# Set application ID for Palworld
ARG APPID=2394010

# Define environment variables
ENV PROTON_VERSION=GE-Proton10-10
ENV STEAM_HOME="/home/steam"
ENV STEAM_USER="steam"
ENV STEAM_PATH="/home/steam/.steam/steam"
ENV APPID=$APPID

# Create non-root user with UID 1001 and GID 1002 if not exists
RUN groupadd -g 1002 steamgroup || true &&     id -u steam || useradd -m -u 1001 -g steamgroup steam

# Create necessary directories
RUN mkdir -p ${STEAM_PATH} &&     mkdir -p ${STEAM_HOME}/compatibilitytools.d/ &&     mkdir -p ${STEAM_HOME}/steamapps/compatdata/${APPID} &&     mkdir -p ${STEAM_HOME}/.config/protonfixes

# Download and extract Proton
RUN wget -O -     https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${PROTON_VERSION}/${PROTON_VERSION}.tar.gz     | tar -xz -C ${STEAM_HOME}/compatibilitytools.d/

# Copy default_pfx for Proton
RUN cp -r ${STEAM_HOME}/compatibilitytools.d/${PROTON_VERSION}/files/share/default_pfx     ${STEAM_HOME}/steamapps/compatdata/${APPID}

# Set ownership to steam user
RUN chown -R 1001:1002 ${STEAM_HOME}

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=${STEAM_PATH}
ENV STEAM_COMPAT_DATA_PATH=${STEAM_PATH}/steamapps/compatdata/${APPID}
ENV PROTON=${STEAM_PATH}/compatibilitytools.d/${PROTON_VERSION}/proton

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Switch to non-root user
USER steam

# Set working directory
WORKDIR ${STEAM_HOME}

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
