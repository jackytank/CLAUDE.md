## General Conversation Preferences (Apply for when I ask academic or general purpose questions or in general)
- Correct my grammar at the top of every response: `[CORRECTED GRAMMAR]: <corrected>` or `[GRAMMAR OK]`
- When I said I want to see code examples, I mean real-world production code examples, not some textbook
  code like simple class Box, class Rectangle, unless I explicitly tell you I want to see simple examples.
- I would be happy to be pointed out as wrong because I think that the best way to learn
- I'm an advocate of vibe learning. At the end of the topic I'm researching, I would like to see the next
  topics I should research or know about, or interesting facts I don't know about or add (including but not
  limited to) a tip, a small note, a deep insight, an expert opinion, a dark side of the industry,
  an industry secret...

## Coding Preferences (Apply when you involve doing CRUD to code)
- Specifically for new project I prefer using Spring Boot 4+ and Java 25+ and for Spring build tool defaulting to using Gradle Kotlin DSL unless I told you to use Maven (pom.xml)
- I prefer JPA entities that somewhat solved the N+1 problem
- I prefer using @Lombok whenever possible, but be aware of issues like the above N+1 problem or
  .equals and .hashCode contract issues
- I prefer constructor injection using Lombok's @RequiredArgsConstructor
- If SQL db for JPA @Query query, I prefer a transferable query like JPQL as much as possible, only in
  cases that I should use nativeQuery, please suggest/ask me me when that case arises
- When you implement specifically a coding task or a software spec and while you do, keep a running implementation-notes.html file (or markdown) with decisions you had to make weren't in the spec, things you had to change, tradeoffs you had to make or anything else I should know.
- If NoSQL db (for example mongodb) prefers both explicit @Query and derived query methods
- When you finish specifically a coding task excluding general querying/asking that don't involve you CRUD code then add at the end of your response: `[COMMIT MSG]: <your generated conventional commit message>`
- When I ask you to generate/enhance/update utility scripts (maybe .py, .sh) then at the top of the script I want to have readme that document the how-to, example commands,... but small and concise that go straight to the point so in the future we can update/read it quick.
I prefer config-driven development like below the readme section we will have config section maybe a single variable named `CONFIG` if .py or .js if .sh then multiple variables prefixed with `CONFIG_`. I prefer the utility script to be easy to maintain meaning you and I can update/enhance it later without restructure/refactor it too much. I prefer the script when doing some sensitive operations like override/update/delete file I want it to ask/confirm user