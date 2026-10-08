---
name: text-stats
description: Report word count, sentence count, and estimated reading time for a text file or pasted text. Use when asked for a word count, reading time estimate, or text statistics.
---

Report word count, sentence count, and estimated reading time (200 words/minute) for a piece of text.

Requires: the `text-stats` binary (`packages/text-stats-binary`, built on `packages/text-stats-shared`'s counting logic). `./setup.sh` compiles it to `packages/text-stats-binary/dist/text-stats` — if that file doesn't exist yet, run `(cd packages/text-stats-binary && bun run build:binary)` first, or fall back to `bun run packages/text-stats-binary/src/cli.ts` directly (works without a build step, just slower to start).

## Process

1. Get the text — a file path the user gave you, or text pasted directly into the conversation.
2. Run the binary with the text on stdin or a file path as the only argument:

   ```bash
   packages/text-stats-binary/dist/text-stats path/to/file.md
   # or, with pasted text on stdin:
   echo "some text" | packages/text-stats-binary/dist/text-stats
   ```

3. It prints JSON: `{"words": N, "sentences": N, "readingTimeMinutes": N}`. Report the numbers back in plain language, not raw JSON, unless the user asked for the JSON itself.
