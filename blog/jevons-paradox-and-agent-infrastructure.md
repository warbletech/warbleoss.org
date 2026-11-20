# Jevons Paradox: Why Cheaper Tokens Mean More Agent Infrastructure

**Avinash Patil**, founder of Warble Cloud  
20 November 2026

When a resource gets cheaper to use, people often use more of it — sometimes enough more that total spend goes up, not down. William Stanley Jevons made the observation about coal in the nineteenth century. The [Tokenomics Foundation](https://www.tokeneconomics.com/what-is-ai-tokenomics/#term-jevons-paradox) applies the same pattern to AI tokens: efficiency that lowers unit cost can raise total consumption and total spend. In their words, this is already visible in AI, where falling token prices have accompanied rising total spend.

That is not an argument against efficiency. It is a warning about what efficiency does to demand, and therefore to the platform that has to absorb it.

At Warble we sell and operate agentic systems: agents that plan, call tools, critique their own work, and call models again. If tokens get cheaper, those systems will be asked to do more, by more users, with more tools attached. The bill that grows is only partly the model invoice. The rest shows up as Kubernetes capacity, gateways, caches, evaluation jobs, observability, and the people who keep that path reliable. Cheaper tokens do not shrink that surface. They enlarge it.

## Tokens are where the conversation starts, not where it ends

The Foundation's working definition of AI tokenomics, draft v0.5.2 (1 September 2026), is the discipline of converting energy and capital into AI capabilities and consuming that intelligence in a way that produces measurable business value. Their shorthand is "energy to intelligence to value." They are careful to separate this from the cryptocurrency sense of the word: here, a token is the atomic unit of AI.

They are also careful about proportion. In enterprise conversations, token costs are typically 10 to 25 percent of the total cost of AI. The rest — what they call total cost of AI — includes orchestration, agent loops, memory, retrieval, evaluations, governance, data, and labour. Labour appears twice: once to build and run the system, and again in the staffing changes the system causes.

That range is the Foundation's, not a Warble measurement, and we should not pretend we have a more precise split until we can show one. The useful implication is already clear. A team that only watches the model invoice is watching a minority of the cost, and usually the easiest minority to meter. The rest hides in platform software and in human time.

Their related point about value is just as important. Cost per token measures production efficiency. It is a poor value metric, because models do not use the same number of tokens to finish the same task. Cost per task is closer to ordinary unit economics. Cost per outcome asks whether the work held up, including the failed attempts. A cheaper token that funds a longer agent loop can raise cost per outcome.

## Why demand grows faster than price falls

The [Big-T paper](https://www.tokeneconomics.com/projects/big-t-notation-paper/) describes four demand waves that stack rather than replace each other. More capable models often consume more tokens per task, especially when reasoning and tool use are involved. Larger context windows make it easy to send more than the task needs. Agentic designs turn one prompt into many model calls. And adoption adds users, use cases and agents to the baseline.

Several of those multipliers never show up in a simple forecast of "users × requests × tokens per request." Hidden reasoning tokens, a cache miss rate, retries, and a supervisor that fans out to sub-agents all rewrite the number. The Foundation's tokenomics overview makes the same point: each efficiency gain has so far unlocked new demand rather than reducing it.

This is Jevons in operational form. A price cut, a faster model, or a better cache does not automatically reduce the platform bill. It often changes what people are willing to ask the system to do. An agent that was too expensive to run on every ticket becomes cheap enough to try, and then cheap enough to leave on. "Tokenmaxing" — the habit, named in the Foundation's glossary, of sending every task to the most powerful model because tokens felt free — is one failure mode. The quieter one is leaving every new agent on the most expensive path because no one set a class or a ceiling.

## What this means for a platform team

If you run the cluster that hosts the agents, Jevons shows up as infrastructure pressure, not as a pricing slide.

More agent traffic means more north-south connections, more long-lived streams, more tool calls out to MCP servers, and more internal service-to-service traffic. It means caches and memory that have to be sized for the miss path, not the happy path. It means evaluation and tracing volume that grows with autonomy, because a multiplicative workload that you cannot inspect is a production risk. It also means identity, rate limits and budgets have to sit in front of the models, or a single loop will consume an unbounded share of the month.

We have already felt a narrower version of this in our own Kubernetes platforms: the scarce resource was not always GPU time. External IP quota, CPU requested by idle add-ons, and ingress sprawl can stall work that has nothing to do with a model. Those are Total Cost of AI items. They are also the reason we want a smaller, more deliberate platform — one Gateway API ingress, a focused AI gateway, and a mesh only where we need L7 policy — rather than a new controller for every experiment.

The platform response to Jevons is therefore not "use a cheaper model" as a first principle. It is:

1. **Instrument demand**, so you can see tokens, fan-out, retries and cache hits per route, per agent and per customer.
2. **Put a ceiling on autonomy**, so T(n·k·a) workloads cannot become unbounded. Budgets and kill switches belong in the gateway, not in a wiki.
3. **Right-size the path**, not only the model: retrieval and filtering before the prompt, composable tools so context is not replayed, caches for the stable prefix, and a model tier that matches the task.
4. **Provision for the multiplier**, including the non-token parts of the bill: the cluster, the database, the queue, the eval jobs, and the on-call time.
5. **Price from outcomes where you can**, so a drop in unit token price does not silently destroy the margin on a pay-as-you-go product.

That last point is a product decision, not only a FinOps one. If we meter tokens at [agentgateway](https://aaif.io/projects) and feed a credit ledger, we still have to decide whether the customer is buying tokens, tasks, or outcomes. Tokens are the unit we can count most reliably today. They should not be the only unit we use to judge whether the system is earning its keep.

## Efficiency still matters

None of this is a case for wasting tokens. The Foundation's conclusion in the Big-T work is that organisations which treat tokens as an undifferentiated commodity will be surprised by the bill and unable to trace it to value — the same place many companies landed after moving to the cloud without cost governance. We agree, and we would add the platform corollary: organisations that treat agent infrastructure as an undifferentiated commodity will be surprised by quota, latency and toil, even if the model invoice looks tidy.

Cheaper tokens are a gift, and they will keep arriving. The work is to receive that gift without letting demand write cheques the architecture cannot cash. For a team that runs agents on Kubernetes, that is mostly unglamorous engineering: classify the workload, meter it, cap it, and keep the cluster small enough that the non-token majority of the AI bill stays visible.

## Further reading

- Tokenomics Foundation, [What Is AI Tokenomics?](https://www.tokeneconomics.com/what-is-ai-tokenomics/), including the [Jevons paradox](https://www.tokeneconomics.com/what-is-ai-tokenomics/#term-jevons-paradox) entry. Draft definition v0.5.2, 1 September 2026.
- Dan Neff, [Big-T Notation Paper](https://www.tokeneconomics.com/projects/big-t-notation-paper/), Tokenomics Foundation, in particular the compounding-demand thesis and the closing discussion of Jevons.
- Linux Foundation, [Tokenomics Foundation launch](https://www.linuxfoundation.org/press/linux-foundation-launches-the-tokenomics-foundation-to-define-the-economics-and-roi-of-ai-value), 4 August 2026.
