## Where we left off

### Repo purpose
Personal CLAUDE.md config — preferences for AI assistants split across two concerns.

### Current structure
```
.
├── coding/CLAUDE.md      # Global CLAUDE.md (Spring Boot, JPA, Lombok, scripts)
├── academic/CLAUDE.md    # Chatbox paste-in (grammar, vibe learning, feedback)
├── issue.md              # Draft GitHub issue for these changes
├── pr.md                 # Draft PR for these changes
├── README.md             # Folder map
└── LICENSE               # MIT
```

### What just happened
- Split monolithic `CLAUDE.md` into `academic/` and `coding/` folders
- Formatted both files with clear topic sections
- Updated `README.md` as a folder map; `coding/CLAUDE.md` = global default
- Deleted `AGENTS.md` (redundant)
- Drafted `issue.md` and `pr.md` for GitHub (uncommitted)

### Git status (uncommitted)
- Staged: deleted AGENTS.md, deleted CLAUDE.md, modified README, new academic/CLAUDE.md, new coding/CLAUDE.md
- Untracked: issue.md, pr.md

### Next steps (if any)
- Decide whether to commit `issue.md`/`pr.md` or keep as local drafts
- Commit and push the staged changes
