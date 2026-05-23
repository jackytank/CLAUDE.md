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

## 5. Stack & Build Tool

- Spring Boot 4+, Java 25+
- Gradle Kotlin DSL (default); fallback to Maven only when explicitly requested

## 6. JPA / Database

- JPA entities should mitigate the N+1 problem (e.g. `@EntityGraph`, `JOIN FETCH`, batch size)
- Prefer JPQL for `@Query`; flag when `nativeQuery` is genuinely needed
- NoSQL (e.g. MongoDB): prefer both explicit `@Query` and derived query methods

## 7. Lombok

- Use Lombok wherever possible; default to `@RequiredArgsConstructor` (constructor injection)
- Be aware of `.equals`/`.hashCode` contract pitfalls and N+1 interactions (e.g. lazy-loaded fields in `@Data`)

## 8. Process

- During non-trivial implementation tasks, maintain a running `implementation-notes.md` capturing decisions, tradeoffs, changes from spec, and anything worth recording.
- After completing a coding task or task that involves modifying files in current repo (not general Q&A), append: `[COMMIT MSG]: <conventional commit message>`

## 9. Utility Scripts

- Include a concise README at the top of every script documenting how-to, examples, and commands.
- Prefer config-driven design:
  - Python / JS: a single `CONFIG` dict/object
  - Shell: multiple `CONFIG_*` variables
- Scripts should be easy to maintain and enhance without major refactoring.
- Sensitive operations (override, update, delete) the script must ask/confirm user before proceeding.
