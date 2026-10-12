#!/bin/sh
# Railway mounts the service volume at /app/data when the container starts, which
# hides the directories created in the image. /app/uploads is a link to
# /app/data/uploads, so the upload tree has to exist inside the volume before TREK
# starts. An existing volume already has these directories and is left untouched.
#
# Runs as root. The upstream entrypoint then gives /app/data to the node user and
# drops privileges before starting the server.
mkdir -p /app/data/logs \
  /app/data/uploads/files /app/data/uploads/covers /app/data/uploads/avatars \
  /app/data/uploads/photos /app/data/uploads/journey /app/data/uploads/places

exec /usr/local/bin/trek-entrypoint "$@"
