---
name: ai-notes
description: Save durable Markdown notes in the user's AI notes directory. Use whenever the user says "Save to AI notes", "save in AI notes", or "add this to AI notes".
---

# AI Notes

Save notes under `~/Obsidian/AINotes`.

When triggered:

- Inspect existing notes and follow their naming and formatting conventions.
- Create or update a Markdown file with a descriptive name unless the user
  provides one.
- Make the note self-contained and useful outside the current conversation.
- Preserve relevant explanations, commands, scripts, warnings, links, and
  verified outcomes.
- Exclude credentials, secrets, transient progress, and conversational filler.
- Report the resulting absolute file path.
