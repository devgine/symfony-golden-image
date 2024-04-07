# Symfony docker image

[![Build](https://github.com/devgine/symfony-golden-image/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/devgine/symfony-golden-image/actions/workflows/build.yaml)
![GitHub top language](https://img.shields.io/github/languages/top/devgine/symfony-golden-image)
[![Packages retention policy](https://github.com/devgine/symfony-golden-image/actions/workflows/packages-retention-policy.yaml/badge.svg?branch=main)](https://github.com/devgine/symfony-golden-image/actions/workflows/packages-retention-policy.yaml)

![cover.png](.readme/images/cover.png)

## About
This repository is a docker image based on official php, composer and alpine docker images.<br>
This image contains symfony framework installed with all its required extensions.<br>
Below is the list of all the available images by Symfony and PHP versions:

<table>
    <thead>
        <tr>
            <th>SF Version</th>
            <th>PHP Version</th>
            <th>Docker image tag</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="2">7.0</td>
            <td>8.3</td>
            <td>
                <code>ghcr.io/devgine/symfony-golden:latest</code><br />
                <code>ghcr.io/devgine/symfony-golden:v7.0-php8.3-alpine</code>
            </td>
        </tr>
        <tr>
            <td>8.2</td>
            <td>
                <code>ghcr.io/devgine/symfony-golden:v7.0-php8.2-alpine</code>
            </td>
        </tr>
        <tr>
            <td rowspan="3">6.4</td>
            <td>8.3</td>
            <td>
                <code>ghcr.io/devgine/symfony-golden:v6.4-php8.3-alpine</code>
            </td>
        </tr>
        <tr>
            <td>8.2</td>
            <td>
                <code>ghcr.io/devgine/symfony-golden:v6.4-php8.2-alpine</code>
            </td>
        </tr>
        <tr>
            <td>8.1</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.4-php8.1-alpine</code></td>
        </tr>
        <tr>
            <td rowspan="3">6.3</td>
            <td>8.3</td>
            <td>
                <code>ghcr.io/devgine/symfony-golden:v6.3-php8.3-alpine</code>
            </td>
        </tr>
        <tr>
            <td>8.2</td>
            <td>
                <code>ghcr.io/devgine/symfony-golden:v6.3-php8.2-alpine</code>
            </td>
        </tr>
        <tr>
            <td>8.1</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.3-php8.1-alpine</code></td>
        </tr>
        <tr>
            <td rowspan="3">6.2</td>
            <td>8.3</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.2-php8.3-alpine</code></td>
        </tr>
        <tr>
            <td>8.2</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.2-php8.2-alpine</code></td>
        </tr>
        <tr>
            <td>8.1</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.2-php8.1-alpine</code></td>
        </tr>
        <tr>
            <td rowspan="3">6.1</td>
            <td>8.3</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.1-php8.3-alpine</code></td>
        </tr>
        <tr>
            <td>8.2</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.1-php8.2-alpine</code></td>
        </tr>
        <tr>
            <td>8.1</td>
            <td><code>ghcr.io/devgine/symfony-golden:v6.1-php8.1-alpine</code></td>
        </tr>
        <tr>
            <td rowspan="7">5.4</td>
            <td>8.3</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php8.3-alpine</code></td>
        </tr>
        <tr>
            <td>8.2</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php8.2-alpine</code></td>
        </tr>
        <tr>
            <td>8.1</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php8.1-alpine</code></td>
        </tr>
        <tr>
            <td>8.0</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php8.0-alpine</code></td>
        </tr>
        <tr>
            <td>7.4</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php7.4-alpine</code></td>
        </tr>
        <tr>
            <td>7.3</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php7.3-alpine</code></td>
        </tr>
        <tr>
            <td>7.2</td>
            <td><code>ghcr.io/devgine/symfony-golden:v5.4-php7.2-alpine</code></td>
        </tr>
    </tbody>
</table>

## Usage
### Install from the command line
```shell
docker run --rm -ti -p 8000:8000 ghcr.io/devgine/symfony-golden:latest sh
```
> You can change latest by a specific tag<br>
> [Available versions](https://github.com/devgine/symfony-golden-image/pkgs/container/symfony-golden/versions)

After the built-in, server will be started.<br>
Visit http://localhost:8000 in your web browser.

### Use as base image in Dockerfile
```dockerfile
FROM ghcr.io/devgine/symfony-golden:latest

# Add your custom instructions here
# example: install mongodb driver
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS openssl curl-dev openssl-dev \
    && pecl install mongodb
#...
```

### Use with docker-compose
```yaml
services:
  symfony:
    image: ghcr.io/devgine/symfony-golden:latest
    ports:
      - 8000:8000
```
Be careful, if you bind the symfony project as a volume, it will be erased by the local directory.<br>
To fix that, after your service running you can launch the below command inside the container.
```bash
new-symfony $DIRECTORY
# example
new-symfony /var/www
```

## References

* [Symfony releases](https://symfony.com/releases)
* [PHP releases](https://www.php.net/supported-versions.php)
