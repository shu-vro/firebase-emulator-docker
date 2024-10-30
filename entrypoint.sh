#!/bin/sh

# Check if GCP_PROJECT is set
GCP_PROJECT=${GCP_PROJECT:-"test-project"}
FIREBASE_DATACONNECT_EMULATOR_URL=${FIREBASE_DATACONNECT_EMULATOR_URL:-"postgresql://localhost:5432?sslmode=disable"}

# Set default ports if environment variables are not set
FIREBASE_AUTH_EMULATOR_PORT=${FIREBASE_AUTH_EMULATOR_PORT:-9099}
FIREBASE_FUNCTIONS_EMULATOR_PORT=${FIREBASE_FUNCTIONS_EMULATOR_PORT:-5001}
FIREBASE_FIRESTORE_EMULATOR_PORT=${FIREBASE_FIRESTORE_EMULATOR_PORT:-8080}
FIREBASE_DATABASE_EMULATOR_PORT=${FIREBASE_DATABASE_EMULATOR_PORT:-9000}
FIREBASE_HOSTING_EMULATOR_PORT=${FIREBASE_HOSTING_EMULATOR_PORT:-5000}
FIREBASE_PUBSUB_EMULATOR_PORT=${FIREBASE_PUBSUB_EMULATOR_PORT:-8085}
FIREBASE_STORAGE_EMULATOR_PORT=${FIREBASE_STORAGE_EMULATOR_PORT:-9199}
FIREBASE_EVENTARC_EMULATOR_PORT=${FIREBASE_EVENTARC_EMULATOR_PORT:-9299}
FIREBASE_DATACONNECT_EMULATOR_PORT=${FIREBASE_DATACONNECT_EMULATOR_PORT:-9399}
FIREBASE_TASKS_EMULATOR_PORT=${FIREBASE_TASKS_EMULATOR_PORT:-9499}
FIREBASE_UI_EMULATOR_PORT=${FIREBASE_UI_EMULATOR_PORT:-4000}

# Check if firebase.json exists
if [ ! -f /firebase/firebase.json ]; then
  # Generate firebase.json file
  cat <<EOF > /firebase/firebase.json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
  "database": {
    "rules": "database.rules.json"
  },
  "emulators": {
    "auth": {
      "port": $FIREBASE_AUTH_EMULATOR_PORT
    },
    "functions": {
      "port": $FIREBASE_FUNCTIONS_EMULATOR_PORT
    },
    "firestore": {
      "port": $FIREBASE_FIRESTORE_EMULATOR_PORT
    },
    "database": {
      "port": $FIREBASE_DATABASE_EMULATOR_PORT
    },
    "hosting": {
      "port": $FIREBASE_HOSTING_EMULATOR_PORT
    },
    "pubsub": {
      "port": $FIREBASE_PUBSUB_EMULATOR_PORT
    },
    "storage": {
      "port": $FIREBASE_STORAGE_EMULATOR_PORT
    },
    "eventarc": {
      "port": $FIREBASE_EVENTARC_EMULATOR_PORT
    },
    "tasks": {
      "port": $FIREBASE_TASKS_EMULATOR_PORT
    },
    "ui": {
      "port": $FIREBASE_UI_EMULATOR_PORT
    },
    "singleProjectMode": true
  }
}
EOF
fi

# Check if .firebaserc exists
if [ ! -f /firebase/.firebaserc ]; then
  # Generate .firebaserc file
  cat <<EOF > /firebase/.firebaserc
{
  "projects": {
    "default": "$GCP_PROJECT"
  },
  "dataconnectEmulatorConfig": {
    "postgres": {
      "localConnectionString": "$FIREBASE_DATACONNECT_EMULATOR_URL"
    }
  }
}
EOF
fi

# Construct the command
CMD="firebase emulators:start"

# Check if backup_dir is set and append the --import flag if it is
if [ -n "$backup_dir" ]; then
  if [ -d "/firebase/$backup_dir" ]; then
    CMD="$CMD --import=/firebase/$backup_dir"
  else
    echo "Warning: backup_dir is set but the directory /firebase/$backup_dir does not exist."
  fi
fi

# Check if EXPORT is set to true and append the --export-on-exit flag if it is
if [ "$EXPORT" = "true" ]; then
  if [ -n "$backup_dir" ]; then
    CMD="$CMD --export-on-exit=/firebase/$backup_dir"
  else
    echo "Warning: EXPORT is set to true but backup_dir is not set."
  fi
fi

# Execute the command
exec $CMD