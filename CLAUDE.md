# CLAUDE.md

This repo is a Claude Code skill library, not a regular application. `skills/*/*/SKILL.md` is loaded directly by Claude Code's skill discovery — the frontmatter rules below are load-bearing, not style preferences. Full authoring rules: `.claude/reference/skill-authoring.md`.

## Install model

`setup.sh` creates a **real directory** at `~/.claude/skills/<name>/` and symlinks `SKILL.md` into it — it never symlinks the directory itself. This is deliberate: Claude Code's loader auto-prefixes a skill directory that is itself a symlink (it would show up as `<parent-dir-name>-<name>` instead of `<name>`).

Ownership of an installed skill is tracked by checking whether its `SKILL.md` symlink resolves back into this repo (matched against this repo's own directory name, computed at runtime — renaming the repo never breaks this). `uninstall.sh` only ever removes entries it owns, never a foreign skill that happens to share a name.

## Code location

**Never put code inside a skill folder.** A skill folder holds exactly one `SKILL.md`. Anything that runs lives in a repo-level package:

- `packages/<name>-shared/` — a pure library, no CLI, for logic more than one package needs.
- `packages/<name>-binary/` — depends on the matching `-shared` package via `workspace:*`, declares a `build:binary` script (see `packages/text-stats-binary/scripts/build-binary.sh`).

`setup.sh` discovers any `packages/*/package.json` declaring `build:binary`, runs `bun install` once at the workspace root, then `bun run build:binary` in each — the skill's `SKILL.md` then documents calling the resulting binary directly.

## Linting, formatting, type-checking

Config lives in `tooling/*` as its own internal workspace packages (`tooling-eslint-config`, `tooling-prettier-config`, `tooling-tsconfig`), consumed by every `packages/*` member via `workspace:*`:

- **ESLint** (flat config, `typescript-eslint` + a house style — arrow functions only, no `no-shadow`/`no-param-reassign`/etc.) — each package's own `eslint.config.js` requires `tooling-eslint-config` and points it at that package's `tsconfig.json`.
- **Prettier** — `tabWidth: 4`, double quotes, `printWidth: 120`. One root `prettier.config.js` requiring `tooling-prettier-config` covers everything under `packages/`.
- **TypeScript** — strict (`noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`). Each package's `tsconfig.json` extends `tooling-tsconfig/base.json`.
- **Tests** — `bun test`, co-located `*.test.ts` next to source. No Vitest/Jest — bun's runner is already native here.

Run `bun run lint` / `bun run typecheck` (both loop over `packages/*` via `scripts/run-in-packages.sh`), `bun run format:check`, `bun test` — all wired into `pre-commit` too (see `.pre-commit-config.yaml`), scoped to `packages/`.

## Frontmatter rules

Enforced by `scripts/validate-skill-frontmatter.sh`, wired into `.pre-commit-config.yaml`:

- Folder name and `name:` must match exactly, kebab-case.
- `description:` — one unquoted line, under 1024 characters, written as "what + when" so a model can decide to invoke the skill from the description alone.
- No `argument-hint:` — skills are model-invoked, not slash-command-only.
- No `$ARGUMENTS` anywhere in the body — write descriptive prose instead.
- Cross-skill references use the slash name (`/other-skill`), never a relative path.
- Markdown prose is never hard-wrapped — one line per paragraph/bullet (`scripts/check-md-wrap.sh`).

## Adding a new skill

Use the `create-skill` skill, or by hand following `.claude/reference/skill-authoring.md`: pick a category folder, write `skills/<category>/<name>/SKILL.md`, add any code under `packages/` (never under `skills/`), run `./setup.sh`.

## Repo layout

```text
.
├── setup.sh / uninstall.sh          # install/uninstall into ~/.claude/skills/, build packages/* binaries
├── hooks/check-skills.sh            # optional gate for consuming repos (see README)
├── scripts/                         # installer internals, frontmatter/prose validators, run-in-packages.sh
├── .claude/reference/               # skill-authoring.md — full authoring rule set
├── tooling/                         # shared eslint/prettier/tsconfig, consumed by packages/*
├── packages/                        # all code — <name>-shared / <name>-binary, bun workspace members
└── skills/<category>/<name>/SKILL.md   # one skill per folder, docs only
```
