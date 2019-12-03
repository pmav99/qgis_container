FROM qgis/qgis:latest

USER root

# Configure apt
RUN set -xeu; \
    echo 'APT::Install-Recommends "false";' | tee -a /etc/apt/apt.conf.d/99-install-suggests-recommends; \
    echo 'APT::Install-Suggests "false";' | tee -a /etc/apt/apt.conf.d/99-install-suggests-recommends; \
    echo 'Configuring apt: OK';

# Setup the locales
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en
RUN set -xeu; \
    apt update; \
    apt upgrade -yq; \
    apt install -yq locales; \
    sed -i -e "s/# ${LANG} UTF-8/${LANG} UTF-8/" /etc/locale.gen; \
    dpkg-reconfigure --frontend=noninteractive locales; \
    update-locale LANG=${LANG}; \
    apt autoremove -y; \
    find / -xdev -name *.pyc -delete; \
    rm -rf /var/lib/apt/lists/*; \
    echo 'Setting locales: OK';

# Setup the timezone
# ENV TZ=Etc/UTC
ENV TZ=Europe/Rome
RUN set -xeu; \
    apt update; \
    apt install -yq tzdata; \
    ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime; \
    echo "${TZ}" | tee /etc/timezone; \
    dpkg-reconfigure tzdata; \
    apt autoremove -y; \
    find / -xdev -name *.pyc -delete; \
    rm -rf /var/lib/apt/lists/*; \
    echo 'Setting timezone: OK';

# Install basic packages
RUN set -xeu; \
    apt update; \
    apt install software-properties-common; \
    add-apt-repository ppa:ubuntugis/ppa; \
    apt install -yq --no-install-recommends \
        bsdtar \
        bzip2 \
        ca-certificates \
        curl \
        git \
        gzip \
        jq \
        procps \
        silversearcher-ag \
        tar \
        tree \
        unzip \
        vim \
        wget \
        zip \
        sudo \
        #
        python3-venv \
        grass-dev \
        grass-core \
        grass-doc \
        grass \
    ; \
    apt autoremove -y; \
    find / -xdev -name *.pyc -delete; \
    rm -rf /var/lib/apt/lists/*; \
    echo 'Installation of basic packages: OK';

# create the user
# for the password hash you can use: mkpasswd -m sha-512
ARG USER_NAME
ARG USER_ID
ARG GROUP_ID
ENV USER_NAME=${USER_NAME}
ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}
ENV PASSWORD_HASH='$6$g6wLdWQBGCgRQl$jpocuxWtXosn8U3iiEmCU1Cychu7msiNklti4r986t86PmMX.A2D5D7ynDqJ.Q9StAWDqf1Z2ja9rOmNTyn3t0'
RUN set -xeu; \
    groupadd -f -g ${GROUP_ID} user_group; \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/bash -G sudo -p "${PASSWORD_HASH}" "$USER_NAME"; \
    echo 'User creation: OK'

USER $USER_NAME
