# Unmodified upstream TREK image, pinned by tag and by its multi-arch index digest.
FROM docker.io/mauriceboe/trek:4.3.3@sha256:1ef1ccf41af8ae409e0435518facb5789b6adc99681ef26d1869508355455749

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
