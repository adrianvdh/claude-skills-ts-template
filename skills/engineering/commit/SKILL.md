---
name: commit
description: Create a Conventional Commits-formatted commit for all uncommitted changes. Lowercase subject, no em-dashes, no Co-Authored-By trailers. Use for commit my changes, write a commit message, git commit.
---

Create a new commit for all uncommitted changes.

1. Run `git status && git diff HEAD && git status --porcelain` to see what files are uncommitted.
2. Add the untracked and changed files.
3. Write an atomic commit message using **Conventional Commits** format:
   - Format: `type(scope): lowercase subject`
   - Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `ci`
   - Scope is optional but preferred when a clear scope exists (e.g. `api`, `ui`, `docs`, `ci`, `config`)
   - Subject must be lowercase, no trailing period
   - No em-dashes, no Co-Authored-By trailers
   - Body (if needed) should be lowercase, descriptive, no em-dashes
4. Do NOT add `Co-Authored-By` lines.
