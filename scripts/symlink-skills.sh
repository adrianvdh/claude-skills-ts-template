#!/usr/bin/env bash
# scripts/symlink-skills.sh
#
# Sourced by setup.sh / uninstall.sh. Installs a skill as a REAL directory at
# $SKILLS_DIR/<name>/ with its SKILL.md symlinked back to this repo — never a
# symlinked directory. Claude Code's loader auto-prefixes a skill directory
# that is itself a symlink (it would surface as "<parent>-<name>" instead of
# "<name>"); symlinking just the file avoids that.
#
# Category folders (skills/<category>/<name>/) are a repo-only organizational
# layer — they're dropped at install time, registration is flat.
#
# Expects REPO_DIR and SKILLS_DIR to already be set by the caller.

set -euo pipefail

REPO_MARKER="$(basename "$REPO_DIR")"

_is_ours() {
    local target_dir="$1"
    local marker_file="$target_dir/SKILL.md"
    [[ -L "$marker_file" ]] || return 1
    local resolved
    resolved="$(cd "$(dirname "$marker_file")" && readlink "$marker_file")" || return 1
    case "$resolved" in
        /*"/$REPO_MARKER/"*) return 0 ;;
        *) return 1 ;;
    esac
}

register_skill() {
    local name="$1" src_dir="$2" force="${3:-false}"
    local target_dir="$SKILLS_DIR/$name"

    if [[ -e "$target_dir" && ! -d "$target_dir" ]]; then
        echo "✗ $name: $target_dir exists and is not a directory, skipping" >&2
        return 1
    fi

    if [[ -d "$target_dir" ]] && ! _is_ours "$target_dir" && [[ "$force" != "true" ]]; then
        echo "✗ $name: $target_dir already exists and isn't owned by this repo (use --force to overwrite)" >&2
        return 1
    fi

    mkdir -p "$target_dir"
    ln -sf "$src_dir/SKILL.md" "$target_dir/SKILL.md"
    echo "✓ $name -> $target_dir"
}

unregister_skill() {
    local name="$1"
    local target_dir="$SKILLS_DIR/$name"

    [[ -d "$target_dir" ]] || return 0

    if ! _is_ours "$target_dir"; then
        echo "- $name: not owned by this repo, leaving in place" >&2
        return 0
    fi

    rm -rf "$target_dir"
    echo "✓ removed $name"
}
