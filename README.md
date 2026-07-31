# warbleoss.org

Static site for **Warble OSS** — home of ShrikeOps, Heron Ops, and Starling EX Community.

- **Live site:** https://warbleoss.org (GitHub Pages; until DNS: https://warble-tech.github.io/warbleoss.org/)
- **Try MCP:** https://starling-ex.frakma.io/lite/mcp
- **Code:** https://github.com/warble-tech/warble-army
- **Portfolio plan:** see monorepo [`OSS_PORTFOLIO_ALIGNMENT.md`](../OSS_PORTFOLIO_ALIGNMENT.md) (when developed from warble-opensource workspace)

## What’s on the landing page

| Section | Purpose |
|---------|---------|
| Hero + foundation pills | CNCF Sandbox draft · Frakma-X LF wing |
| Flock cards | ShrikeOps, Heron Ops, Starling EX Community |
| Easy start | Good-first repos for contributors |
| Try MCP / Install | Live demo + Helm / local MCP |
| Foundations | CNCF vs LF table (honest status language) |
| Community | Discord Office Hours + community repo |
| Support | Contribute now · LFX Crowdfunding later · Enterprise |

## Develop

```bash
python3 -m http.server 8080
# open http://127.0.0.1:8080
```

## Deploy

Pushes to `main` on `github.com/warble-tech/warbleoss.org` publish via GitHub Pages (root).

Workflow: [`.github/workflows/pages.yml`](.github/workflows/pages.yml)

### Custom domain (warbleoss.org)

1. DNS at registrar:
   - `A` @ → `185.199.108.153` `185.199.109.153` `185.199.110.153` `185.199.111.153`
   - `AAAA` @ → GitHub Pages IPv6 set
   - or `CNAME` `www` → `warble-tech.github.io`
2. Add a `CNAME` file containing `warbleoss.org` and push.
3. Repo Settings → Pages → Custom domain → Enforce HTTPS.

## Speaking rules (do not break)

| Say | Don’t say |
|-----|-----------|
| “Starling EX Community is planned for CNCF donation” | “We are a CNCF project” (until accepted) |
| “Frakma-X is our Linux Foundation wing” | “FRAKMA is an LF project” without Frakma-X |
| “LFX Crowdfunding planned after public OSS + community” | Implying funds are live before listing |

## Repo visibility

This marketing site should be a **public** repository. Private “OSS” repos block CNCF Sandbox credibility and LFX Crowdfunding eligibility.
