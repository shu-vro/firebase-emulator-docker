# Firebase Emulators

This is the unofficial Firebase Emulators Docker image.

This is only for development purposes. Do not use this in production. See here to know
[why](https://stackoverflow.com/questions/64146814/why-cant-i-use-firebase-local-emulator-suite-as-a-self-hosted-solution).

Only those people who are familiar with Docker want to use Firebase Emulators in this way (Docker way) should use this image.

## Navigation

- [Firebase Emulators](#firebase-emulators)
- [Usage](#usage)
  - [The _Default_ Environment Variables](#the-default-environment-variables)
    - [With default environment variables](#with-default-environment-variables)
    - [With volume](#with-volume)
    - [With custom environment variables](#with-custom-environment-variables)
    - [In Compose File](#in-compose-file)
      - [If Volume Provided](#if-volume-provided)
      - [If Volume _NOT_ Provided](#if-volume-not-provided)
  - [Backup and Restore](#backup-and-restore)
  - [Firebase Functions](#firebase-functions)
  - [Extensions](#extensions)
- [TroubleShooting](#troubleshooting)
- [Most recommended Way](#most-recommended-way)
  - [Folder Structure](#folder-structure)
  - [Practical Example](#practical-example)

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
  shirshen/firebase-emulator:latest
```

#### With volume

> Note: If your `firebase.json` have other ports specified, you have to use those ports in the docker run command.

Example of the `firebase` folder:

```
.
├── .firebaserc
├── your_backup_directory
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
  -e backup_dir=your_backup_directory \
  -e EXPORT=true \
  shirshen/firebase-emulator:latest
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
  shirshen/firebase-emulator:latest
# if you want to keep a backup. Make sure it exists
```

Don't be scared of the long command. You can prefer to not to use the custom environment variables.

#### In Compose File

If Volume Provided:

```yaml
services:
  firebase-emulators:
    image: shirshen/firebase-emulator:latest
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
    environment:
      - backup_dir=your_backup_directory # restore. Assume it exists inside /path/to/firebase directory
      - EXPORT=true # Export on Exit. Provide Other than `true` to disable
```

If Volume _NOT_ Provided:

```yaml
services:
  firebase-emulators:
    image: shirshen/firebase-emulator:latest
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
      - /path/to/functions:/firebase/functions:rw # if you are using functions
      - /path/to/extensions:/firebase/extensions:rw # if you are using extensions
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
  -v /path/to/your_backup_directory:/firebase/where_should_backup_save_in_docker \
  -e backup_dir=where_should_backup_save_in_docker \
  -e EXPORT=true \
  shirshen/firebase-emulator:latest
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

### Firebase Functions

Firebase Functions as in today (2024-11-01) is a _beta_ functionality in the emulator. If you are using firebase functions, you have to use the `firebase.json` file to specify the functions directory.

```json
{
  "functions": {
    "source": "functions"
  }
  ...
  "emulators": {
    ...
    "functions": {
      "port": 5001
    }
    ...
  }
}
```

Then follow `firebase init functions` to create a `functions` directory in your project.

passing the volume to the docker run command will mount the `functions` directory to the container.

```bash
# an example with default environment variables + custom functions directory
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
  -v /path/to/functions:/firebase/functions \
  shirshen/firebase-emulator:latest
```

### Extensions

Firebase Extensions as in today (2024-11-01) is a _beta_ functionality in the emulator. If you are using firebase extensions, you have to use the `firebase.json` file to specify the functions directory.

> NOTE: Firebase extensions rely on firebase functions. So, you have to specify the functions directory in the `firebase.json` file. Before jumping to extensions, make sure you have functions emulator [set up](#firebase-functions).

```json
{
  ...
  "extensions": {
    "source": "extensions"
  }
  ...
}
```

Then follow `firebase init extensions` to create a `extensions` directory in your project.

passing the volume to the docker run command will mount the `functions` directory to the container.

```bash
# an example with default environment variables + custom functions directory
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
  -v /path/to/extensions:/firebase/extensions \
  shirshen/firebase-emulator:latest
```

## TroubleShooting

1. You all these time, we are sending `extensions`, `functions`, `your-backup-dir`, into the volume. You might face a [common issue](https://stackoverflow.com/questions/55275790/ebusy-resource-busy-or-locked-in-docker-when-trying-to-do-npm-install) similar to this. A best practice would be to make a parent folder and then place the `extensions`, `functions`, `your-backup-dir` inside that parent folder. Then, you can mount the parent folder to the container. remember, the `extensions`, `functions` should be placed inside `/firebase` folder in the container.

## Most recommended Way

_Come to this section after you have read [Usage](#usage) section._

Make a `firebase` folder. run a command inside the folder `firebase init` and follow along. make the `extensions`, `functions`, `your-backup-dir` inside the `firebase` folder. Then, mount the `firebase` folder to the container.
If you are not using `extensions`, `functions` folder, you might skip it. if you have not planned to hold backup, you might skip it too.

### Folder Structure

```bash
./firebase
├── backup-dir
│   ... whatever lies here
├── database.rules.json
├── extensions
├── firebase.json
├── firestore.indexes.json
├── firestore.rules
├── functions
│   ├── index.js
│   ├── package.json
│   └── package-lock.json
└── storage.rules
```

### Practical Example

A practical command should look like this:

```bash
docker run --rm --name firebase-emulators \
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
  -v $(pwd)/firebase:/firebase:rw \
  -e backup_dir=backup-dir \
  -e EXPORT=true \
  shirshen/firebase-emulator:latest
```

[Code](https://github.com/shu-vro/firebase-emulator-docker) - [Issues](https://github.com/shu-vro/firebase-emulator-docker/issues) - [Submit new Issue](https://github.com/shu-vro/firebase-emulator-docker/issues/new)
