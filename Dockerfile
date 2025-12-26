# Stage 1: Build
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app

# Pre-cache the Flutter Web SDK
RUN flutter upgrade
RUN flutter precache --web

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Build the web application
RUN flutter build web --release

# Stage 2: Serve
FROM nginx:alpine

# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built web files from the build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
