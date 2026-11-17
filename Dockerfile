# warbleoss.org — static site image for GKE (see k8s/).
#   docker build -t warbleoss-site . && docker run --rm -p 8080:8080 warbleoss-site
# Only the public site files are copied in; README, docs and repos/ never ship.
FROM caddy:2.11.7-alpine@sha256:d8542f48d34a9cf4e4c11a478865229840e87e4c96ea3f439101f31a5d35f75f

COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html 404.html revision.txt /srv/
COPY assets/ /srv/assets/

# Fail the build on a bad Caddyfile. The upstream image sets
# cap_net_bind_service on /usr/bin/caddy. This site listens on 8080, and
# that file capability makes execve return EPERM when the pod sets
# allowPrivilegeEscalation: false. Strip it; do not weaken the pod policy.
RUN caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile \
 && setcap -r /usr/bin/caddy \
 && caps="$(getcap /usr/bin/caddy || true)" \
 && if [ -n "$caps" ]; then echo "caddy still has file capabilities: $caps" >&2; exit 1; fi \
 && chown -R nobody:nobody /data /config

ENV PORT=8080
EXPOSE 8080
USER nobody

# Kubernetes uses the probes in k8s/deployment.yaml; this is for plain docker.
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- "http://127.0.0.1:${PORT}/healthz" || exit 1

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
