# Start with an Ubuntu base image
FROM ubuntu:latest

# Update and install prerequisites
RUN apt-get update && apt-get install -y \
    curl gnupg apt-transport-https

# Add CouchDB repository and GPG key
RUN echo "deb https://apache.bintray.com/couchdb-deb focal main" | tee -a /etc/apt/sources.list && \
    curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | apt-key add -

# Install CouchDB
RUN apt-get update && apt-get install -y couchdb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create CouchDB data directory and configure permissions
RUN mkdir -p /opt/couchdb/data && \
    chown -R couchdb:couchdb /opt/couchdb && \
    chmod -R 0770 /opt/couchdb

# Expose CouchDB default port
EXPOSE 5984

# Configure environment variables for CouchDB
ENV COUCHDB_USER=admin \
    COUCHDB_PASSWORD=password

# Start CouchDB with bind address set to allow external connections
CMD ["couchdb", "-b", "0.0.0.0"]

