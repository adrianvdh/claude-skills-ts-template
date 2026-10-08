# Skill Authoring

Authoritative reference for writing skills in this repo. Read this before creating or editing any `skills/<category>/<skill-name>/SKILL.md`. `CLAUDE.md` carries the quick-rules summary; this doc is the full rule set.

---

## 1. Naming & layout

- Skill names are kebab-case — a single noun- or verb-phrase (`create-pr`, `plan-feature`). The folder name IS the skill name.
- `SKILL.md` sits at `skills/<category>/<skill-name>/SKILL.md` — exactly one file, no siblings. Categories are a repo-only organizational layer (see §6); registration is flat.
- Archived or superseded variants go under `legacy/`, one level deeper than `SKILL.md`, so the install glob (`skills/*/*/SKILL.md`) never loads them. Archives are reference-only — never edit them to change live behavior.

```text
✅ skills/engineering/commit/SKILL.md
✅ skills/engineering/plan-feature/legacy/old-plan-feature.md   (archive, not loaded)
❌ skills/engineering/commit/template.md                        (no siblings — code goes in packages/)
❌ skills/engineering/Commit/SKILL.md                            (not kebab-case)
```

---

## 2. Frontmatter

Exactly two fields, both required, nothing else. Enforced by `scripts/validate-skill-frontmatter.sh` (pre-commit).

- `name:` — matches the folder name exactly.
- `description:` — ONE line, unquoted, under 1024 characters. This is the loader's matching surface: pack it with the trigger phrases a user would actually say. A vague description means the skill never fires.
- No `argument-hint:` — skills are model-invoked, not slash-only.

```yaml
# ✅
---
name: commit
description: Create a Conventional Commits-formatted commit for all uncommitted changes. Use for commit my changes, write a commit message, git commit.
---

# ❌ quoted, multi-line, extra fields
---
name: commit
description: >
    "Commits things."
argument-hint: <message>
---
```

---

## 3. Prose style — no max line width

- **Never hard-wrap prose at a column.** One line per paragraph and one line per bullet, however long. Markdown renders soft-wrapped lines identically, and hard-wrapped lines add diff noise and break exact-match editing. `MD013` (line-length) is disabled deliberately in `.markdownlint-cli2.jsonc`.
- The only sanctioned intra-paragraph newlines are a hard break (two trailing spaces — rare, deliberate) and the contents of fenced code blocks.
- Code fences and tables are exempt: break lines inside them wherever the content demands.
- Enforced by `scripts/check-md-wrap.sh` (pre-commit) on `SKILL.md` files, the root docs, and this reference directory.

---

## 4. Body conventions

- No `$ARGUMENTS` placeholder anywhere in the body. Write descriptive prose instead: "the path supplied by the user". Document expected arguments in a dedicated section when the skill takes them.
- Cross-skill references use the slash name (`/commit`, `/create-pr`) — never relative file paths between skill folders.
- Skills that wrap an MCP, external tool, or a `packages/` command name the dependency up front, before the process starts: `Requires: gh CLI (authenticated)`, `Requires: the text-stats binary (packages/text-stats-binary)`.
- Skills that wrap a binary state the stdout contract they rely on.
- Embed the facts the skill needs at runtime directly in the body rather than instructing the model to go read an external manifest — the skill must work without network or the source repo present.

---

## 5. Safety rules

- Skills that mutate external state — git remotes (push, PR creation, repo creation), issue trackers, databases, cloud resources — **MUST confirm with the user before acting**. Local, easily-reverted file edits don't need confirmation.
- When the wrapped tool offers a dry-run or preview mode, gate the destructive step behind it and show the user the output before applying.
- Never force-push, never `--force` a refusal on the user's behalf, never auto-delete — archive or back up instead. State these limits in the skill body so the executing agent inherits them.

---

## 6. Category and audience

- Two independent axes. **Category** is the folder the skill lives in (`skills/<category>/<skill-name>/`) — add new categories freely as the library grows. **Audience** (optional) is a column you can add to `CLAUDE.md`'s catalog table if it's useful to distinguish planning-time vs. build-time skills.
- Neither axis restricts anything. Categories are dropped at install time — registration is flat, so a category never appears in a skill's installed name. The loader scans all of `~/.claude/skills/*/SKILL.md` regardless of what category it came from.

---

## 7. Registration, install, and code location

- `./setup.sh` registers each skill as a real directory at `~/.claude/skills/<name>/` with `SKILL.md` symlinked back into this repo. Never a directory symlink — Claude Code's loader would auto-prefix nested skills as `<parent-dir-name>-<name>`.
- **Code never lives inside a skill folder.** A skill folder holds exactly one `SKILL.md`. Anything that runs lives in a repo-level package under `packages/`:
  - `packages/<name>-shared/` — a pure library, no CLI, for logic more than one package needs.
  - `packages/<name>-binary/` — depends on the matching `-shared` package via `workspace:*`, declares a `build:binary` script. `setup.sh` discovers any `packages/*/package.json` declaring `build:binary`, runs `bun install` once at the workspace root, then `bun run build:binary` in each — producing a compiled binary the skill's `SKILL.md` documents calling directly.
- Both tiers are bun workspace members (`workspaces: ["skills/*/*", "packages/*", "tooling/*"]` in the root `package.json`) and share the linting/formatting/type-checking config in `tooling/*` (see `CLAUDE.md`).

---

## 8. Cross-references

- [`CLAUDE.md`](../../CLAUDE.md) — skill catalog, repo layout, quick authoring rules, tooling conventions.
- [`README.md`](../../README.md) — install, upgrade, per-engagement gating.
- `scripts/validate-skill-frontmatter.sh` — frontmatter enforcement (§2).
- `scripts/check-md-wrap.sh` — hard-wrap enforcement (§3).
