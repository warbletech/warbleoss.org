# warbleoss.org

Static site for **Warble OSS** — home of ShrikeOps, Heron Ops, and Starling EX Community Edition.

- **Live site:** https://warbleoss.org (GitHub Pages)
- **Try MCP:** https://starling-ex.frakma.io/lite/mcp
- **Code:** https://github.com/warble-tech/warble-army

## Develop

Open `index.html` locally or:

```bash
python3 -m http.server 8080
```

## Deploy

Pushes to `main` publish via GitHub Pages (`/ (root)`).

Custom domain: `CNAME` → `warbleoss.org` (configure DNS A/CNAME at registrar to GitHub Pages).

## Custom domain (warbleoss.org)

1. At your DNS provider, add:
   - `A` @ → `185.199.108.153` `185.199.109.153` `185.199.110.153` `185.199.111.153`
   - `AAAA` @ → `2606:50c0:8000::153` … (GitHub Pages IPv6)
   - or `CNAME` `www` → `warble-tech.github.io`
2. Add a `CNAME` file containing `warbleoss.org` and push.
3. In repo Settings → Pages → Custom domain → warbleoss.org → Enforce HTTPS.

Until DNS is live, use: **https://warble-tech.github.io/warbleoss.org/**
