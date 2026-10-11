# Deploying warbleoss.org (Railway)

Continuous deployment is handled by `.github/workflows/deploy.yml`: on every push to `main`,
it runs `railway up --ci --service $RAILWAY_SERVICE`, then smoke-tests the public URL.

## One-time setup

### 1. Railway service

1. In the Railway project that hosts Warble OSS (the same project as the Starling Lite MCP
   service is fine), create an **Empty Service** named for example `warbleoss-site`.
   No GitHub connection is needed: CI uploads the code with `railway up`.
   If you do connect the repo, turn off auto-deploys, or every push will deploy twice.
2. The service picks up `railway.toml`: it uses the Dockerfile builder, a `/healthz`
   healthcheck, and restarts on failure. Do not set `PORT`; Railway injects it.
3. **Settings → Networking → Generate Domain** gives a `*.up.railway.app` URL for testing.

### 2. Token and GitHub settings

Railway: **Project → Settings → Tokens → Create token**. Choose the `production` environment.
This is a *project* token, scoped to one project and environment. It can run `railway up`,
but not `whoami` or `link`.

GitHub (`warbletech/warbleoss.org` → Settings → Environments → **New environment
`production`**). Optionally restrict it to the `main` branch and add required reviewers.

| Kind     | Name              | Value |
|----------|-------------------|-------|
| Secret   | `RAILWAY_TOKEN`   | the project token from above |
| Variable | `RAILWAY_SERVICE` | the Railway service name, e.g. `warbleoss-site` |
| Variable | `SITE_URL`        | optional. Defaults to `https://warbleoss.org`. Set it to the `*.up.railway.app` URL until DNS is moved. |

### 3. Custom domain

1. Railway → service → **Settings → Networking → Custom Domain → `warbleoss.org`**
   (and `www.warbleoss.org` if wanted; Caddy redirects `www` to the apex).
   Railway shows a CNAME target (`<id>.up.railway.app`) and may ask for a
   `_railway-verify` TXT record.
2. Cloudflare (zone `warbleoss.org`):
   - Replace the apex `A`/`AAAA` records that point at GitHub Pages with
     `CNAME @ → <id>.up.railway.app`. Cloudflare flattens CNAMEs at the apex.
   - Do the same for `www` if it is attached.
   - Add the `_railway-verify` TXT record if Railway asks for one.
   - Leave the records **DNS only (grey cloud)** until Railway shows the domain as
     verified and the certificate as issued. You can enable the proxy afterwards, with
     SSL/TLS mode **Full (strict)**.
3. Remove `SITE_URL` (or set it to `https://warbleoss.org`) so the CD smoke test checks
   the real domain.

## Manual deploy

```bash
RAILWAY_TOKEN=... railway up --ci --service warbleoss-site
```

Or run the **deploy** workflow from the Actions tab (`workflow_dispatch`).
