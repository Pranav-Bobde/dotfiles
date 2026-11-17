---
name: wayfinder
description: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear.
---

A loose idea has arrived, too big for one agent session, and wrapped in fog: the way from here to the **destination** isn't visible yet. Wayfinding is about finding that way, not charging at the destination. This skill charts the way as a **shared map** on the repo's issue tracker, then works its **decision tickets** (questions whose resolution is a decision, not slices of a build to execute) one at a time until the route is clear.

The destination varies per effort, and naming it is the first act of charting: it shapes every ticket. It might be a spec to hand off and iterate on, a decision to lock before planning starts, or a change made in place like a data-structure migration. The map is domain-agnostic: engineering work, course content, whatever fits the shape.

## Plan, don't do

Wayfinder is **planning** by default: each ticket resolves a decision, and the map is done when the way is clear, with nothing left to decide before someone goes and does the thing. The pull to just do the work is usually the signal you've reached the edge of the map and it's time to hand off. An effort can override this in its **Notes**, carrying execution into the map itself, but absent that, produce decisions, not deliverables.

## Authorization and model policy

- Read-only tracker inspection is allowed when it is relevant to the request.
- A local Markdown map may be created or updated when the user asks to chart or work through a map in the current repository.
- For GitHub, GitLab, Jira, Linear, or another remote tracker, draft the complete map, tickets, labels, and dependency edges first. Obtain explicit user approval before the first remote write. One approval may cover the described batch.
- Before posting a resolution, closing a remote ticket, changing its assignment, or modifying the map after a decision, show the intended remote changes and obtain approval for that batch.
- Never delete a remote ticket. Close or mark it superseded after approval so the history remains recoverable.
- Research tickets use the installed `research` skill. Its research agents default to `gpt-5.6-luna` at xhigh reasoning. Claude may be used only through `cc-skill`.

## Refer by name

