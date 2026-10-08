# ts-skills-library

A Claude Code skill library: reusable TypeScript-backed skills, installed by symlinking into `~/.claude/skills/`.

## Install

```bash
git clone <your-fork-url> ~/.claude/skills-src/ts-skills-library
cd ~/.claude/skills-src/ts-skills-library
./setup.sh
```

This builds any `packages/*` binaries that declare a `build:binary` script, then creates `~/.claude/skills/<skill-name>/` for every skill under `skills/*/*/SKILL.md` — a real directory with `SKILL.md` symlinked back to this repo, so edits here show up immediately without re-running setup.

## Check without installing

```bash
./setup.sh --check
```

## Uninstall

```bash
./uninstall.sh          # removes only the skills this repo installed
./uninstall.sh --purge  # also deletes this repo
```

## Upgrade

```bash
git pull && ./setup.sh
```

Idempotent — safe to re-run any time.

## Skills

| Category | Skill | Description |
| --- | --- | --- |
| engineering | `create-skill` | Scaffold a new skill, following `.claude/reference/skill-authoring.md`. |
| engineering | `commit` | Create a Conventional Commits-formatted commit for all uncommitted changes. |
| engineering | `text-stats` | Word count / reading-time stats for a text file, via the compiled `text-stats` binary. |

## Adding a new skill

Ask Claude to use the `create-skill` skill, or do it by hand — see `.claude/reference/skill-authoring.md`. Code always goes under `packages/<name>-shared` / `packages/<name>-binary`, never inside the skill folder.

## Gating a consuming repo on this library

Copy `hooks/check-skills.sh` into a consuming repo's `.claude/hooks/`, set `LIBRARY_NAME` inside it to whatever you installed this library as, and wire it up in that repo's `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Skill", "hooks": [{ "type": "command", "command": ".claude/hooks/check-skills.sh" }] }
    ]
  }
}
```

Skill use in that repo then fails loudly if this library isn't installed, instead of silently behaving as if it were.

## Development

```bash
bun install
bun run lint          # eslint, per packages/* member
bun run format:check  # prettier --check over packages/**/*.ts
bun run typecheck      # tsc --noEmit, per packages/* member
bun test               # bun's test runner, repo-wide
pre-commit install     # one-time
pre-commit run --all-files
```
