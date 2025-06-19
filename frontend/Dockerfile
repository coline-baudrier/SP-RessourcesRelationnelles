FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web and get dependencies
RUN flutter config --enable-web

WORKDIR /app
COPY pubspec.yaml .
RUN flutter pub get

# Copy the rest of the files
COPY . .

# Build web
RUN flutter build web --release

# Install simple HTTP server
RUN apt-get update && apt-get install -y python3

# Expose port and run
EXPOSE 5000
CMD ["python3", "-m", "http.server", "5000", "--directory", "build/web"]