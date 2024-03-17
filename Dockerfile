# Use a base image. Here, we use nginx as a web server.
FROM nginx:alpine

# Copy your HTML form into the container's file system
COPY index.html /usr/share/nginx/html
