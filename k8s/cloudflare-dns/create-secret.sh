#!/usr/bin/env bash
# Creates the warbleoss/cloudflare-dns Secret from GCP Secret Manager.
# Needs gcloud auth on the project and kubectl pointed at warble-green-device.
set -euo pipefail

PROJECT="${PROJECT:-625038861541}"
ZONE_SECRET="${ZONE_SECRET:-cloudflare-zone-id-warbleoss}"   # NOT cloudflare-zone-id-frakma (that is frakma.io)
TOKEN_SECRET="${TOKEN_SECRET:-cloudflare-api-token-warbleoss}"
VERSION="${VERSION:-latest}"

zone_id="$(gcloud secrets versions access "$VERSION" --secret="$ZONE_SECRET" --project="$PROJECT")"
api_token="$(gcloud secrets versions access "$VERSION" --secret="$TOKEN_SECRET" --project="$PROJECT")"

kubectl -n warbleoss create secret generic cloudflare-dns \
  --from-literal=CF_ZONE_ID="$zone_id" \
  --from-literal=CF_API_TOKEN="$api_token" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "secret warbleoss/cloudflare-dns created or updated"
