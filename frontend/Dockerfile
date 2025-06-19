FROM ubuntu:22.04

# Install dependencies
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

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v

# Enable web and get dependencies
RUN flutter config --enable-web

WORKDIR /app
COPY pubspec.yaml .
RUN flutter pub get

# Copy the rest of the files
COPY . .

# Build web
RUN flutter build web --release

# Expose port and run
EXPOSE 5000
CMD ["flutter", "run", "--release", "--web-port", "5000", "--web-hostname", "0.0.0.0"]