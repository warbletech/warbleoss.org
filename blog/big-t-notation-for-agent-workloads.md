# Big-T Notation: Measuring Agent Workloads in Tokens

**Avinash Patil**, founder of Warble Cloud  
20 November 2026

Every era of computing has a scarce unit that quietly dictates architecture: memory, then bandwidth, then the cloud line items in a FinOps report. For systems that call large language models, that unit is the token — the chunk of text a model reads and writes, and the unit most providers use to bill inference.

Complexity thinking is not new to machine learning, but it has mostly been applied to training. The harder question, after a model is deployed, is how token consumption grows as usage grows, as tasks get more involved, and as we give agents more autonomy.

[Big-T Notation](https://www.tokeneconomics.com/projects/big-t-notation-paper/), a framework by Dan Neff (Adobe) published by the [Tokenomics Foundation](https://www.tokeneconomics.com/), gives that question a shared vocabulary. The Foundation is a vendor-neutral project hosted by the [Linux Foundation](https://www.linuxfoundation.org/press/linux-foundation-launches-the-tokenomics-foundation-to-define-the-economics-and-roi-of-ai-value), launched on 4 August 2026. Big-T is informal on purpose: it is not a proof system and it does not predict an exact token count. Like Big-O, it classifies how cost grows, so you can make architectural decisions without benchmarking every input.

This post is our reading of that framework, and how we intend to apply it when we meter agent traffic. The ideas are the Foundation's; the implementation comments are ours.

## The ladder, in brief

Big-T orders workloads by growth rate. In the paper, *n* is deliberately loose: it can mean how many requests you serve, how large each request is, or both. The class describes how model token consumption responds as that dimension grows. Each step down the ladder adds a multiplier. Those multipliers are often invisible in the request the user actually sent.

| Class | What grows | A typical agent example |
| --- | --- | --- |
| T(1) | Almost nothing with usage, because the model is not invoked per request | A cache hit, a deterministic policy deny, a precomputed answer |
| T(log n) | Tokens that reach the model grow slowly as the corpus grows, because most of the data is filtered out first | Retrieval or structured queries that send only the relevant slice of a large store |
| T(n) | Tokens scale with requests or input size | A single-turn completion, or an agent call that does a bounded amount of work per request |
| T(n·k) | A hidden multiplier *k* sits on top of linear work | Reasoning traces, multi-step tool use, context replayed on every turn |
| T(n·k·a) | A further multiplier *a* for agent depth | A supervisor that fans out to sub-agents, or an actor/critic loop that calls the model more than once per step |
| T(∞) | No ceiling | A retry or planning loop with no budget, no timeout, and no kill switch |

Two details are easy to miss. A workload can look linear and still carry a large fixed tax: if an agent loads a full tool catalogue into context on every call, those tokens are spent before any useful work begins. And the class is often concealed. Reasoning tokens, tool-call fan-out and agent depth rarely appear in the user-facing request, so spend can belong to a higher class than the prompt suggests.

The notation also does not measure constants. Halving tokens with tighter serialization, or picking a cheaper model, can change the bill by a large factor and still leave the class alone. Only an architectural change moves a workload between classes. The two questions, in order, are: what class is this workload, and how cheaply does it run inside that class?

## Why this matters for agents

A chatbot that answers one question is often T(n). The systems we actually ship are usually not.

An actor/critic design, of the kind we use in Reflexion, is at least two model invocations per step, plus the context each role needs. A planner that calls tools, reads the result, and calls again is T(n·k), and *k* is a property of the interface as much as of the task. If tools cannot pass results to one another and the agent re-reads the whole history between steps, you pay for the same context over and over. The paper's worked example is that collapsing a bag of tools behind a composable interface can move a workload from T(n·k) toward T(n), without changing the model or the output.

Delegation does not, by itself, leave T(n·k·a). Good sub-agent design can shrink the constants — a narrow context per sub-problem, a cheaper model for the easy steps — but unbounded depth with unscoped context is how a product becomes T(∞). The paper reserves that class for systems with no circuit breakers, and notes that they already exist in production.

That is why "we will pick a cheaper model" is the wrong first move. A frontier reasoning model can quietly turn a linear task into a multiplicative one, because the extra tokens are consumed inside the thinking loop. Model choice matters, but it is a coefficient until you know the class.

## Metering at the gateway

You cannot classify what you cannot see, and you cannot govern what you cannot attribute. The Big-T assessment checklist starts with visibility: token consumption by model, workload and cost, and the class of the highest-spend workloads. Cost attribution, budgets and circuit breakers come later in the same list, but they depend on that first step.

At Warble, the place that can see every model, MCP and A2A call is the AI gateway. We run [agentgateway](https://aaif.io/projects), an [Agentic AI Foundation](https://aaif.io/) project, as that front door. North-south traffic arrives on one [Gateway API](https://gateway-api.sigs.k8s.io/) ingress, and routes for MCP, A2A and model traffic go to the gateway. There we can attach identity, apply rate limits, route to a model that is good enough for the task, and record token use against the caller, the agent, the route and the customer.

That telemetry should feed our usage-based billing and credit ledger. A pay-as-you-go product that cannot tie tokens to a customer, a use case and a class will surprise someone — the customer, or us. Seat- and credit-based contracts can hide the same problem, which is why the checklist asks whether those abstractions still let you compare unit economics.

Metering is not optimisation. A gateway can also cache, route and cut a request off. Caching is how some high-repetition work moves toward T(1). Routing is how you pay less inside a class. A budget or a kill switch is how you keep T(n·k·a) from becoming T(∞). We want those levers in one control point so they share the same labels.

We are not publishing token-per-task numbers we have not measured under this discipline. The first deliverable is instrumentation that can support the classification, not a claim that every workload has already moved down the ladder.

## What we will ask of each workload

Before we debate models, we want a short, boring card for each agent path:

- What is the intended class, and what evidence would tell us we have left it?
- Which tokens are a fixed tax (system prompt, tool catalogue, memory) and which are the work?
- Where is the ceiling — max turns, max depth, max tokens, max cost — and what happens when it is hit?
- Who pays, in the ledger, when this path runs?

If we cannot answer those, we do not yet have a token-aware architecture. We have a demo with an invoice attached.

Big-T will not choose a model for us, and it will not set a price. What it offers is a way to talk about agent cost before the bill arrives, in terms that engineering and finance can share. The framework is published as open, vendor-neutral work; we would rather build on it than invent a private dialect for the same idea.

## Further reading

- Dan Neff, [Big-T Notation Paper: A Framework for Token Efficiency](https://www.tokeneconomics.com/projects/big-t-notation-paper/), Tokenomics Foundation.
- Tokenomics Foundation, [The Seven-Layer Tokenomics Stack](https://www.tokeneconomics.com/projects/the-seven-layer-tokenomics-stack/) — the companion view of where in the stack a class is set or moved.
- Linux Foundation, [Tokenomics Foundation launch](https://www.linuxfoundation.org/press/linux-foundation-launches-the-tokenomics-foundation-to-define-the-economics-and-roi-of-ai-value), 4 August 2026.
