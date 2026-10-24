# Unmodified upstream TREK image, pinned by tag and by its multi-arch index digest.
FROM docker.io/mauriceboe/trek:4.3.4@sha256:6b7c8f275cc0ff3ca44979084bf078f553c96a0564493a132c1631ffaf6c3e77

# Upstream keeps the SQLite database in /app/data and uploads in /app/uploads (two
# mounts). Railway gives a service one volume, mounted at /app/data, so /app/uploads
# becomes a link into that volume. The upstream link /app/server/uploads -> /app/uploads
# is left as it is and follows this one.
RUN rm -rf /app/uploads && \
    mkdir -p /app/data/logs /app/data/uploads/files /app/data/uploads/covers /app/data/uploads/avatars \
      /app/data/uploads/photos /app/data/uploads/journey /app/data/uploads/places && \
    ln -s /app/data/uploads /app/uploads && \
    chown -R node:node /app/data && \
    chown -h node:node /app/uploads

COPY entrypoint.sh /usr/local/bin/railway-entrypoint
RUN chmod 0755 /usr/local/bin/railway-entrypoint

# ENTRYPOINT ["dumb-init", "--"] is inherited from the upstream image.
CMD ["/usr/local/bin/railway-entrypoint"]
