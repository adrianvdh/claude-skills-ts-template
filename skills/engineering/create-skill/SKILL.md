---
name: create-skill
description: Scaffold a new Claude Code skill in this repo, following .claude/reference/skill-authoring.md — picks a category, writes SKILL.md, and sets up a packages/ package if code is needed. Use when asked to create a new skill, add a skill, scaffold a skill, or turn a process/script into a skill.
---

Scaffold a new skill in `skills/<category>/<name>/` following this repo's conventions. Full rules: `.claude/reference/skill-authoring.md`.

## Process

1. Pick a kebab-case name and a category folder under `skills/` (an existing one, e.g. `engineering`, or a new one if nothing fits).
2. Create `skills/<category>/<name>/SKILL.md`:
   - `name:` matches the folder name exactly.
   - `description:` — one unquoted line, under 1024 characters, packed with the "what + when" trigger phrases a model would need to decide to invoke this skill.
   - No `argument-hint:` field, and no positional-argument placeholder token anywhere in the body (see `.claude/reference/skill-authoring.md` §4) — write descriptive prose instead.
   - Never hard-wrap prose — one line per paragraph/bullet, however long.
3. **If the skill needs to run code**, it does not go in `skills/<category>/<name>/`. Create `packages/<name>-shared/` (a pure library, if more than one package will need the logic) and/or `packages/<name>-binary/` (depends on `-shared` via `workspace:*`, declares a `build:binary` script) — mirror the shape of `packages/text-stats-shared` + `packages/text-stats-binary`, including an `eslint.config.js` requiring `tooling-eslint-config` and a `tsconfig.json` extending `tooling-tsconfig/base.json`. Then have the skill's `SKILL.md` declare `Requires: the <name> binary (packages/<name>-binary)` and document how/when to invoke it.
4. Run `scripts/validate-skill-frontmatter.sh skills/<category>/<name>/SKILL.md` and `scripts/check-md-wrap.sh skills/<category>/<name>/SKILL.md` to confirm it passes before committing.
5. Run `./setup.sh` to build any new binary and symlink the skill into `~/.claude/skills/`.
