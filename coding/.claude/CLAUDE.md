# Coding Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

Tradeoff: These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what is confusing. Ask.

## 2. Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

Touch only what you must. Clean up only your own mess.

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

These guidelines are working if: fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 5. Code Search & Investigation

- Cite code as `<relative-path>:<line>:<column>` (forward slashes, from workspace root) so it opens in VSCode/IntelliJ. Column optional — use it only for exact symbols.
- Use code search (e.g. ripgrep) to verify existing code instead of guessing from memory.
- Read the actual file you're about to edit — never trust memory or autocomplete about what's there.
- After changing a symbol, find and update its other call sites. Fix the class of bug, not just the reported instance.
- If a search returns nothing, broaden it before concluding something doesn't exist.

## 6. Stack & Build Tool

- Spring Boot 4+, Java 25+
- For new projects, Gradle Kotlin DSL is the default.
- Fall back to Maven only when explicitly requested.

## 7. Java

### 7.1 JPA / Database

- JPA entities should mitigate the N+1 problem, for example using `@EntityGraph`, `JOIN FETCH`, or batch size settings.
- Prefer JPQL for `@Query`.
- Flag when `nativeQuery` is genuinely needed.
- NoSQL, for example MongoDB: prefer both explicit `@Query` and derived query methods.

### 7.2 Lombok

- Use Lombok wherever possible.
- Default to `@RequiredArgsConstructor` for constructor injection.
- Be aware of `.equals`/`.hashCode` contract pitfalls.
- Be aware of N+1 interactions, for example lazy-loaded fields included in `@Data`.

## 8. Utility Scripts

Scope: standalone/one-off utility, helper, maintenance, or automation scripts. Does not override application-level project rules unless explicitly requested.

### 8.1 General Script Rules
- Start with a short README header: what it does, how to run, expected inputs/outputs, side effects (especially file modification/deletion), and required external tools.
- Keep scripts short and maintainable. Put tunable settings in a `CONFIG` block near the top (`.py`/`.ts`: a `CONFIG` dict; shell: `CONFIG_*` variables).
- No hard-coded absolute paths unless asked.
- Destructive safety: scripts that overwrite/update/delete files must list the affected paths, require explicit confirmation, and prefer a `--dry-run` mode. Never silently auto-confirm.
- Fuzzy input: when accepting file/folder names, support fuzzy/substring matching — auto-proceed on a single match, prompt a numbered picker on several, error clearly if ambiguous and non-interactive.
- Don't commit generated logs, caches, virtual envs, or artifacts unless asked.

### 8.2 Python: use `uv` + PEP 723
- Default to `uv` for running and dependencies. Avoid `pip install`, manual venvs, `source .venv/bin/activate`, and global package installs for one-off scripts.
- Declare dependencies via PEP 723 inline metadata rather than `requirements.txt`:
```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "openpyxl",
# ]
# ///
```
- Run with `uv run script.py`; use `uv python install <ver>` to fetch a missing Python version. Prefer latest (bare package names). No third-party deps needed if stdlib suffices.

### 8.3 Logging
- Log to `<script_dir>/tool_logs/<script_stem>.log`, resolved from the script (not CWD); create the dir if needed.
- Append across runs with a session header (8-char session id + start time); write logs to the file (not stdout), concise errors to stderr, exit non-zero on failure.
- Log level `INFO` by default; support `--verbose`. Size rotation (5 MB x 5) or 14-day daily.
- Never log secrets, tokens, or credentials; redact before logging.

### 8.4 Shell Scripts
- Use `CONFIG_*` variables, quote paths, use `set -euo pipefail`, prefer explicit error messages, and require confirmation for destructive actions.

### 8.5 TypeScript Scripts
- Run with `bun`; prefer built-ins for simple tasks, avoid trivial package deps. If third-party deps are required, state the exact install and run command.

## 9. Communication

- Unclear → ask me extensive clarification questions for unclear points. Use the harness's built-in question tool to present choices or clarify ambiguity before implementing. If the harness has no question tool, ask in plain text. Known harnesses and their tools:
  - opencode → `question`
  - Claude Code → `AskUserQuestion`
- Commit: After any coding task that involves modifying files, end your response with:

```text
COMMIT MSG: <msg>
```

so I can copy-paste it. Skip for general queries.

- Challenge me: Bad code can cause data loss, security incidents, and production outages that cost real money. As a middle developer, I may lack full perspective. If my request could lead to bugs, data corruption, or security holes — stop me, explain the risk, and propose a safer approach. Push back hard. Don't follow blindly — ever.
  - Certain danger (data loss, corruption, security holes, outages, anything objectively harmful): refuse or hard-block; offer the safer alternative.
  - Contestable but not dangerous (worse design, over-engineering, a different call I'd make): flag it and explain briefly, but comply if I insist after hearing you. Don't die on a style hill.