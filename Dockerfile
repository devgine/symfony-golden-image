ARG PHP_VERSION=8
ARG COMPOSER_VERSION=2

FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}-fpm-alpine

ARG SYMFONY_VERSION=6.2
ENV SYMFONY_VERSION $SYMFONY_VERSION

ARG SYMFONY_PACK
ENV SYMFONY_PACK $SYMFONY_PACK

COPY --from=composer /usr/bin/composer /usr/bin/composer

### SYMFONY REQUIREMENT
RUN apk add --no-cache icu-dev \
  && docker-php-ext-install intl \
  && docker-php-ext-enable intl \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache

COPY .docker/docker-symfony-golden.ini /usr/local/etc/php/conf.d/
### END SYMFONY REQUIREMENT

## SYMFONY CLI INSTALL
RUN apk add --no-cache bash git
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash
RUN apk add symfony-cli
## END SYMFONY CLI INSTALL

# HEALTHCHECK
HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD symfony check:req || exit 1
# END HEALTHCHECK

WORKDIR /var/www

RUN symfony new symfony --no-git --version="$SYMFONY_VERSION" $SYMFONY_PACK

WORKDIR /var/www/symfony

EXPOSE 8000

CMD ["symfony", "server:start"]

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION
ARG IMAGE_TAG=ghcr.io/devgine/symfony-golden:latest

## LABELS
LABEL maintainer="yosribahri@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/devgine/symfony-golden-image"
LABEL org.opencontainers.image.description="Symfony golden image"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="devgine/symfony-golden"
LABEL org.label-schema.description="Symfony golden image"
LABEL org.label-schema.url="https://github.com/devgine/symfony-golden-image"
LABEL org.label-schema.vcs-url="https://github.com/devgine/symfony-golden-image"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="devgine"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run --rm -ti -v PROJECT_DIR:/var/www/symfony $IMAGE_TAG sh"

## ClEAN
RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*
