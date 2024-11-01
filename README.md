# Firebase Emulators

This is the unofficial Firebase Emulators Docker image.

This is only for development purposes. Do not use this in production. See here to know
[why](https://stackoverflow.com/questions/64146814/why-cant-i-use-firebase-local-emulator-suite-as-a-self-hosted-solution).

Only those people who are familiar with Docker want to use Firebase Emulators in this way (Docker way) should use this image.

## Usage

Default ports for the emulators are:

| Emulator       | Default Port |
| -------------- | ------------ |
| Authentication | 9099         |
| Functions      | 5001         |
| Firestore      | 8080         |
| Database       | 9000         |
| Hosting        | 5000         |
| Pub/Sub        | 8085         |
| Storage        | 9199         |
| Eventarc       | 9299         |
| Cloud Tasks    | 9499         |
| Emulator UI    | 4000         |

### The _Default_ Environment Variables

```bash
# Project ID
GCP_PROJECT=demo-project

# Dataconnect Emulator URL
FIREBASE_DATACONNECT_EMULATOR_URL=postgresql://localhost:5432?sslmode=disable

# Emulator Ports
FIREBASE_AUTH_EMULATOR_PORT=9099
FIREBASE_FUNCTIONS_EMULATOR_PORT=5001
FIREBASE_FIRESTORE_EMULATOR_PORT=8080
FIREBASE_DATABASE_EMULATOR_PORT=9000
FIREBASE_HOSTING_EMULATOR_PORT=5000
FIREBASE_PUBSUB_EMULATOR_PORT=8085
FIREBASE_STORAGE_EMULATOR_PORT=9199
FIREBASE_EVENTARC_EMULATOR_PORT=9299
FIREBASE_DATACONNECT_EMULATOR_PORT=9399
FIREBASE_TASKS_EMULATOR_PORT=9499
FIREBASE_UI_EMULATOR_PORT=4000

# Backup Directory (optional)
backup_dir=your_backup_directory

# Export on Exit (optional)
EXPORT=true
```

You can change one or all of the environment variables by passing them to the docker run command.
alternatively, you can pass volume and send your `firebase` folder as volume which must contain
`firebase.json` and `.firebaserc` files.

> Note: If you provide a Volume, the port specific environment variables wouldn't have any Effect

[Instructions to generate these files](https://firebase.google.com/docs/emulator-suite/install_and_configure)

Here is an example of Docker run command:

#### With default environment variables

```bash
docker run --name firebase-emulators \
  -p 9099:9099 \
  -p 5001:5001 \
  -p 8080:8080 \
  -p 9000:9000 \
  -p 5000:5000 \
  -p 8085:8085 \
  -p 9199:9199 \
  -p 9299:9299 \
  -p 9399:9399 \
  -p 9499:9499 \
  -p 4000:4000 \
  firebase-emulators
```

#### With volume

> Note: If your `firebase.json` have other ports specified, you have to use those ports in the docker run command.

Example of the `firebase` folder:

```
.
├── .firebaserc
├── database.rules.json (if specified in firebase.json)
├── firebase.json
├── firestore.indexes.json  (if specified in firebase.json)
├── firestore.rules (if specified in firebase.json)
└── storage.rules (if specified in firebase.json)
```

```bash
# With backup and restore features
docker run --name firebase-emulators \
  -p 9099:9099 \
  -p 5001:5001 \
  -p 8080:8080 \
  -p 9000:9000 \
  -p 5000:5000 \
  -p 8085:8085 \
  -p 9199:9199 \
  -p 9299:9299 \
  -p 9399:9399 \
  -p 9499:9499 \
  -p 4000:4000 \
  -v /path/to/firebase:/firebase \
  -v /path/to/your_backup_directory:/firebase/your_backup_directory \
  -e backup_dir=your_backup_directory \
  -e EXPORT=true \
  firebase-emulators
```

#### With custom environment variables

```bash
docker run -d --name firebase-emulators \
  -p 9099:9099 \
  -p 5001:5001 \
  -p 8080:8080 \
  -p 9000:9000 \
  -p 5000:5000 \
  -p 8085:8085 \
  -p 9199:9199 \
  -p 9299:9299 \
  -p 9399:9399 \
  -p 9499:9499 \
  -p 4000:4000 \
  -e GCP_PROJECT=demo-project \
  -e FIREBASE_AUTH_EMULATOR_PORT=9099 \
  -e FIREBASE_FUNCTIONS_EMULATOR_PORT=5001 \
  -e FIREBASE_FIRESTORE_EMULATOR_PORT=8080 \
  -e FIREBASE_DATABASE_EMULATOR_PORT=9000 \
  -e FIREBASE_HOSTING_EMULATOR_PORT=5000 \
  -e FIREBASE_PUBSUB_EMULATOR_PORT=8085 \
  -e FIREBASE_STORAGE_EMULATOR_PORT=9199 \
  -e FIREBASE_EVENTARC_EMULATOR_PORT=9299 \
  -e FIREBASE_DATACONNECT_EMULATOR_PORT=9399 \
  -e FIREBASE_TASKS_EMULATOR_PORT=9499 \
  -e FIREBASE_UI_EMULATOR_PORT=4000 \
  -e backup_dir=your_backup_directory \
  -e EXPORT=true \
  -e FIREBASE_DATACONNECT_EMULATOR_URL=postgresql://localhost:5432?sslmode=disable \
  -v /path/to/your_backup_directory:/firebase/your_backup_directory:rw \
  firebase-emulators
# if you want to keep a backup. Make sure it exists
```

Don't be scared of the long command. You can prefer to not to use the custom environment variables.

#### In Compose File

If Volume Provided:

```yaml
services:
  firebase-emulators:
    image: shirshen/firebase-emulators:latest
    ports:
      - 9099:9099
      - 5001:5001
      - 8080:8080
      - 9000:9000
      - 5000:5000
      - 8085:8085
      - 9199:9199
      - 9299:9299
      - 9399:9399
      - 9499:9499
      - 4000:4000
    volumes:
      - /path/to/firebase:/firebase
      - /path/to/your_backup_directory:/firebase/your_backup_directory
    environment:
      - backup_dir=your_backup_directory # restore
      - EXPORT=true # Export on Exit. Provide Other than `true` to disable
```

If Volume _NOT_ Provided:

```yaml
services:
  firebase-emulators:
    image: shirshen/firebase-emulators:latest
    ports:
      - 9099:9099
      - 5001:5001
      - 8080:8080
      - 9000:9000
      - 5000:5000
      - 8085:8085
      - 9199:9199
      - 9299:9299
      - 9399:9399
      - 9499:9499
      - 4000:4000
    volumes:
      - /path/to/firebase:/firebase:rw
      - /path/to/your_backup_directory:/firebase/your_backup_directory:rw # if you want to keep backup. Make sure it exists
    environment:
      - GCP_PROJECT=demo-project
      # Omit Environment variables to keep them default
      - FIREBASE_AUTH_EMULATOR_PORT=9099
      - FIREBASE_FUNCTIONS_EMULATOR_PORT=5001
      - FIREBASE_FIRESTORE_EMULATOR_PORT=8080
      - FIREBASE_DATABASE_EMULATOR_PORT=9000
      - FIREBASE_HOSTING_EMULATOR_PORT=5000
      - FIREBASE_PUBSUB_EMULATOR_PORT=8085
      - FIREBASE_STORAGE_EMULATOR_PORT=9199
      - FIREBASE_EVENTARC_EMULATOR_PORT=9299
      - FIREBASE_DATACONNECT_EMULATOR_PORT=9399
      - FIREBASE_TASKS_EMULATOR_PORT=9499
      - FIREBASE_UI_EMULATOR_PORT=4000
      - FIREBASE_DATACONNECT_EMULATOR_URL=postgresql://localhost:5432?sslmode=disable
      - backup_dir=your_backup_directory # required if you want to keep backup
      - EXPORT=true # Export on Exit. Provide Other than `true` to disable `backup_dir`
```

### Backup and Restore

You can backup your Firestore and Realtime Database data by setting the `backup_dir` environment variable.
This option works if you are using compose file or docker run command.

```bash
# This command will backup your Firestore and Realtime Database data to the specified directory
# Doesn't mount a firebase.json config file. So, default are used
docker run -d --name firebase-emulators \
  -p 9099:9099 \
  -p 5001:5001 \
  -p 8080:8080 \
  -p 9000:9000 \
  -p 5000:5000 \
  -p 8085:8085 \
  -p 9199:9199 \
  -p 9299:9299 \
  -p 9399:9399 \
  -p 9499:9499 \
  -p 4000:4000 \
  -v /path/to/your_backup_directory:/firebase/where_should_backup_save_in_docker \
  -e backup_dir=where_should_backup_save_in_docker \
  -e EXPORT=true \
  firebase-emulators
```

> **Long Story short**, providing `backup_dir` environment variable
> will provide a Restore directory and `EXPORT=true` will work as a backup flag.

> **NOTE: the `/path/to/your_backup_directory` must be a valid directory in your system**

> The `EXPORT` will have no effect if `backup_dir` is not provided or mounted

make sure that `your_backup_directory` in volume and environment variable are same. Or you can specify something like:

```bash
...
  -v /path/to/your_backup_directory:/firebase/backup \
  -e backup_dir=backup \
...
```

_backup error:_ While keeping a backup, if you see export error: `denied: requested access to the resource is denied`,
You have to do a `chmod -R 777 $(pwd)/backup-dir` command to give the docker container access to the directory.
⚠️ chmod -R 777 gives full access to the directory. Use it with caution.

[Code](https://github.com/shu-vro/firebase-emulator-docker) - [Issues](https://github.com/shu-vro/firebase-emulator-docker/issues) - [Submit new Issue](https://github.com/shu-vro/firebase-emulator-docker/issues/new)
