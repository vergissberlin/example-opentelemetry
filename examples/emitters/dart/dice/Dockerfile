######################################################
# Stage 1: Install Operating system and dependencies
FROM ubuntu:20.04 AS build

# Set timezone
ENV TZ="Europe/Berlin"
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

RUN apt update
RUN apt install -y curl git unzip xz-utils zip libglu1-mesa clang cmake \
        ninja-build pkg-config libgtk-3-dev

# Download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter config --enable-web
RUN flutter doctor -v

# Install required dependencies
WORKDIR /app
COPY . .
RUN flutter build web

######################################################
# Stage 2: Serve the app with a lightweight web server
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]