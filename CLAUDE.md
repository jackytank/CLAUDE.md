## Conversation Preferences
- Correct my grammar at the top of every response: `[CORRECTED GRAMMAR]: <corrected>` or `[GRAMMAR OK]`
- When I said I want to see code examples, I mean real-world production code examples, not some textbook
  code like simple class Box, class Rectangle, unless I explicitly tell you I want to see simple examples.
- I would be happy to be pointed out as wrong because I think that the best way to learn
- I'm an advocate of vibe learning. At the end of the topic I'm researching, I would like to see the next
  topics I should research or know about, or interesting facts I don't know about or add (including but not
  limited to) a tip, a small note, a deep insight, an expert opinion, a dark side of the industry,
  an industry secret...

## Commit Message Convention

- When the LLM finishes a coding task (creating/modifying/deleting code files such as `.java`, `.ts`, `.yml`, `.xml`, `.json`, `.sql`, `.kt`, `.properties`, etc.), append `[COMMIT MSG]: <conventional commit message>` at the very end of the response.
- If the user query is general knowledge (e.g. "explain computer science", "who is Elon Musk", "what is REST API") — i.e. no code was written, modified, or deleted — then omit `[COMMIT MSG]` entirely.

## Document Generation

Only activate document generation rules when the user's prompt contains one of the configured trigger keywords below.

### Trigger Keywords

| Keyword | Behavior |
|---------|----------|
| `DOCGENHTML` | Generate a single `.html` file using Vue 3 (jsDelivr) + Tailwind (`cdn.tailwindcss.com`). Use CDN libs (lodash, dayjs, marked.js, chart.js, highlight.js, etc.) when they add value. |
| `DOCGENPDF` | *(placeholder — reserved for future PDF generation)* |

### Shared Rules (only applied when a trigger keyword is matched — ignored otherwise)

- Always include a copy button at the bottom:
  - "Copy as Prompt" → learning/explanation content
  - "Copy as JSON" → structured data/config
  - "Copy as YAML" → config/infrastructure content
  + Copies the page's main text content to clipboard using 3-layer defense:
  + L1: `navigator.clipboard.writeText()` with `.catch()` (HTTPS/non-sandboxed)
  + L2: `document.execCommand('copy')` via temp off-screen `<textarea>` (sandboxed iframes, Claude viewer, CodePen)
  + L3: overlay modal with pre-selected text for manual `Ctrl+A → Ctrl+C`
  + Never use `navigator.clipboard` alone — silently fails in iframes.

## Coding Style
- I am using Spring Boot 4+ and Java 25+
- I prefer Spring build tool defaulting to using Gradle Kotlin DSL unless I told you to use Maven (pom.xml)
- I prefer JPA entities that somewhat solved the N+1 problem
- I prefer using @Lombok whenever possible, but be aware of issues like the above N+1 problem or
  .equals and .hashCode contract issues
- I prefer constructor injection using Lombok's @RequiredArgsConstructor
- If SQL db for JPA @Query query, I prefer a transferable query like JPQL as much as possible, only in
  cases that I should use nativeQuery, please suggest to me when that case arises
- If NoSQL db prefers both explicit @Query and derived query methods