## Coding Preferences

### Stack & Build Tool
- Spring Boot 4+, Java 25+
- Gradle Kotlin DSL (default); fallback to Maven only when explicitly requested

### JPA / Database
- JPA entities should mitigate the N+1 problem (e.g. `@EntityGraph`, `JOIN FETCH`, batch size)
- Prefer JPQL for `@Query`; flag when `nativeQuery` is genuinely needed
- NoSQL (e.g. MongoDB): prefer both explicit `@Query` and derived query methods

### Lombok
- Use Lombok wherever possible; default to `@RequiredArgsConstructor` (constructor injection)
- Be aware of `.equals`/`.hashCode` contract pitfalls and N+1 interactions (e.g. lazy-loaded fields in `@Data`)

### Process
- During non-trivial implementation tasks, maintain a running `implementation-notes.md` capturing decisions, tradeoffs, changes from spec, and anything worth recording.
- After completing a coding task or task that involve modifying files in current repo (not general Q&A), append: `[COMMIT MSG]: <conventional commit message>`

### Utility Scripts
- Include a concise README at the top of every script documenting how-to, examples, and commands.
- Prefer config-driven design:
  - Python / JS: a single `CONFIG` dict/object
  - Shell: multiple `CONFIG_*` variables
- Scripts should be easy to maintain and enhance without major refactoring.
- Sensitive operations (override, update, delete) the script must ask/confirm user before proceeding.
