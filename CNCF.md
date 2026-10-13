# Path to CNCF

Warble OSS plans to propose the open agent-ops flock to the
[Cloud Native Computing Foundation](https://www.cncf.io) (CNCF) as a **Sandbox**
project. This page tracks what is done and what is still missing. It is a plan,
not a claim: the project is **not** a CNCF project until the CNCF Technical
Oversight Committee (TOC) votes to accept it and a Contribution Agreement is
signed.

Warble Cloud is a **Linux Foundation member** and an
**[Agentic AI Foundation (AAIF)](https://aaif.io) Silver member**. AAIF is the
Linux Foundation home of the Model Context Protocol (MCP) that our tools speak.

_Last reviewed: 2026-10-11._

## Candidate project

| Component                                                                      | Repository                                                                | What it is                                                |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------- | --------------------------------------------------------- |
| Umbrella, Starling Lite MCP facade, tool registry, Helm chart `starling-ex-ce` | [warbletech/warble-army](https://github.com/warbletech/warble-army)       | Primary repo                                              |
| Heron Ops                                                                      | [warbletech/heron-ops](https://github.com/warbletech/heron-ops)           | Kubernetes MCP server (read-only by default, RBAC-scoped) |
| ShrikeOps                                                                      | [warbletech/shrikeops](https://github.com/warbletech/shrikeops)           | Manifest / Helm scanner with a scored report              |
| ShrikeOps demo                                                                 | [warbletech/shrikeops-demo](https://github.com/warbletech/shrikeops-demo) | Fixtures and CI demo                                      |

Not in scope: the closed-source `starling` CLI release channel, `warble-core`,
`warble-bootstrap` (FRAKMA demo stack), Warble Cloud SaaS and Frakma-X.

The working name is **Starling EX Community**. Because accepted projects donate
their trademarks to CNCF and "Starling EX" is also a commercial product name,
the final project name is still open.

## Readiness checklist

Status is based on what exists in the repositories today.

| Requirement                                         | Status               | Where                                                                                                                                           |
| --------------------------------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Public source repositories                          | ✅ Done (2026-10-11) | [github.com/warbletech](https://github.com/warbletech)                                                                                          |
| Apache-2.0 license on in-scope repos                | ✅ Done              | `LICENSE` in warble-army, heron-ops, shrikeops, shrikeops-demo                                                                                  |
| Third-party dependency licenses on CNCF allowlist   | 🟡 In progress       | Go deps scanned (Apache-2.0, BSD-3-Clause, MIT, ISC); ShrikeOps frontend (npm) not yet scanned                                                  |
| Code of Conduct                                     | ✅ Done              | [docs/cncf/CODE_OF_CONDUCT.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/CODE_OF_CONDUCT.md)                                |
| Contributing guide                                  | ✅ Done              | [docs/cncf/CONTRIBUTING.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/CONTRIBUTING.md)                                      |
| Security policy                                     | ✅ Done              | [docs/cncf/SECURITY.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/SECURITY.md)                                              |
| Governance                                          | 🟡 Seed              | [docs/cncf/PROJECT_GOVERNANCE.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/PROJECT_GOVERNANCE.md)                          |
| Maintainers file (Name, GitHub ID, Company columns) | 🟡 In progress       | [docs/cncf/MAINTAINERS.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/MAINTAINERS.md): GitHub IDs and company column missing |
| Maintainers from more than one organization         | ⬜ Not yet           | All current maintainers are from Warble                                                                                                         |
| Adopters file                                       | 🟡 Seed              | [docs/cncf/ADOPTERS.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/ADOPTERS.md): steward only                                |
| Public roadmap                                      | 🟡 In progress       | [docs/STARLING_EX_CE.md](https://github.com/warbletech/warble-army/blob/main/docs/STARLING_EX_CE.md); no dedicated `ROADMAP.md` yet             |
| Website                                             | ✅ Done              | [warbleoss.org](https://warbleoss.org)                                                                                                          |
| Live demo                                           | ✅ Done              | [mcp.warbleoss.org](https://mcp.warbleoss.org) (read-only)                                                                                      |
| Helm install                                        | ✅ Done              | `charts/starling-ex-ce`                                                                                                                         |
| Tagged releases                                     | 🟡 In progress       | ShrikeOps v0.1.0; none yet for Heron Ops or Starling Lite                                                                                       |
| Automated tests                                     | 🟡 In progress       | Starling Lite has tests; Heron Ops and ShrikeOps have none yet                                                                                  |
| Public community channel                            | ✅ Done              | [Discord](https://discord.gg/kAfR57mVDX), weekly Office Hours                                                                                   |
| Trademark / project name ready to donate            | ⬜ Not yet           | Needs naming decision and legal review                                                                                                          |
| Contribution Agreement signatory                    | ⬜ Not yet           | ChirpStack LLP (Warble Cloud), signs only after TOC acceptance                                                                                  |
| TAG presentation / General Technical Review (Day 0) | ⬜ Not yet           |                                                                                                                                                 |
| OpenSSF Best Practices badge                        | ⬜ Not yet           | Not required for Sandbox; **required** for Incubation                                                                                           |
| CLOMonitor score                                    | ⬜ Not yet           | CLOMonitor tracks CNCF projects after acceptance                                                                                                |
| Cloud Native Landscape / LFX Insights listing       | ⬜ After acceptance  |                                                                                                                                                 |

## Steps

### 1. Sandbox

1. Close the open items above: maintainers file format, tests, releases,
   project name.
2. Open a [Sandbox application](https://github.com/cncf/sandbox/issues/new?template=application.yml)
   on `cncf/sandbox` (a filled draft is kept by the maintainers).
3. The TOC reviews applications in batches (roughly every two months) and
   may approve, ask for more information or postpone.
4. If approved: sign the Contribution Agreement, transfer trademarks and
   accounts, and complete CNCF onboarding.

### 2. Incubation

Requires, among others: a completed General Technical Review and governance
review, a public roadmap with a change process, a history of regular releases,
a documented security self-assessment and security-response roles, the
**OpenSSF Best Practices passing badge**, a public adopters list, and at least
three independent adopters that the TOC verifies through interviews.

### 3. Graduation

Requires, among others: maintainers from at least two organizations, an
org-balanced governance mechanism, a documented release process, a joint
security assessment with TAG Security and Compliance and a third-party security
review, the OpenSSF passing badge (silver or gold suggested), and verified
production adopters.

## How you can help

- Use Community Edition and tell us about it: add your organization to
  [ADOPTERS.md](https://github.com/warbletech/warble-army/blob/main/docs/cncf/ADOPTERS.md).
- Become a maintainer: we especially want maintainers from other organizations.
- Pick a [good first issue](https://github.com/search?q=org%3Awarbletech+label%3A%22good+first+issue%22+state%3Aopen&type=issues)
  or join Office Hours on [Discord](https://discord.gg/kAfR57mVDX).

## Sources

- [cncf/sandbox: how to apply](https://github.com/cncf/sandbox)
- [CNCF TOC: project lifecycle](https://github.com/cncf/toc/blob/main/process/README.md)
- [Incubation criteria](https://github.com/cncf/toc/blob/main/.github/ISSUE_TEMPLATE/template-incubation-application.md)
  and [Graduation criteria](https://github.com/cncf/toc/blob/main/.github/ISSUE_TEMPLATE/template-graduation-application.md)
- [OpenSSF Best Practices](https://www.bestpractices.dev/) and [CLOMonitor](https://clomonitor.io/)
