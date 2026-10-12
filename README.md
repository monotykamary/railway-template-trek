# TREK on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/nomad?referralCode=ZqgrJ0)

Deploys [TREK](https://github.com/liketrek/TREK) 4.3.3, a self-hosted collaborative travel planner, as one Railway service whose SQLite database and uploaded files live on a single volume. The template is listed on Railway under its original name, NOMAD.

## What this repository adds

TREK's official image expects two mounts: `/app/data` for the database and `/app/uploads` for uploaded files. Railway gives a service one volume. This repository builds a thin layer over the official image so that both live on the volume mounted at `/app/data`:

- `Dockerfile` starts from `docker.io/mauriceboe/trek:4.3.3`, pinned by digest, and replaces `/app/uploads` with a link to `/app/data/uploads`.
- `entrypoint.sh` creates the upload directories inside the volume at start, then runs the upstream entrypoint unchanged.
- `railway.toml` selects the Dockerfile builder and sets the health check.

No TREK source code is copied or modified.

## Topology

| Service | Source | Port | Volume | Health check |
| --- | --- | --- | --- | --- |
| `TREK` | this repository | `3000` | `/app/data` | `/api/health` |

Inside the volume: `travel.db` (SQLite), `uploads/`, `logs/`, and the backups and plugins TREK creates. Run one replica; SQLite does not support several writers on a shared volume.

## Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `APP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Canonical public URL. |
| `ALLOWED_ORIGINS` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Allowed browser origin. |
| `ENCRYPTION_KEY` | generated | Encrypts stored secrets. Changing it makes them unreadable. |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | `admin@example.com`, generated | First administrator; read only when the database is empty. |
| `FORCE_HTTPS`, `TRUST_PROXY` | `true`, `1` | HTTPS behind Railway's proxy. |
| `PORT`, `NODE_ENV`, `TZ`, `LOG_LEVEL` | `3000`, `production`, `UTC`, `info` | Runtime settings. |

## First sign-in

Open the service's public domain and sign in with `ADMIN_EMAIL` and the generated `ADMIN_PASSWORD` from the service variables. TREK asks for a new password on first sign-in. Changing those variables later does not change an existing account.

## Upgrading a deployment made from the 4.2.1 template

Deployments created before this repository existed run the image `ghcr.io/monotykamary/nomad:4.2.1`, which keeps uploads in the same place: `uploads/` inside the `/app/data` volume. Railway does not update existing deployments when a template changes. To upgrade:

1. Back up the volume, or create a backup in TREK under Admin Panel, Backups.
2. In the service settings, change the source from the Docker image to this GitHub repository. Keep the volume at `/app/data` and keep every variable.
3. Deploy. TREK migrates the database on first start.

Do not point the service at `mauriceboe/trek` directly. That image stores uploads in `/app/uploads`, outside the volume: files you already uploaded would appear missing, and new uploads would be lost on the next deploy.

Upstream does not document a downgrade after the database has been migrated. To go back, restore the backup.

## Changes in TREK since 4.2.1

- Since 4.3.0, place search queries the hosted TREK Places API at `places.liketrek.com` by default. Set `TREK_PLACES_ENABLED=false` to keep searches on OpenStreetMap or your own keyed provider.
- Since 4.3.1, MCP tools reject arguments they do not declare.

See the upstream release notes for the full list.

## Limitations

- Mount the volume at `/app/data` only. A volume at `/app` hides the application, and a volume at `/app/uploads` separates uploads from the database backup.
- Connecting this repository as a service source redeploys on every push to the connected branch. A push here changes the wrapper; the TREK version changes only when the pinned image does.

## Updating the pinned version

1. Read the upstream release notes for breaking changes.
2. Resolve the new tag to its digest, for example `crane digest mauriceboe/trek:<tag>`.
3. Update the `FROM` line in `Dockerfile` and the versions in `THIRD_PARTY_NOTICES.md`, `README.md`, and `TEMPLATE_README.md`.
4. Check that the upstream `Dockerfile` and `server/scripts/entrypoint.sh` still use `/app/data`, `/app/uploads`, and `/usr/local/bin/trek-entrypoint`.
5. Test an upgrade on a volume that already holds a database and uploads before changing the template.

## Upstream

- Source: https://github.com/liketrek/TREK/tree/v4.3.3
- Release: https://github.com/liketrek/TREK/releases/tag/v4.3.3
- Documentation: https://github.com/liketrek/TREK/tree/v4.3.3/wiki
- Image: https://hub.docker.com/r/mauriceboe/trek
- License: AGPL-3.0

This repository contains a Railway adapter and documentation, licensed under AGPL-3.0 like TREK itself. TREK is developed by its upstream contributors. This repository is not affiliated with or endorsed by the TREK project or Railway. See `THIRD_PARTY_NOTICES.md`.
