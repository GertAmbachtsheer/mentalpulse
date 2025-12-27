# Stage 1: Build
FROM ghcr.io/cirruslabs/flutter:latest AS build
WORKDIR /app

# Ensure web is enabled
RUN flutter config --enable-web
RUN flutter precache --web

# Copy all files
COPY . .
RUN flutter pub get

# Build the web application
RUN flutter build web --release --web-renderer canvaskit

# Stage 2: Serve
FROM nginx:alpine

# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built web files from the build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
