# Stage 1: Build Flutter Web
FROM debian:latest AS build-env

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Setup Flutter
RUN flutter doctor
RUN flutter config --enable-web

# Copy project files
WORKDIR /app
COPY . .

# Build for web
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the build output to Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx config to handle Cloud Run $PORT and SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Use a shell script to replace the port in Nginx config at runtime
CMD sed -i -e 's/PORT_PLACEHOLDER/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
