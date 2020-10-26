FROM zmaker123/dci-aojdk-hotspot-ubi:14-8.2-latest

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

# Install Helm CLI
RUN wget -q -O apache-jena.tar.gz https://apache.osuosl.org/jena/binaries/apache-jena-3.16.0.tar.gz \
    && mkdir -p /usr/local/bin/apache-jena \
    && tar xvf apache-jena.tar.gz -C /usr/local/bin/apache-jena --strip-components=1 \
    && rm apache-jena.tar.gz
ENV PATH=$PATH:/usr/local/bin/apache-jena/bin

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


WORKDIR /
COPY README.md entrypoint.sh image-info "/"

# Drop to non-root user
USER ${USERNAME}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["default"]