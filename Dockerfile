FROM centos/s2i-base-centos7

EXPOSE 8080

ENV NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN chown -R 1001:0 ${APP_ROOT} && chmod -R ug+rwx ${APP_ROOT} && \
    rpm-file-permissions

COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./root/ /

USER 1001
RUN scl enable rh-nodejs8 "npm install -g static-server gitbook-cli && gitbook fetch 3.2.3"
