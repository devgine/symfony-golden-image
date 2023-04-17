ARG PHP_VERSION=8.2.0
ARG COMPOSER_VERSION=2.5.5

FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}-fpm-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer

## symfony cli install
RUN apk add --no-cache bash git
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash
RUN apk add symfony-cli
## END symfony cli install

### SYMFONY REQUIREMENT
RUN apk add --no-cache icu-dev \
  && docker-php-ext-install intl \
  && docker-php-ext-enable intl \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache

COPY .docker/symfony.ini /usr/local/etc/php/conf.d/
### END SYMFONY REQUIREMENT

WORKDIR /var/www/symfony

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD symfony check:req

CMD ["php-fpm", "-F"]

EXPOSE 9000

## ClEAN
RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

## LABELS
LABEL maintainer="yosribahri@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/devgine/symfony-golden-image"
LABEL org.opencontainers.image.description="Symfony golden image"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="devgine/symfony-golden"
LABEL org.label-schema.description="Symfony golden image"
LABEL org.label-schema.url="http://www.devengine.fr/"
LABEL org.label-schema.vcs-url="https://github.com/devgine/symfony-golden-image"
LABEL org.label-schema.vcs-ref=$VCS_REF
#LABEL org.label-schema.vendor="WSO2"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -d ghcr.io/devgine/symfony-golden"
