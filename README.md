# Personal CLAUDE.md

```
.
├── coding/
│   └── CLAUDE.md    # Global CLAUDE.md — picked up automatically when coding
├── academic/
│   └── CLAUDE.md    # Chatbox-only — paste into a chat for academic/conversation mode
├── LICENSE
├── README.md
└── sync-claude.sh   # Copies a subfolder's CLAUDE.md to ~/.claude/CLAUDE.md
```

## Sync to ~/.claude/CLAUDE.md

```bash
./sync-claude.sh            # defaults to coding/, prompts on override
./sync-claude.sh cod        # fuzzy/substring folder matching
./sync-claude.sh --dry-run  # show what would be copied, without writing
```
