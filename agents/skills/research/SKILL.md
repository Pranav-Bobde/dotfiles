---
name: research
description: Research current, technical, commercial, legal, or niche questions against high-trust sources. Use when the user asks to research, investigate, compare evidence, verify claims, or find non-obvious information beyond a quick lookup.
---

# Research

Produce the strongest answer the available evidence supports. Optimize for correctness, coverage, and decision value. Do not constrain research merely to save tokens or cost.

## Model and delegation policy

- Use `gpt-5.6-luna` with xhigh reasoning for research subagents unless the user requests another Codex model.
- Split genuinely independent questions across parallel Luna xhigh subagents when that improves source coverage or lets competing explanations be investigated independently.
- Nested delegation is allowed when it improves quality. Every child must own a distinct unresolved question and return evidence to its parent. Do not recursively invoke this skill, spawn agents merely to summarize another agent, or create an unbounded chain.
- The parent owns source reconciliation, citation checks, and the final conclusion. Agent agreement is not evidence.
- Claude may be used only when the user requests it or a Claude perspective would materially improve the work. Invoke it through the installed `cc-skill` in an interactive terminal. Never pass a Claude model name to Codex's native subagent tools.

Do not use a fixed source count or token budget unless the user asks for one. Stop when the evidence has saturated: the material claims have direct support, conflicts are resolved or clearly presented, another search is not changing the conclusion, and remaining unknowns are named.

## Source order

1. Inspect user-provided material and relevant local files first.
2. Prefer primary sources: official documentation, source code, specifications, first-party APIs, filings, court or government material, direct product pages, and original datasets.
3. Use strong secondary sources for context, discovery, independent testing, or when no primary source exists. Trace important claims back to the source that owns them.
4. For changing facts, verify them live and record the date. For news, separate publication date from the date the event occurred.
5. Record blocked, inaccessible, or missing sources. Do not silently replace unavailable evidence with a weaker claim.

For technical questions, rely on official documentation, source code, standards, or research papers. For products, pricing, availability, legal, medical, or financial questions, distinguish a listing or claim from verified applicability, deliverability, or current terms.

## Investigation

Frame the decision or question before collecting facts. Identify what would change the answer and which sources can prove it. Search broadly enough to find conflicting evidence, then spend depth on claims that affect the conclusion.

Keep three evidence states distinct:

- **Verified:** directly supported by a cited source or observed artifact.
- **Inference:** a reasoned conclusion from verified facts. State the reasoning.
- **Unknown:** evidence is missing, inaccessible, stale, or contradictory.

When sources disagree, check scope, date, version, jurisdiction, methodology, and whether one source merely repeats the other. Do not resolve disagreement by majority vote.

## Output

Lead with the answer or decision-relevant finding. Then provide the evidence, caveats, and remaining unknowns at the level of detail the task needs.

- Cite each material web claim with a direct link near the claim.
- Name the source and date when freshness matters.
- Separate confirmed facts from inference.
- State important coverage gaps and failed verification attempts.
- Prefer concise paraphrase over quotation.
- Write the result in chat by default. Create a Markdown artifact only when the user requests one or the task clearly requires a durable project document.
- Do not modify external systems, publish, purchase, submit forms, or send messages unless the user separately authorizes that action.

Before finishing, check that every decision-changing claim has support, citations point to the actual supporting page, and the conclusion does not outrun the evidence.
