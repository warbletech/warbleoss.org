# Deploying warbleoss.org (GKE)

Continuous deployment is handled by `.github/workflows/deploy.yml`, on the same GKE
cluster and Artifact Registry as `warbletech/warble-core`:

| Setting | Value |
|---|---|
| GCP project | `green-device-505513-k4` |
| Cluster / location | `warble-green-device` / `us-central1-a` (region `us-central1`) |
| Image | `us-central1-docker.pkg.dev/green-device-505513-k4/warble/warbleoss-site:<sha>` |
| Namespace | `warbleoss` |
| Ingress static IP | global address `warbleoss-ip` (own IP, not warble-core's `warble-gke-ingress-ip`) |
| TLS | GKE ManagedCertificate `warbleoss-cert` (warbleoss.org, www.warbleoss.org) |

- **pull_request:** lint, link check, build the image, smoke it locally. No deploy.
- **push to `main` / manual run:** checks, then build + push the image tagged with the
  commit SHA, `kubectl apply` the `k8s/` manifests, `kubectl set image`,
  `kubectl rollout status`, and a smoke test of the public URL (waits for
  `/revision.txt` to equal the commit SHA; warns rather than fails until DNS/TLS are cut over).

Manifests in `k8s/` are namespaced only: the deploy service account cannot create
clusterroles/clusterrolebindings (warble-core #235).

Caddy listens on `$PORT` = 8080 (the Service `targetPort`), serves `/healthz` for the
probes and the GCE load-balancer health check, and runs as `nobody`.

## One-time setup checklist

- [ ] **GitHub secrets.** In `warbletech/warbleoss.org` → Settings → Environments →
      `production` (create it; optionally restrict to `main`), add the same values
      warble-core uses:
  - secret `GCP_WORKLOAD_IDENTITY_PROVIDER`
  - secret `GCP_SERVICE_ACCOUNT`
  - optional variable `SITE_URL` (default `https://warbleoss.org`)
  - remove the old `RAILWAY_TOKEN` / `RAILWAY_SERVICE` if present.
- [ ] **Workload Identity Federation.** The deploy SA is bound to warble-core through a
      `principalSet` on `attribute.repository`. Add the same binding for this repo, and if
      the pool provider's `attribute_condition` names only warble-core, widen it, for example
      `assertion.repository in ["warbletech/warble-core", "warbletech/warbleoss.org"]`.
      The WIF pool/provider is **not** defined in `warble-core/terraform` (there's no
      `google_iam_workload_identity_pool*` resource there), so change it where it actually lives:
      ```sh
      gcloud iam workload-identity-pools providers describe <PROVIDER> \
        --workload-identity-pool <POOL> --location global \
        --project green-device-505513-k4 --format 'value(attributeCondition)'
      gcloud iam service-accounts add-iam-policy-binding <GCP_SERVICE_ACCOUNT> \
        --project green-device-505513-k4 --role roles/iam.workloadIdentityUser \
        --member "principalSet://iam.googleapis.com/<POOL_RESOURCE>/attribute.repository/warbletech/warbleoss.org"
      ```
      `<POOL_RESOURCE>` is the `projects/<number>/locations/global/workloadIdentityPools/<pool>`
      prefix of `GCP_WORKLOAD_IDENTITY_PROVIDER`.
- [ ] **Static IP.**
      `gcloud compute addresses create warbleoss-ip --global --project green-device-505513-k4`,
      then read it back with
      `gcloud compute addresses describe warbleoss-ip --global --project green-device-505513-k4 --format 'value(address)'`.
      You can also codify it next to `google_compute_global_address.gke_ingress` in warble-core `terraform/gke.tf`.
- [ ] **Cloudflare DNS.** Point `A warbleoss.org` and `A www.warbleoss.org` at the `warbleoss-ip`
      address, **DNS only (grey cloud)** until
      `kubectl -n warbleoss get managedcertificate warbleoss-cert` shows `Active`.
      Google has to reach the origin directly to issue the cert, which can take 15–60 min.
      After that you can turn on proxying with SSL mode Full (strict).
- [ ] **Cloudflare DNS automation (optional).** `k8s/cloudflare-dns/` has a one-shot Job that upserts the A records to the ingress IP via the Cloudflare API. Apply it by hand; see its README. Use the warbleoss.org zone ID, not `cloudflare-zone-id-frakma`.
- [ ] **Decommission Railway** once the GKE site is live.
