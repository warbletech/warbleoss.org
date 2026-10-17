# Cloudflare DNS for warbleoss.org (not applied by CI)

These manifests point `warbleoss.org` and `www.warbleoss.org` at the GKE ingress
(`warbleoss-ingress`, static IP `warbleoss-ip`) through the Cloudflare API.
They are **not** in the `deploy.yml` file list on purpose. Apply them by hand, once,
after the one-time setup in `DEPLOY.md` (static IP reserved, ingress has an address).

Today warbleoss.org resolves to Cloudflare proxy addresses (Railway era) and returns 404.

## Zone ID: use the warbleoss.org zone

The secret you were pointed at,
`projects/625038861541/secrets/cloudflare-zone-id-frakma/versions/1`, is the
**frakma.io** zone. Using it would write warbleoss.org records into the wrong zone
(the Cloudflare API rejects a record name outside the zone). Use the warbleoss.org
zone's ID instead. If it isn't in Secret Manager yet, create
`cloudflare-zone-id-warbleoss` in project `625038861541` next to the frakma one.
The Job checks that the zone's name is `warbleoss.org` before writing anything.

The API token needs `Zone:DNS:Edit` on the warbleoss.org zone only.

## Steps (someone with GCP and cluster access)

```sh
# 1. Create the k8s Secret from Secret Manager (values never touch git).
./create-secret.sh            # defaults: project 625038861541, cloudflare-zone-id-warbleoss, cloudflare-api-token-warbleoss

# 2. RBAC + the Job. The Job reads the ingress IP and upserts the A records.
kubectl apply -f rbac.yaml -f dns-sync-job.yaml

# 3. Watch it.
kubectl -n warbleoss logs job/cloudflare-dns-sync -f
```

Records are created **DNS only (grey cloud)** (`PROXIED=false`), so Google can
issue `warbleoss-cert`. When
`kubectl -n warbleoss get managedcertificate warbleoss-cert` shows `Active`, re-run
the Job with `PROXIED=true` and set SSL mode to Full (strict) in Cloudflare.

Everything here is namespaced (Role/RoleBinding): the deploy service account
can't create cluster-scoped RBAC (warble-core #235).
