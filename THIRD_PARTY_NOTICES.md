# Third-party notices

This repository is a Railway deployment adapter for TREK `4.3.3`. It does not contain or modify TREK source code.

## TREK

- Version: 4.3.3
- Source: https://github.com/liketrek/TREK/tree/v4.3.3
- Image: `docker.io/mauriceboe/trek:4.3.3@sha256:1ef1ccf41af8ae409e0435518facb5789b6adc99681ef26d1869508355455749`
- Copyright: TREK contributors
- License: GNU Affero General Public License v3.0 (AGPL-3.0)

The container built from this repository is the upstream image, referenced by an immutable registry digest, with two changes: `/app/uploads` is replaced by a link to `/app/data/uploads`, and a start script creates the upload directories inside the mounted volume before handing over to the upstream entrypoint. The corresponding source for the application is the upstream repository at the tag above. Third-party data bundled in the upstream image is attributed in the upstream [NOTICE.md](https://github.com/liketrek/TREK/blob/v4.3.3/NOTICE.md).

The directory list in `Dockerfile` and `entrypoint.sh` is taken from the upstream `Dockerfile` at tag `v4.3.3`. This repository is distributed under the same license, in `LICENSE`.

"TREK" and its logos are marks of the TREK project and are covered by the upstream [trademark policy](https://github.com/liketrek/TREK/blob/v4.3.3/TRADEMARKS.md). This repository is an independent deployment adapter and is not affiliated with or endorsed by the TREK project or Railway.
