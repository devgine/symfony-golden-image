ARG PHP_VERSION=8.4
ARG COMPOSER_VERSION=2.5

FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}-fpm-alpine

ARG SG_SERVER_ENABLED=true
ENV SG_SERVER_ENABLED=$SG_SERVER_ENABLED

ENV PHP_VERSION=$PHP_VERSION
ENV COMPOSER_VERSION=$COMPOSER_VERSION
ARG SYMFONY_VERSION=7.2
ENV SYMFONY_VERSION=$SYMFONY_VERSION
ARG SFUSER=symfony
ENV SFUSER=$SFUSER
ARG SYMFONY_BUILD_PROJECT=/home/$SFUSER/build
ENV SYMFONY_BUILD_PROJECT=$SYMFONY_BUILD_PROJECT
ARG SYMFONY_PROJECT_DIRECTORY_NAME=symfony
ENV SYMFONY_PROJECT_DIRECTORY_NAME=$SYMFONY_PROJECT_DIRECTORY_NAME
ARG DOCKER_WORKING_DIRECTORY=/var/www
ENV DOCKER_WORKING_DIRECTORY=$DOCKER_WORKING_DIRECTORY

COPY --from=composer /usr/bin/composer /usr/bin/composer

### SYMFONY REQUIREMENT
RUN apk add --no-cache icu-dev acl \
  && docker-php-ext-install intl \
  && docker-php-ext-enable intl \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache

COPY .docker/docker-symfony.ini /usr/local/etc/php/conf.d/
### END SYMFONY REQUIREMENT

COPY ./.docker/new-symfony.sh /usr/local/bin/new-symfony
RUN chmod +x /usr/local/bin/new-symfony
COPY ./.docker/docker-symfony-entrypoint.sh /usr/local/bin/docker-symfony-entrypoint
RUN chmod +x /usr/local/bin/docker-symfony-entrypoint

## SYMFONY CLI INSTALL
RUN apk add --no-cache bash git
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash
RUN apk add symfony-cli
## END SYMFONY CLI INSTALL

# HEALTHCHECK
HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD symfony check:req || exit 1
# END HEALTHCHECK

EXPOSE 8000

## Create container user
ARG UID=1001
ENV UID $UID
ARG GID=1001
ENV GID $GID

RUN apk add --no-cache sudo
RUN addgroup --system --gid $GID $SFUSER
RUN echo "$SFUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$SFUSER
RUN chmod 0440 /etc/sudoers.d/$SFUSER
RUN adduser --system --uid $UID --ingroup $SFUSER $SFUSER

USER $SFUSER

RUN new-symfony $SYMFONY_BUILD_PROJECT

WORKDIR $DOCKER_WORKING_DIRECTORY/$SYMFONY_PROJECT_DIRECTORY_NAME

ENTRYPOINT ["docker-symfony-entrypoint"]
CMD ["php-fpm", "-F"]

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION
ARG IMAGE_TAG=ghcr.io/devgine/symfony-golden:latest

## LABELS
LABEL maintainer="yosribahri@gmail.com"
LABEL org.opencontainers.image.title="Symfony v$SYMFONY_VERSION PHP-fpm $PHP_VERSION docker image"
LABEL org.opencontainers.image.description="This is a docker image based on official alpine image, PHP-fpm \
$PHP_VERSION and composer v$COMPOSER_VERSION. This image contains the symfony v$SYMFONY_VERSION installed with \
symfony-cli and all extensions required by the framework."
LABEL org.opencontainers.image.source="https://github.com/devgine/symfony-golden-image"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.url="https://github.com/devgine/symfony-golden-image"
LABEL org.opencontainers.image.version=$BUILD_VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.vendor="devgine"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="devgine/symfony-golden"
LABEL org.label-schema.description="This is a docker image based on official alpine image, PHP-fpm \
$PHP_VERSION and composer v$COMPOSER_VERSION. This image contains the symfony v$SYMFONY_VERSION installed with \
symfony-cli and all extensions required by the framework."
LABEL org.label-schema.url="https://github.com/devgine/symfony-golden-image"
LABEL org.label-schema.vcs-url="https://github.com/devgine/symfony-golden-image"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="devgine"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run --rm -ti -v PROJECT_DIR:/var/www/symfony $IMAGE_TAG sh"

## ClEAN
RUN sudo rm -rf /tmp/* /var/cache/apk/* /var/tmp/*
