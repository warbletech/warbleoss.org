# The Seven-Layer Tokenomics Stack on a Cloud-Native Agent Platform

**Avinash Patil**, founder of Warble Cloud  
20 November 2026

[Big-T Notation](https://www.tokeneconomics.com/projects/big-t-notation-paper/) tells you how a workload's token consumption grows. It does not tell you where to reach into the system to change that growth. For that, the [Tokenomics Foundation](https://www.tokeneconomics.com/) published a companion model: the [seven-layer tokenomics stack](https://www.tokeneconomics.com/projects/the-seven-layer-tokenomics-stack/).

The stack's opening claim is easy to underestimate. What a token costs is decided in the lower layers. How many tokens you spend is decided in the upper ones. The token is the unit of account, not the object of study. Cost is the output of a chain of architectural decisions, each inheriting the cost of the decisions beneath it.

This post maps that stack onto the kind of cloud-native agent platform we are building at Warble: Kubernetes as the runtime, Gateway API for ingress, and an AI gateway for models, MCP and A2A. It is a reading of their model, not a claim that we already run an optimised instance of every layer.

## The seven layers

The Foundation numbers the layers from the ground up.

| Layer | Their focus | The lever, as they describe it |
| --- | --- | --- |
| L0 Energy | Power, water, carbon intensity | Where work runs, and when deferrable work runs |
| L1 Physical infrastructure | Accelerators, interconnect, cooling, regions | Matching silicon and location to the workload |
| L2 Infrastructure management | Scheduling, autoscaling, utilisation | How much of the hardware does useful work |
| L3 Inference stack | Engines, caches, tools, agent iteration | Suppressing repeated work; often the largest optimisation |
| L4 Model management | Catalogue, selection, runtime configuration | Right-sizing the model and its settings |
| L5 AI access and control | Admission, routing, guardrails, attribution | Bounding fan-out and retries; the kill switch |
| L6 Demand and entry points | Who asks, through which interface, for what | The use case and the context that arrives with it |

They draw a clean line through the middle. L0–L2 set the cost of a token; they do not, by themselves, change a workload's Big-T class. L3–L5 are where a workload can be moved between classes, or held in one. L6 sets the demand the other layers have to serve.

Governance, identity, observability and cost management cut across all seven. They are not a caching strategy, but they are why a token can be attributed, a budget enforced, or a quality regression noticed.

## Mapping the stack onto a CNCF-shaped platform

We do not operate power plants or design accelerators. A company running on a public cloud still makes decisions at every layer; some of them are just more inherited than others.

**L0 and L1** arrive mostly inside a cloud region and a machine type. Region choice, whether work can wait for a cheaper window, and whether a workload needs an accelerator at all are still real decisions. Many of our current agent-ops paths are CPU-bound control planes, MCP servers and policy engines, not hosted frontier training clusters. Treating every service as if it needed a GPU would be a category error, and an expensive one.

**L2** is the Kubernetes layer, and it is where a lot of silent cost lives. The [CNCF](https://www.cncf.io/) stack we care about here is deliberately boring: a small cluster, private nodes behind a shared egress path, autoscaling that includes a pool that can go to zero, and request limits that match actual use. Idle add-ons raise the effective cost of the work that does run, which is exactly the Foundation's L2 warning. Utilisation is the metric. A platform that reserves a core for a controller that does no work is manufacturing expensive tokens even when no model is called.

**L3** is the inference and agent runtime: the serving engine, prefix and semantic caches, session memory, tool execution, and the loop that plans and retries. The Foundation calls cache hit rate the number that matters most, and says it is won largely through prompt and prefix stability. For us this also includes how MCP tools are designed. An agent that must bounce through the model between every tool call is buying a higher class at L3, regardless of what L4 does. Where we serve models ourselves, this is also the layer where disaggregated or cache-aware serving would land; the Kubernetes [AI Conformance](https://github.com/cncf/k8s-ai-conformance) programme already treats inference routing, and optionally Gateway API inference extensions, as platform capabilities rather than application accidents.

**L4** is model choice and configuration. The classic waste, which the Foundation also names, is running a frontier-scale model for a trivial task. Right-sizing is how multiplicative work is pulled back toward linear. A catalogue that records quality, latency, region and price, and a router that can use it, belongs here. This is not the same as the gateway's kill switch, and it should not be implemented as a single "default model" flag.

**L5** is the layer I care about most as a product and platform decision. It is the governed entry point in front of every model: admission, proxying, routing, policy, and attribution. The Foundation's formulation is blunt, and I think it is correct: this is the only layer that can decide a request needs no model at all, and the only one that can stop a workload consuming without limit. A workload with no ceiling has no worst case.

That is the job we are giving [agentgateway](https://aaif.io/projects), an [Agentic AI Foundation](https://aaif.io/) project. It already sits on our platform as the internal front door for LLM, MCP and A2A traffic. The work ahead is to make it the place that stamps each request with user, app, agent, team and use case, enforces budgets, and emits the token metering that a credit ledger can bill. Routing is an optimisation. A cap is containment. We need both.

**L6** is everything that creates demand: a person in a product UI, a scheduled job, an agent calling a Kubernetes MCP server such as Heron Ops, or another agent speaking A2A. Those entry points do not have the same shape. A chat window, a batch job and a tool-calling agent can hit the same model and produce three different classes. The use case sets the quality, latency and autonomy the work requires, and the request carries the context that becomes tokens. If L6 is sloppy — a weekly job that stuffs an entire project into the prompt, or a tool that returns more than the agent can use — the layers below can only invoice the mess.

## Keep the two models aligned

The Foundation's discipline is to keep the stack and the spectrum together: every unit of work running on the optimal class its value can justify, and every token in that class produced as efficiently as the layers beneath it allow. The stack says where to act; Big-T says whether the action is worth it.

In practice that gives us a short review order when a path is too expensive. Look at L6 first: is the task asking for more context or more autonomy than the outcome needs? Then L5: is there a budget, a route, a chance to return without a model? Then L3 and L4: cache, tool shape, model size. Only then L2, and only rarely L1 or L0, unless we are actually in the business of placing accelerators and power contracts. Starting at the GPU is a common way to skip the layers that move the class.

None of this requires a large organisation. It requires a refusal to treat "the model bill" as a single line, and a platform that makes the other lines visible. Kubernetes, Gateway API, and a governed AI gateway are enough structure to start. The Tokenomics Foundation supplied the map. Our job is to keep our stack honest against it.

## Further reading

- Tokenomics Foundation, [The Seven-Layer Tokenomics Stack](https://www.tokeneconomics.com/projects/the-seven-layer-tokenomics-stack/).
- Dan Neff, [Big-T Notation Paper](https://www.tokeneconomics.com/projects/big-t-notation-paper/), Tokenomics Foundation.
- CNCF, [Kubernetes AI Conformance](https://github.com/cncf/k8s-ai-conformance).
- Agentic AI Foundation, [Projects](https://aaif.io/projects), including agentgateway, MCP and A2A.
