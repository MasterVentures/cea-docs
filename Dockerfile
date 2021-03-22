# Use Python 3.8 latest
FROM python:3.8.2 AS build
# Install dependencies
RUN pip install regex mkdocs mkdocs-material
# Set the working directory
WORKDIR /app
# Copy source docs
COPY docs docs
COPY mkdocs.yml .
# Buil the site
RUN mkdocs build

# Use the current stable nginx image for production stage
FROM nginx:1.18.0-alpine as production
# Copy dist directory from build stage
COPY --from=build /app/site /usr/share/nginx/html
# Document the network port that this container will listen on at runtime.
EXPOSE 80