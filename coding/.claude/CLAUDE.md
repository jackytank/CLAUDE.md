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

- When referencing code, always include a clickable location in this exact format so VSCode and IntelliJ can open it directly:

```text
<relative-path-from-workspace-root>:<line>:<column>
```

for example:

```text
src/main/java/Foo.java:42:7
```

  - Use relative paths with forward slashes (never absolute paths or backslashes) so the link resolves in both IDEs.
  - Include the column when you want to point at an exact symbol, otherwise `path:line` is sufficient.

- Use code search tools (for example ripgrep) to find and verify existing code instead of guessing from memory.

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

Scope: standalone utility, helper, maintenance, automation, or one-off scripts. This section does not override application-level project rules unless explicitly requested.

### 8.1 General Script Rules

- Every script must start with a short README-style header block containing:
  - What the script does.
  - How to run it.
  - Expected inputs.
  - Expected outputs.
  - Side effects, especially file modification or deletion.
  - External tools required, if any.

- Keep scripts short, maintainable, and easy to enhance with new features.

- Put tunable settings in a config block immediately below the README header:
  - `.py` / `.ts`: use a `CONFIG` dict/object at the top.
  - Shell: use `CONFIG_*` prefixed variables.

- Do not hard-code absolute paths unless explicitly requested.

- Destructive safety:
  - Scripts that overwrite, update, delete, or mutate existing files or external state must show the affected file paths or resources.
  - They must prompt for user confirmation before proceeding.
  - They must not silently auto-confirm destructive actions.
  - Where practical, support a dry-run mode, for example `--dry-run`.

- Fuzzy input:
  - When scripts accept file or folder names as arguments, support fuzzy or substring matching so users do not need to type the full name.
  - If there is exactly one match, proceed.
  - If there are multiple matches, prompt the user to pick from a numbered list.
  - If the script is non-interactive and the input is ambiguous, stop with a clear error.

- Do not commit generated logs, caches, virtual environments, or artifacts unless explicitly requested.

### 8.2 Python Scripts: Use `uv`

For `.py` utility scripts, use `uv` as the default Python execution and dependency tool.

Do NOT use the following for utility scripts unless explicitly requested:

- `pip install`
- `python -m venv`
- `virtualenv`
- `source .venv/bin/activate`
- global Python package installation
- manual `requirements.txt` workflows for one-off scripts

If `uv` is not installed, propose installing it first:

```bash
# macOS / Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
# or: brew install uv
```

Windows:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

If a required Python version is missing, use:

```bash
uv python install 3.13
```

#### Dependencies via PEP 723 inline metadata

Use PEP 723 inline script metadata when a Python utility script needs third-party libraries:

```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "openpyxl",
# ]
# ///
```

Run it with `uv run script.py`.

If the script uses only the Python standard library, no `dependencies` block is required. Do not rely on globally installed Python packages.

Useful commands:

```bash
uv run --python 3.13 script.py          # specific Python version
uv run --refresh script.py              # force re-checking dependencies
uv run --refresh-package openpyxl       # refresh one package
uv run --with openpyxl script.py         # temporary dependency
uv add --script script.py openpyxl      # add a persistent dependency
```

Recommended version policy:

- Always prefer the latest version: use bare package names, for example `"openpyxl"`.
- Critical scripts should also include a clear README header, logging, and preferably a dry-run mode.
- Do not use a special `latest` keyword; Python dependency specifiers do not support it.
- If `uv add --script` inserts a version constraint but you want latest by default, simplify the dependency to the bare package name.

### 8.3 Python Script Logging

For every `.py` utility script, create a log directory next to the script:

```text
<script_dir>/tool_logs/
```

If the directory does not exist, create it. Default log file location:

```text
<script_dir>/tool_logs/<script_stem>.log
```

Example:

```text
tools/export_excel.py
tools/tool_logs/export_excel.log
```

Resolve the log path from the script file location, not from the current working directory.

Default logging behavior:

- Append to the same log file across runs.
- Do not overwrite previous logs or create a new log file per run.
- Use a session header to separate runs inside the same log file.
- Write logs to a file, not to stdout, when stdout is used for script output.
- Print concise errors to stderr.
- Use log levels instead of ad-hoc `print()` diagnostics.
- Default log level should be `INFO`.
- Support a verbose or debug mode if useful, for example `--verbose`.

Recommended session header and log line formats:

```text
==== 2026-07-31T14:05:12Z | session=a1b2c3d4 | script=export_excel.py | argv=['export_excel.py', 'input.xlsx'] ====
2026-07-31T14:05:12Z INFO [session=a1b2c3d4] Starting export
2026-07-31T14:05:14Z INFO [session=a1b2c3d4] Done: processed=3 output=out/report.csv elapsed=2.1s
```

Session rules:

- Generate a short session ID for each run, for example an 8-character UUID hex.
- Include the session ID in log lines or log context.
- Log the start time, script name, and input arguments.
- Log a final summary line on success; log exceptions and tracebacks on failure.
- Exit with a non-zero status code on failure.

Log rotation:

- Use size-based rotation by default to prevent unbounded log growth, for example rotate at 5 MB and keep 5 backup files.
- Daily rotation (keep 14 days of logs) is an acceptable alternative.
- If multiple scripts with the same base name could write to the same `tool_logs` directory, use the full script filename to avoid collisions, for example `tool_logs/export_excel.py.log`.

Do not log secrets, tokens, passwords, private keys, credentials, or sensitive file contents. Redact sensitive values before logging.

Use separate per-run log files (`tool_logs/<script_stem>/<timestamp>_<session>.log`) only when the script produces very large logs, requires a strict audit trail, concurrent runs must not interleave logs, or the user explicitly asks for per-run logs.

### 8.4 Shell Scripts

- Use `CONFIG_*` prefixed variables for configuration.
- Quote paths.
- Use strict mode where appropriate:

```bash
set -euo pipefail
```

- Prefer explicit error messages.
- Destructive shell scripts must list affected paths and require confirmation.

### 8.5 TypeScript Scripts

- Use `bun` as the runtime for `.ts` scripts.
- Use a `CONFIG` object near the top of the file.
- Prefer Node / Bun built-ins for simple tasks.
- Avoid adding package dependencies for trivial functionality unless requested.
- If third-party dependencies are required, state the exact install and run command clearly.

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