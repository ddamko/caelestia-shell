<!--
Title: `module: change` (lowercase module, imperative verb)
Constitution: .specify/memory/constitution.md
-->

## Summary

<!-- One paragraph: what changes and why. -->

## Scope

- [ ] Fork-only change (lives in new files or clearly delimited blocks)
- [ ] Upstream-friendly change (should it be proposed to
  `caelestia-dots/shell` first? If not, justify below.)

## User-facing impact

- [ ] No user-facing change.
- [ ] New behavior is opt-in via an additive key in `shell.json`; defaults
  preserve prior behavior.
- [ ] Breaking change to `shell.json`, IPC, or CLI surface. Explain below
  and update `CHANGELOG.md`.

## Constitution checks (Principle II)

- [ ] `qmlformat` clean on all `.qml` outside `build/`.
- [ ] `clang-format --Werror --dry-run` clean on `plugin/` and `extras/`.
- [ ] `python3 scripts/qml-lint-conventions.py` clean.
- [ ] `cmake --build build` succeeds with the project warning set.
- [ ] CI workflows green (`check-format`, `lint`).

## Testing

<!-- How you verified the change. Include manual steps on a real Hyprland
session for QML changes. -->

## CHANGELOG.md

- [ ] Added an entry under `[Unreleased]` (or this PR is upstream-only and
  needs no fork-local note).

## Rationale for divergence (if upstream-friendly but kept in fork)

<!-- Skip if N/A. -->
