FROM ubuntu:20.04

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Installer Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v
RUN flutter config --enable-web

WORKDIR /app
COPY . .

RUN flutter pub get
CMD ["flutter", "run", "-d", "web-server", "--web-port", "5000", "--web-hostname", "0.0.0.0"]