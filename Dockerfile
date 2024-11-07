FROM openjdk:24-slim

# Install Node.js, npm, and Firebase tools
RUN apt-get update
RUN apt-get install -y nodejs npm
RUN npm install -g firebase-tools
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /firebase

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY firebase/ /firebase/

# Pre-download the necessary .jar files by running the emulators during the build process
# RUN firebase setup:emulators:firestore
# RUN firebase setup:emulators:storage
# RUN firebase setup:emulators:ui
# RUN firebase setup:emulators:database
# RUN firebase setup:emulators:pubsub

RUN firebase setup:emulators:firestore && \
    firebase setup:emulators:storage && \
    firebase setup:emulators:ui && \
    firebase setup:emulators:database && \
    firebase setup:emulators:pubsub

RUN cd functions && npm install

# Use the entrypoint script to start the emulators
ENTRYPOINT ["/entrypoint.sh"]