Every map and ticket is an issue, so it has a **name**: its title. In everything the human reads (narration, the map's Decisions-so-far), refer to it by that name, never by a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. The id and URL don't vanish; a name wraps its link, but they ride _inside_ the name, never stand in for it.

## The Map

The map is one canonical artifact. On a remote tracker it is an issue labelled `wayfinder:map`; in the local-Markdown tracker it is `map.md`. Its tickets are child issues or child files.

The map is an **index**, not a store. It lists the decisions made and points at the tickets that hold their detail; a decision lives in exactly one place, its ticket, so the map never restates it, only gists it and links.

**Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific.** Read `docs/agents/issue-tracker.md` when it exists. If it is missing, default to the local-Markdown tracker for the current effort and mention that `setup-matt-pocock-skills` can configure another tracker later. Do not block planning on setup.

### The map body

The whole map at low resolution, loaded once per session. Open tickets are **not** listed: they are open child issues, found by query.

```markdown
## Destination

<what reaching the end of this map looks like: the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; skills every session should consult; standing preferences for this effort>

## Decisions so far

<!-- the index: one line per closed ticket, enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<closed ticket title>](link): <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- see "Out of scope": work ruled beyond the destination; closed, never graduates -->
```

### Tickets

Each ticket is a **child issue** of the map; the tracker's issue id is its identity. Its body is the question, sized to one 100K token agent session:

```markdown
## Question

<the decision or investigation this ticket resolves>
```

Each ticket carries a `wayfinder:<type>` label, one of `research`, `prototype`, `grilling`, `task` (see [Ticket Types](#ticket-types)).

A session **claims** a ticket by assigning it to the dev driving the map, **first**, before any work, so concurrent sessions skip it. That assignee _is_ the claim: an open, unassigned ticket is unclaimed.

Blocking uses the tracker's **native** dependency relationship: essential because it renders the frontier _visually_ in the tracker's own UI, so the human sees what's takeable without opening the map. Only a tracker that lacks native blocking falls back to a body convention. A ticket is **unblocked** when every ticket blocking it is closed; the **frontier** is the open, unblocked, unclaimed children, the edge of the known.

The answer isn't part of the body; it's recorded on resolution (see [Work through the map](#work-through-the-map)). Assets created while resolving a ticket are linked from the issue, not pasted in.

## Ticket Types

Every ticket is either **HITL** (human in the loop, worked _with_ a human who speaks for themselves) or **AFK**, driven by the agent alone. A HITL ticket only resolves through that live exchange; the agent never stands in for the human's side of it (a grilling agent that answers its own questions has broken this).

- **Research** (AFK): Read documentation, APIs, primary sources, or local knowledge bases to surface a fact a decision waits on. Read and follow the installed `research` skill. Use when knowledge outside the current working directory is required.
- **Prototype** (HITL): Raise the fidelity of the discussion with a cheap, rough artifact to react to, such as an outline, stub, or UI or logic prototype. Read and follow the installed `prototype` skill. Link or record the artifact only in the approved tracker or local map.
- **Grilling** (HITL): Conversation, the default case. Read and apply both `grilling` and `domain-modeling`.
- **Task** (HITL or AFK): Manual work that must happen before a _decision_ can be made: nothing to decide, prototype, or research, but the discussion is blocked until it's done. Signing up for a service so its API can be judged, provisioning access, moving data so its shape can be seen. This is the one type that _does_ rather than decides, and it earns its place by unblocking a decision, not by delivering the destination. The agent drives it alone where it can (AFK); otherwise it hands the human a precise checklist (HITL). Resolved when the work is done; the answer records what was done and any resulting facts (credentials location, new URLs, row counts) later tickets depend on.

## Fog of war

The map is _deliberately_ incomplete: don't chart what you can't yet see. Beyond the live tickets lies the **fog of war**: the dim view of decisions and investigations you can tell are coming but can't yet pin down, because they hang on questions still open. Resolving a ticket clears the fog ahead of it, graduating whatever's now specifiable into fresh tickets, one at a time, until the way to the destination is clear and no tickets remain.

The map's **Not yet specified** section is where that dim view is written down: the suspected question, the area to revisit later. It's the undiscovered frontier _toward_ the destination: everything here is in scope, just not sharp enough to ticket. Write as loosely or as fully as the view allows; it doubles as a signpost for collaborators reading where the effort is headed.

**Fog or ticket?** The test is whether you can state the question precisely now, _not_ whether you can answer it now.

- **Ticket when** the question is already sharp, even if it's blocked and you can't act on it yet.
- **Not yet specified when** you can't yet phrase it that sharply. Don't pre-slice the fog into ticket-sized pieces: it's coarser than a ticket, and one patch may graduate into several tickets, or none, once the frontier reaches it.

**Not yet specified** excludes what's already decided (Decisions so far), what's already a live ticket, and what's out of scope (the next section).

## Out of scope

Fog only ever gathers _toward_ the destination. The destination fixes the scope, so work beyond it is **out of scope**: it isn't fog, and it doesn't belong in **Not yet specified**. It gets its own **Out of scope** section on the map: work you've consciously ruled out of _this_ effort. Scope, not sharpness, lands it here.

Out-of-scope work never graduates (the frontier stops at the destination), so it returns only if the destination is redrawn, and then as a fresh effort, not a resumption.

Ruling something out of scope is a scoping act, not a step on the route. When an existing ticket sits past the destination, close it locally or propose closing it remotely, then leave one line in **Out of scope** with the gist, reason, and ticket link. It stays out of **Decisions so far**, which records the route actually walked.

## Invocation

Two modes. Either way, **never resolve more than one ticket per session**, with the exception of research tickets.

### Chart the map

User invokes with a loose idea.

1. **Name the destination.** Read and apply `grilling` and `domain-modeling` to pin down what this map is finding its way to: the spec, decision, or change. The destination fixes the scope, so settle it first.
2. **Map the frontier.** Grill again, **breadth-first** this time: fan out across the whole space rather than deep on any one thread, surfacing the open decisions and the first steps takeable now. **If this surfaces no fog** (the way to the destination is already clear, the whole journey small enough for one session), you don't need a map. Stop and ask the user how they'd like to proceed.
3. **Draft the map.** Fill Destination and Notes, leave Decisions-so-far empty, and sketch the fog in **Not yet specified**. For a remote tracker, present this draft and the intended label before writing.
4. **Draft the tickets you can specify now** and their blocking edges. For local Markdown, create the files after the destination is agreed. For a remote tracker, obtain approval for the map, child tickets, labels, and edges, then create issues first and wire their dependencies in a second pass.
5. **Run research in parallel.** For each research ticket, follow the installed `research` skill and use Luna xhigh research subagents. Store findings in the local ticket. For a remote tracker, prepare the findings and request approval before posting comments or changing ticket state. Do not create branches or commits unless the user asks.
6. Stop: charting is one session's work; it hand-resolves nothing.

### Work through the map

User invokes with a map (URL or number). A ticket is **optional**: without one, you pick the next decision, not the user.

1. Load the **map**: the low-res view, not every ticket body.
2. Choose the ticket. If the user named one, use it. Otherwise take the first frontier ticket in order. For local Markdown, mark it claimed before work. For a remote tracker, include assignment in the approved write batch before claiming it.
3. Resolve it. **Zoom as needed**: fetch the full body of related or closed tickets on demand and read the skills named in the map's Notes. If no specialized route is clear, apply `grilling` and `domain-modeling`.
4. Draft the resolution and its one-line map pointer. For local Markdown, record the answer and resolve the ticket. For a remote tracker, show the proposed comment, close action, and map edit, then apply them only after approval.
5. Add newly surfaced tickets and graduate fog that has become precise. Use create-then-wire for approved remote additions. When a ticket falls outside the destination, close or mark it superseded after approval and link it under **Out of scope**. Never delete tracker history.

The user may run unblocked tickets in parallel, so expect other sessions to be editing the tracker concurrently.
