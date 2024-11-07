# Use an official Alpine Linux base image
FROM alpine:latest

# Install prerequisites and MongoDB
RUN apk update && \
    apk add --no-cache mongodb wget gnupg

# Add MongoDB public key and MongoDB repository to the package manager
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --import - && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache mongodb@community

# Create MongoDB data directory
RUN mkdir -p /data/db

# Expose MongoDB port
EXPOSE 27017

# Start MongoDB as the default command
CMD ["mongod", "--bind_ip_all"]
