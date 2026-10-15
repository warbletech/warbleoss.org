# warbleoss.org

Static site for **Warble OSS**, the open-source home of ShrikeOps, Heron Ops,
and Starling EX Community.

- **Live site:** <https://warbleoss.org> (GKE)
- **Try MCP:** <https://mcp.warbleoss.org> (MCP endpoint `POST /mcp`,
  health check `GET /health`). This is the community offering. It is deployed
  on Railway and stays there. It is not the enterprise IDP.
- **Code:** <https://github.com/warbletech/warble-army>

## What's on the landing page

| Section                 | Purpose                                                                |
| ----------------------- | ---------------------------------------------------------------------- |
| Hero + foundation pills | CNCF Sandbox draft · Frakma-X LF wing                                  |
| Flock cards             | ShrikeOps, Heron Ops, Starling EX Community                            |
| Easy start              | Good-first repos for contributors                                      |
| Try MCP / Install       | Live demo + Helm / local MCP                                           |
| Foundations             | CNCF vs LF table (honest status language)                              |
| Path to CNCF            | Readiness checklist + Sandbox → Graduation steps                       |
| Community               | [Discord](https://discord.gg/kAfR57mVDX) Office Hours + community repo |
| Support                 | Contribute now · LFX Crowdfunding later · Enterprise                   |

## Repository layout

```text
index.html        landing page
404.html          not-found page
assets/           logos
Caddyfile         static server config (site image)
Dockerfile        site image: Caddy + index.html, 404.html, assets/ only
k8s/              GKE manifests (namespace, deployment, service, cert, ingress)
revision.txt      deployed commit (stamped by CD; "dev" in git)
repos/            flock repositories as git submodules (not checked out in CI)
```

### Submodules

Related flock repositories are tracked as git submodules under `repos/`:

| Path                      | Repository                                             |
| ------------------------- | ------------------------------------------------------ |
| `repos/warble-army/`      | [warbletech/warble-army][warble-army] (flock umbrella) |
| `repos/shrikeops/`        | [warbletech/shrikeops][shrikeops] (scanner)            |
| `repos/heron-ops/`        | [warbletech/heron-ops][heron-ops] (Kubernetes MCP)     |
| `repos/community/`        | [warbletech/community][community] (RFCs, WGs)          |
| `repos/shrikeops-demo/`   | [warbletech/shrikeops-demo][shrikeops-demo] (demos)    |
| `repos/warble-bootstrap/` | [warbletech/warble-bootstrap][warble-bootstrap]        |

[warble-army]: https://github.com/warbletech/warble-army
[shrikeops]: https://github.com/warbletech/shrikeops
[heron-ops]: https://github.com/warbletech/heron-ops
[community]: https://github.com/warbletech/community
[shrikeops-demo]: https://github.com/warbletech/shrikeops-demo
[warble-bootstrap]: https://github.com/warbletech/warble-bootstrap

Clone with submodules (all repos are public):

```bash
git clone --recurse-submodules https://github.com/warbletech/warbleoss.org.git
```

In an existing clone:

```bash
git submodule update --init --recursive
```

You do not need the submodules to work on the site itself.

## Develop

```bash
python3 -m http.server 8080
# open http://127.0.0.1:8080
```

## Deploy

The site runs on GKE (the warble-core cluster) as a small Caddy image ([`Dockerfile`](Dockerfile),
[`Caddyfile`](Caddyfile), [`k8s/`](k8s/)). Only `index.html`,
`404.html`, `assets/` and `revision.txt` are copied into the image.

[`.github/workflows/deploy.yml`](.github/workflows/deploy.yml):

- **Pull requests:** link check, `docker build`, and a local container smoke test.
- **Push to `main` / manual run:** the same checks, then build/push to Artifact Registry and roll out on GKE to the
  `production` environment, then a smoke test that waits until
  `https://warbleoss.org/revision.txt` shows the pushed commit, and checks for
  a 200 status and the page title.

Setup (secrets, WIF, static IP, DNS) is in [DEPLOY.md](DEPLOY.md).

Run the production image locally:

```bash
docker build -t warbleoss-site . && docker run --rm -p 8080:8080 warbleoss-site
curl -s localhost:8080/healthz   # ok
```

## Speaking rules (do not break)

| Say                                                     | Don't say                                  |
| ------------------------------------------------------- | ------------------------------------------ |
| "Starling EX Community is planned for CNCF donation"    | "We are a CNCF project" (until accepted)   |
| "Frakma-X is our Linux Foundation wing"                 | "FRAKMA is an LF project" without Frakma-X |
| "LFX Crowdfunding planned after public OSS + community" | Implying funds are live before listing     |

## CNCF

See [CNCF.md](CNCF.md) for the CNCF Sandbox readiness checklist and steps.
Warble Cloud is a Linux Foundation member and an Agentic AI Foundation (AAIF)
Silver member.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md), [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md),
and [SECURITY.md](SECURITY.md).

## License

[Apache-2.0](LICENSE)
