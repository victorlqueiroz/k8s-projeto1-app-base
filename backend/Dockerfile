FROM php:8.0.30-apache-bullseye

# Install dependencies and PHP extensions first (before user creation for proper permissions)
RUN apt-get update && apt-get install -y \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user and set permissions
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /var/www/html

WORKDIR /var/www/html

# Copy application files
COPY --chown=appuser:appuser index.php /var/www/html/
COPY --chown=appuser:appuser conexao.php /var/www/html/

# Switch to non-root user
USER appuser

# Podman-optimized healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Podman specific labels for better integration
LABEL io.podman.annotations.healthcheck.test="curl -f http://localhost/ || exit 1"
LABEL io.podman.annotations.healthcheck.interval="30s"
LABEL io.podman.annotations.healthcheck.timeout="3s"
LABEL io.podman.annotations.healthcheck.start-period="5s"

# Additional Podman-friendly labels
LABEL io.podman.annotations.userns="keep-id"
LABEL io.podman.annotations.privileged="false"