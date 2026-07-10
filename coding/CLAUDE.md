# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

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

**Define success criteria. Loop until verified.**

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

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 5. Code Search & Investigation

- When referencing code, always include **file path** and **line number** (e.g., `src/main/java/Foo.java:42`) so I can jump to it in my IDE.

## 6. Stack & Build Tool

- Spring Boot 4+, Java 25+
- For new project Gradle Kotlin DSL is defaulted, fallback to Maven only when explicitly requested

## 7. Java

### 7.1 JPA / Database
- JPA entities should mitigate the N+1 problem (e.g. `@EntityGraph`, `JOIN FETCH`, batch size)
- Prefer JPQL for `@Query`; flag when `nativeQuery` is genuinely needed
- NoSQL (e.g. MongoDB): prefer both explicit `@Query` and derived query methods

### 7.2 Lombok
- Use Lombok wherever possible; default to `@RequiredArgsConstructor` (constructor injection)
- Be aware of `.equals`/`.hashCode` contract pitfalls and N+1 interactions (e.g. lazy-loaded fields in `@Data`)

## 8. Utility Scripts

- Utility/helper scripts: README block at top (what, how, I/O). Keep short.
- Code must be maintainable and easy to enhance with new features.
- Config-driven: Python / JS → `CONFIG` dict/object at top (below README block). Shell → `CONFIG_*` prefixed vars.
- Destructive safety: Scripts that override/update/delete existing files must show affected file paths and prompt for user confirmation before proceeding.
- Fuzzy input: When scripts accept file/folder names as arguments, support fuzzy/substring matching so users don't need to type the full name. If multiple matches, prompt user to pick from a numbered list.

## 9. Communication

- Unclear → QnA me extensively for clarification of unclear points you have.
- Commit: After any coding task that involves modifying files, end your response with `COMMIT MSG: <msg>` so I can copy-paste it. Skip for general queries.
- Challenge me: Bad code can cause data loss, security incidents, and production outages that cost real money. As a middle developer I may lack full perspective. If my request could lead to bugs, data corruption, or security holes — stop me, explain the risk, and propose a safer approach. Push back hard. Don't follow blindly — ever.
