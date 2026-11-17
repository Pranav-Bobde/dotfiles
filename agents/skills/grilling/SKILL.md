---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user until you reach a shared understanding. Map the topic as a **design tree**: every decision branches into the decisions that depend on it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask now without guessing at answers you have not heard yet. Ask the usable frontier in one round, number each question, and give your recommended answer. If the frontier is too large for a useful response, group it into coherent rounds without dropping branches. Then wait for the user's answers.

Format a round like so:

```
**Q1. <question title>**

<question body, which may include mutually exclusive choices>

Recommended: <your recommended answer and why>

---

**Q2. <question title>**

<question body>

Recommended: <your recommended answer and why>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding facts is your job, never the user's. Inspect the workspace and available sources before asking. For external or substantial research, follow the installed `research` skill, which defaults research subagents to Luna xhigh. Parallelize independent lookups when that improves quality. If the user asks for Claude, invoke it only through `cc-skill`.

Do not block the whole interview on one lookup. A running investigation is an unsettled prerequisite, so only its dependent questions wait. Ask the rest of the frontier. The decisions remain the user's: put each material choice to them and wait.

The session is done when the frontier is empty: every material branch has been visited and no decision-changing assumption remains hidden. Summarize the agreed decisions, unresolved questions, and explicit non-goals. Do not implement or make external changes until the user confirms the shared understanding or separately asks for execution.
