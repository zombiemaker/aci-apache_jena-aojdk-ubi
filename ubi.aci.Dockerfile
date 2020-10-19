FROM docker.io/zmaker123/osci-ubi:8.2-latest

USER root
ARG USERNAME=me
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Keep every item on a separate line to make version control code change review easier

# Add CentOS repos to get additional packages
RUN echo "[centos-8-stream-appstream]" > /etc/yum.repos.d/centos.repo \
    && echo "name=CentOS-8 Stream - appStream" >> /etc/yum.repos.d/centos.repo \
    && echo "baseurl=http://www.gtlib.gatech.edu/pub/centos/8-stream/AppStream/x86_64/os" >> /etc/yum.repos.d/centos.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/centos.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/centos.repo \
    && echo "[centos-8-stream-BaseOS]" >> /etc/yum.repos.d/centos.repo \
    && echo "name=CentOS-8 Stream - BaseOS" >> /etc/yum.repos.d/centos.repo \
    && echo "baseurl=http://www.gtlib.gatech.edu/pub/centos/8-stream/BaseOS/x86_64/os" >> /etc/yum.repos.d/centos.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/centos.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/centos.repo \
    && echo "[centos-8-stream-PowerTools]" >> /etc/yum.repos.d/centos.repo \
    && echo "name=CentOS-8 Stream - PowerTools" >> /etc/yum.repos.d/centos.repo \
    && echo "baseurl=http://www.gtlib.gatech.edu/pub/centos/8-stream/PowerTools/x86_64/os/" >> /etc/yum.repos.d/centos.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/centos.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/centos.repo \
    && echo "[centos-8-stream-extras]" >> /etc/yum.repos.d/centos.repo \
    && echo "name=CentOS-8 Stream - extras" >> /etc/yum.repos.d/centos.repo \
    && echo "baseurl=http://www.gtlib.gatech.edu/pub/centos/8-stream/extras/x86_64/os/" >> /etc/yum.repos.d/centos.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/centos.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/centos.repo \
    && echo "[centos-8-stream-HighAvailability]" >> /etc/yum.repos.d/centos.repo \
    && echo "name=CentOS-8 Stream - HighAvailability" >> /etc/yum.repos.d/centos.repo \
    && echo "baseurl=http://www.gtlib.gatech.edu/pub/centos/8-stream/HighAvailability/x86_64/os/" >> /etc/yum.repos.d/centos.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/centos.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/centos.repo \
    && microdnf install \
        sudo \
        vi \
        which \
    && microdnf clean all

RUN groupadd \
        --gid $USER_GID \
        $USERNAME \
    && useradd \
        -s /bin/bash \
        --uid $USER_UID \
        --gid $USER_GID \
        --system \
        --home /home/$USERNAME \
        -m \
        $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# curl, wget, and git for retrieving content
# unzip and tar for extraction
# gettext for ?
# procps-ng for commands like process commands: watch, ps, top, slabtop, kill
# tree for showing directory structure
# python for running Python programs like jq, yq, jason2yaml
# jq for parsing JSON data
# yq for parsing YAML data
# json2yam for transforming JSON to YAML
# bash-completion to support CLI programs that use bash completion like kubectl, gcloud, aws, az, helm
RUN microdnf install \
        curl \
        wget \
        git \
        unzip \
        tar \
        gettext \
        procps-ng \
        tree \
        python38 \
        python38-wheel \
        python38-pip \
        python38-pip-wheel \
        jq-1.5 \
        bash-completion \
    && microdnf clean all \
    && pip3 install yq \
    && pip3 install json2yaml

# Get values from docker build CLI args
ARG IMAGE_SOURCECODE_GIT_REPO_URL=
ARG IMAGE_SOURCECODE_GIT_BRANCH=
ARG IMAGE_SOURCECODE_GIT_COMMIT_HASH=
ARG IMAGE_SOURCECODE_GIT_COMMIT_TAG=
ARG IMAGE_SOURCECODE_GIT_COMMITTER_NAME=
ARG IMAGE_SOURCECODE_GIT_COMMITTER_DATE=
ARG IMAGE_CLASS=
ARG IMAGE_OS_BRAND=ubi
ARG IMAGE_OS_VERSION=8.2
ARG APP_PLATFORM_BRAND=
ARG APP_PLATFORM_VERSION=
ARG APP_BRAND=
ARG APP_VERSION=
ARG APP_SOURCECODE_GIT_REPO_URL=
ARG APP_SOURCECODE_GIT_BRANCH=
ARG APP_SOURCECODE_GIT_COMMIT_HASH=
ARG APP_SOURCECODE_GIT_COMMIT_TAG=
ARG APP_SOURCECODE_GIT_COMMITTER_NAME=
ARG APP_SOURCECODE_GIT_COMMITTER_DATE=

LABEL \
    image.sourcecode.git.repo.url="$IMAGE_SOURCECODE_GIT_REPO_URL" \
    image.sourcecode.git.branch="$IMAGE_SOURCECODE_GIT_BRANCH" \
    image.sourcecode.git.tag="$IMAGE_SOURCECODE_GIT_TAG" \
    image.sourcecode.git.commit.hash="$IMAGE_SOURCECODE_GIT_COMMIT_HASH" \
    image.sourcecode.git.committer.name="$IMAGE_SOURCECODE_GIT_COMMITTER_NAME" \
    image.sourcecode.git.committer.date="$IMAGE_SOURCECODE_GIT_COMMITTER_DATE" \
    image.os.brand="$IMAGE_OS_BRAND" \
    image.os.version="$IMAGE_OS_VERSION" \
    app.plt.brand="$APP_PLATFORM_BRAND" \
    app.plt.version="$APP_PLATFORM_VERSION" \
    app.brand="$APP_BRAND" \
    app.version="$APP_VERSION" \
    app.sourcecode.git.repo.url="$APP_SOURCECODE_GIT_REPO_URL" \
    app.sourcecode.git.branch="$APP_SOURCECODE_GIT_BRANCH" \
    app.sourcecode.git.tag="$APP_SOURCECODE_GIT_TAG" \
    app.sourcecode.git.commit.hash="$APP_SOURCECODE_GIT_COMMIT_HASH" \
    app.sourcecode.git.committer.name="$APP_SOURCECODE_GIT_COMMITTER_NAME" \
    app.sourcecode.git.committer.date="$APP_SOURCECODE_GIT_COMMITTER_DATE" 

# Drop to non-root user
USER ${USERNAME}

# Default startup program
ENTRYPOINT ["/entrypoint.sh"]
# Default parameters passed to entrypoint
CMD ["default"]