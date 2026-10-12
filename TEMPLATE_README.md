# Deploy and Host TREK on Railway

TREK is a self-hosted collaborative travel planner with interactive maps, itineraries, budgets, packing lists, reservations, documents, journals, offline PWA support, OIDC, passkeys, plugins, and optional AI-assisted booking import. This Railway template runs TREK as a single service with durable SQLite and upload storage.

## About Hosting TREK

TREK serves its web client, API, and WebSocket endpoint from port `3000`. Its SQLite database, encryption state, logs, plugins, backups, and uploaded files must survive redeployments. Railway supports one volume per service, so this template's container links `/app/uploads` into `/app/data/uploads` and mounts one persistent volume at `/app/data`.

The template generates an encryption key and initial administrator password, configures Railway's HTTPS origin, trusts one proxy hop, and checks `/api/health` before accepting a deployment.

## Common Use Cases

- Plan trips collaboratively with live updates
- Track budgets, reservations, packing lists, and documents
- Maintain a travel journal and visited-country atlas
- Run a private PWA with passkeys or OIDC single sign-on
- Extend trip planning with TREK plugins and MCP tools

## Dependencies for TREK Hosting

- TREK 4.3.3, from the official `mauriceboe/trek` image pinned by digest
- SQLite through `better-sqlite3`
- Persistent Railway volume at `/app/data`
- HTTPS and WebSocket routing on port `3000`

### Deployment Dependencies

- [TREK upstream repository](https://github.com/liketrek/TREK)
- [Railway wrapper repository](https://github.com/monotykamary/railway-template-trek)
- [TREK documentation](https://github.com/liketrek/TREK/tree/main/wiki)
- [TREK live demo](https://demo.liketrek.com)
- [AGPL-3.0 license](https://github.com/liketrek/TREK/blob/main/LICENSE)

### Implementation Details

The `TREK` service owns the public domain. It uses `APP_URL` and `ALLOWED_ORIGINS` from its Railway public domain, `FORCE_HTTPS=true`, and `TRUST_PROXY=1`. `ENCRYPTION_KEY`, `ADMIN_PASSWORD`, and the persistent volume are generated during template deployment. Sign in with `ADMIN_EMAIL` and `ADMIN_PASSWORD`; TREK asks for a new password on first sign-in. These two variables are read only when the database is empty, and `ENCRYPTION_KEY` must not change after first start.

The service builds from the wrapper repository, which adds one layer to the official image: `/app/uploads` becomes a link to `/app/data/uploads`, and a start script creates the upload directories inside the volume before running the upstream entrypoint. Uploaded files are therefore stored under `/app/data/uploads`, next to `travel.db`. This is required because Railway currently permits one mounted volume per service.

Since TREK 4.3.0, place search queries the hosted TREK Places API at `places.liketrek.com` by default. Add `TREK_PLACES_ENABLED=false` to keep searches on OpenStreetMap or your own keyed provider.

Deployments made from the earlier revision of this template run `ghcr.io/monotykamary/nomad:4.2.1` and are not changed by this revision. To upgrade one, back up the volume, then switch the service source to the wrapper repository while keeping the volume and variables. Do not switch it to `mauriceboe/trek` directly: that image keeps uploads outside the volume.

### Why Deploy TREK on Railway?

Railway provides HTTPS, WebSocket routing, persistent volumes, health checks, deployment logs, backups, and restart management without requiring a separate database service. TREK remains self-hosted while Railway handles the underlying application runtime.
