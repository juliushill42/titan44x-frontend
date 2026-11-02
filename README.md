# Titan 44XX — V8 Studio

The frontend for **Titan 44XX**, a locally operated software manufacturing system.

V8 replaces the traditional factory dashboard with a single idea composer, live manufacturing status, generated-app preview, application library, and proof viewer.

## Install on an existing Titan 44XX factory (Termux / Linux)

```bash
bash bootstrap.sh
```

Open **http://127.0.0.1:8444/?v=8** on the same device.

**Prerequisite:** A running Titan 44XX backend with the existing build, metrics, and one-tap app-launch APIs. This is a **frontend-only upgrade**, not a clean installation of the backend. It does not add new software-generation capabilities.

The installer stages HTML, CSS and JavaScript; verifies SHA-256 checksums, UI element references, optional JavaScript syntax, and backend health; backs up the previous interface; and restores the previous files on a failed cutover. Existing builds, data, and signing keys are untouched.

## Browse the actual source

```bash
bash extract.sh
```

This expands the verified, gzip-embedded assets from `bootstrap.sh` into:

```text
web/index.html
web/styles.css
web/app.js
```

`web/index.html` is also committed as readable source. The extracted files are plain HTML, CSS, and JavaScript.

## Backend APIs used by V8

- `GET /api/health`
- `GET /api/metrics`
- `GET /api/builds`
- `POST /api/builds`
- `GET /api/builds/{id}`
- `GET /api/builds/{id}/proof`
- `GET /api/builds/{id}/download`
- `POST /api/apps/{id}/launch`
- `POST /api/apps/{id}/stop`
- `GET /api/apps/{id}/summary` for supported applications

No API tokens, customer data, private signing keys, or generated production artifacts are included in this repository.

## Verification

```bash
bash extract.sh
bash -n bootstrap.sh
node --check web/app.js # optional, when Node is installed
```

Tested locally: Bash syntax, JavaScript syntax, HTML/JS element contracts, and embedded SHA-256 values. Actual Android UI behavior and live backend operations require an installed Titan 44XX factory.

Copyright (c) 2026 Julius Cameron Hill / Titan Universal AI LLC. No license grant is implied by public repository availability.
