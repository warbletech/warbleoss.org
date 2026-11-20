# Building on AAIF, the Linux Foundation, and CNCF

**Avinash Patil**, founder of Warble Cloud  
20 November 2026

Agent platforms are starting to look like the early cloud: every vendor has a private way to connect models to tools, to let agents talk to each other, and to run the work on a cluster. That is fine for a prototype. It is a poor foundation for a product that customers have to trust for more than one quarter.

Warble is a small company. We cannot, and should not, define the protocols the industry will use. What we can do is build on the ones that already have neutral homes, contribute where we have a sharp edge, and be honest about what we have not done yet. That is why we spend time with three Linux Foundation family organisations: the [Agentic AI Foundation](https://aaif.io/) (AAIF), the Linux Foundation itself, and the [Cloud Native Computing Foundation](https://www.cncf.io/) (CNCF).

This is not a membership brochure. It is an account of which standards we are building on, and why that choice is technical rather than decorative.

## AAIF: a neutral home for agent protocols

The Linux Foundation [announced AAIF on 9 December 2025](https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation), with three founding project contributions: Anthropic's Model Context Protocol (MCP), Block's goose, and OpenAI's AGENTS.md. The point of the foundation, as that announcement put it, is to give agentic AI a vendor-neutral place to evolve.

Those first projects cover different layers of the same problem. MCP is the protocol for connecting model applications to tools and data. goose is an open, local-first agent that uses those tools. AGENTS.md is a simple, repository-level convention so coding agents can find the guidance they need to work in a given codebase. We use MCP in our open work today: Heron Ops is a Kubernetes MCP server, and the community endpoint at [mcp.warbleoss.org](https://mcp.warbleoss.org) is there so people can try the protocol against a live service, not only a specification.

AAIF's project list has grown since launch. On 22 October 2026 the foundation [announced four new projects](https://www.linuxfoundation.org/press/agentic-ai-foundation-announces-four-new-projects-agent-skills-open-responses-openenv-and-opensandbox) — Agent Skills, Open Responses, OpenEnv and OpenSandbox — and noted that it now hosts ten projects, with 305 member organisations. The earlier arrivals in that set include the Agent2Agent (A2A) protocol, Agent Router, and [agentgateway](https://aaif.io/projects). We care about those three in particular. A2A is how we want agents to collaborate across products without a private handshake. agentgateway is the open gateway we are using as the control point for model, MCP and A2A traffic, including the token metering that should feed usage-based billing.

Building on these projects is a product decision. If a customer can attach the same MCP server to our agents and to someone else's, they are less trapped. If our gateway speaks the same protocols, we can spend our engineering time on policy, attribution and Kubernetes operations rather than on a one-off RPC dialect. That is the practical meaning of "open standards" for a company our size.

## The Linux Foundation, and what membership is not

AAIF sits under the Linux Foundation. [AAIF membership](https://aaif.io/members) requires Linux Foundation membership at some level; Silver dues are based on headcount, and the AAIF charter does not give Silver members a Governing Board seat or governance vote by right. Participation is still useful: working groups, office hours, a seat on the outreach committee, and a small number of vendor-neutral blog posts each year, subject to editorial review.

Warble Cloud is a Linux Foundation member and an AAIF Silver member, as we already state on [warbleoss.org](https://warbleoss.org/#cncf). We should keep that statement exact. We are not a Platinum member, we do not sit on the AAIF Governing Board, and Silver membership is not a substitute for technical contribution. The valuable work is in the projects: using MCP and A2A as specified, running agentgateway, filing issues, and writing down what broke when we put those pieces on a cluster.

The Linux Foundation is also the host of the [Tokenomics Foundation](https://www.linuxfoundation.org/press/linux-foundation-launches-the-tokenomics-foundation-to-define-the-economics-and-roi-of-ai-value), launched on 4 August 2026. The three earlier posts in this series draw on that body's language for token cost and demand. It is a reminder that "the LF family" is broader than a single foundation logo. Agent protocols, cloud-native runtimes, and the economics of tokens are being standardised in adjacent rooms. We need all three.

## CNCF: the runtime, and conformance as a discipline

If AAIF is where agent protocols should live, CNCF is where the runtime already lives. Our open flock — ShrikeOps, Heron Ops, and Starling EX Community, grouped under [warble-army](https://github.com/warbletech/warble-army) — is built for Kubernetes. We plan to propose that flock to CNCF as a Sandbox project. That is a plan, not a status. We do not call these CNCF projects, and we will not until the Technical Oversight Committee accepts a donation. The readiness work is public on warbleoss.org.

CNCF is also running a programme that sits closer to the tokenomics and inference questions in this series. The [Kubernetes AI Conformance](https://github.com/cncf/k8s-ai-conformance) programme defines a baseline of capabilities a Kubernetes platform should offer to run training, inference and agentic workloads portably. A platform has to be Kubernetes-conformant first. Submissions are pull requests against that repository, with a versioned checklist and evidence.

We have not published a product conformance submission of our own, and we do not claim to be an AI-conformant platform. What we have done is contribute to the programme's plumbing. In [cncf/k8s-ai-conformance#131](https://github.com/cncf/k8s-ai-conformance/pull/131), merged on 29 October 2026, we changed the evidence-URL validator so that HTTP 429 responses are retried with backoff, honouring `Retry-After` where present, and reported as a warning if they persist, rather than failing a submission because a documentation host rate-limited the CI runner. It is a small change. It is also the kind of work that decides whether a conformance programme can be used in practice.

The conformance checklists themselves are a useful design prompt even before anyone submits. They treat things like Gateway API for inference traffic, accelerator access, and (in later revisions) disaggregated serving as platform questions. That matches how we want to think about L2 and L3 of the tokenomics stack: not as application accidents, but as cluster capabilities you can describe and test.

## What we will not claim

A few lines we will keep repeating, including to ourselves:

- We are an LF member and an AAIF Silver member. That is participation, not governance power, and not a certification of our software.
- MCP, A2A, AGENTS.md, agentgateway and the other AAIF projects are not "Warble standards." We implement and, where we can, contribute.
- The warble-army flock is on a planned CNCF Sandbox path. It is not a CNCF project today.
- PR #131 is a validator fix, not a Warble AI conformance badge.

Open governance is slower than a private repo, and that is the point. Protocols that agents, gateways and clusters share will outlast any one vendor's roadmap, including ours. The job for a company like Warble is to be a serious user of those protocols, a careful contributor, and a platform that makes the resulting systems operable — including the unfashionable part, which is measuring and capping what they cost.

## Further reading

- Linux Foundation, [Formation of the Agentic AI Foundation](https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation), 9 December 2025.
- Linux Foundation, [AAIF surpasses 300 members](https://www.linuxfoundation.org/press/agentic-ai-foundation-surpasses-300-members-in-less-than-one-year) and [four new AAIF projects](https://www.linuxfoundation.org/press/agentic-ai-foundation-announces-four-new-projects-agent-skills-open-responses-openenv-and-opensandbox), 22 October 2026.
- [AAIF projects](https://aaif.io/projects) and [membership](https://aaif.io/members).
- CNCF, [Kubernetes AI Conformance](https://github.com/cncf/k8s-ai-conformance); [PR #131](https://github.com/cncf/k8s-ai-conformance/pull/131).
- [warbleoss.org](https://warbleoss.org/#cncf), including our current CNCF path and membership wording.
