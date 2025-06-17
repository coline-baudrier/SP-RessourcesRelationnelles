FROM ubuntu:22.04

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer Flutter (version stable)
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Vérifier l'installation
RUN flutter doctor -v

# Activer le support web et construire l'application
RUN flutter config --enable-web
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web

# Exposer le port et démarrer le serveur web
EXPOSE 5000
CMD ["flutter", "run", "--release", "-d", "web-server", "--web-port", "5000", "--web-hostname", "0.0.0.0", "--verbose"]