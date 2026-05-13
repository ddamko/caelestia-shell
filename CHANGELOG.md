# Changelog

This file tracks **fork-local** changes in `ddamko/caelestia-shell` relative
to upstream `caelestia-dots/shell`. Upstream changes pulled in via merge are
not enumerated here; they are visible through `git log upstream/main..main`.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows upstream tags; fork-only releases (if any) use a
`+fork.N` suffix.

## [Unreleased]

### Added

- Spec-kit scaffolding under `.specify/` (templates, scripts, git extension,
  workflow registry).
- Claude skill bundle under `.claude/skills/speckit-*`.
- Top-level `CLAUDE.md` pointer.
- Fork constitution at `.specify/memory/constitution.md` (v1.0.0), with five
  core principles, Technology Stack & Distribution Constraints,
  Development Workflow & Quality Gates, and Governance sections. See the
  Sync Impact Report embedded at the top of that file.
- `CHANGELOG.md` (this file).
- `.github/pull_request_template.md` to enforce constitution checks at PR
  time.
- `README.fork.md` explaining fork purpose, sync cadence, and scope.

### Changed

- None.

### Removed

- None.

### Upstream sync

- Base: `caelestia-dots/shell@2ca4ad4a` (matches upstream `main` at fork
  initialization).
