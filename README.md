# Akeneo PHP-FPM Dockerfile

This repository contains a Dockerfile for running **Akeneo PIM Community Standard** using PHP 8.1-FPM. The image is pre-configured with the necessary dependencies, PHP extensions, and tools required to build and run an Akeneo application seamlessly.

---

## Features

- **Base Image**: Built on `php:8.1-fpm`.
- **Dependencies**: Includes essential libraries such as `libgd`, `libxml2-dev`, `nodejs`, and `npm`.
- **PHP Extensions**: Fully configured and installed extensions like `bcmath`, `intl`, `pdo_mysql`, `soap`, `xsl`, and others.
- **Composer**: Installed globally for managing PHP dependencies.
- **Yarn**: Installed globally for front-end package management.
- **Non-root User**: Runs the application under a non-root user (`app`) for added security.
- **Port 9000**: Configured for PHP-FPM to handle incoming requests.

---

## Prerequisites

- Docker installed on your machine.
- Akeneo PIM Community Standard application files.

---

## How to Use

### Build the Docker Image

1. Clone this repository:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. Build the image:
   ```bash
   docker build -t akeneo-php-fpm .
   ```

---

### Run the Container

1. Start the container:
   ```bash
   docker run -d --name akeneo-container -p 9000:9000 -v $(pwd):/var/www/akeneo/pim-community-standard akeneo-php-fpm
   ```

2. Access the container shell (if needed):
   ```bash
   docker exec -it akeneo-container bash
   ```

---

### File Structure

The application files should be located in:  
`/var/www/akeneo/pim-community-standard`

Mount your Akeneo application to this directory when running the container using the `-v` flag.

---

## Installed Tools and Extensions

### Tools
- **Utilities**: `curl`, `vim`, `unzip`, `git`, `mycli`, `supervisor`
- **Front-end**: `nodejs`, `npm`, `yarn`, `browserslist`
- **Image Optimization**: `jpegoptim`, `optipng`, `pngquant`, `gifsicle`

### PHP Extensions
- **Core Extensions**: `bcmath`, `calendar`, `pdo_mysql`, `soap`, `intl`, `mbstring`, `zip`
- **Others**: `gd`, `imagick`, `apcu`, `swoole`

---

## Environment Variables

This Dockerfile includes `Composer` in the `PATH` for easy access:
```bash
ENV PATH="/usr/local/bin:$PATH"
```

---

## Exposed Port

- **9000**: PHP-FPM listens on this port by default. Map it to a port on your host machine as needed.

---

## Customization

- **PHP Configuration**: Create and mount a custom `php.ini` to modify PHP settings.
- **Additional Extensions**: Update the `RUN docker-php-ext-install` section in the Dockerfile to add more extensions.

---

## Security Notes

The application runs as a non-root user (`app`) to improve security and reduce risks. Ensure that your application files are accessible by this user (`uid: 1000, gid: 1000`).

---

## Troubleshooting

- **File Permissions**: If you encounter issues with file permissions, ensure the files in your mounted directory are owned by `uid: 1000` or adjust ownership accordingly.
- **Missing Dependencies**: If the container requires additional tools or libraries, update the `apt-get install` section in the Dockerfile.

---

## Conclusion

This Dockerfile provides a fully-featured, pre-configured environment for running Akeneo PIM Community Standard with PHP 8.1-FPM. Use it to streamline your development or deployment workflows. Contributions and suggestions for improvement are welcome!
