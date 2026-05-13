# Fork notes — `ddamko/caelestia-shell`

This document describes what is fork-specific about this repository. For
product documentation (installation, configuration, IPC, etc.) read
`README.md` — the upstream README applies unchanged.

## Relationship to upstream

- Upstream: `caelestia-dots/shell`.
- This fork tracks `upstream/main` and is normally fast-forward-equal or a
  small number of commits ahead.
- Bug reports for behavior that exists in upstream should go to upstream,
  not here.

## Why this fork exists

- To carry personal, opinionated changes that are not in scope for
  upstream.
- To experiment with changes before proposing them upstream.
- To pin a known-good revision for the fork owner's own machines if
  upstream regresses.

## What belongs in this fork

- Opt-in, additive `shell.json` keys that default to upstream behavior.
- Personal widgets or status surfaces unlikely to be accepted upstream.
- Experimental refactors that need to bake before being proposed upstream.

## What does *not* belong here

- Cosmetic diffs against upstream files (whitespace, import reordering
  that already passes the linter, local-only renames). See Principle IV
  in `.specify/memory/constitution.md`.
- Bug fixes that apply equally to upstream. Send those upstream first.
- New mandatory runtime dependencies, unless both the AUR PKGBUILD and
  `flake.nix` are updated in the same PR.

## Sync cadence

- `git fetch upstream` on a regular cadence (weekly is reasonable).
- Merge `upstream/main` into `main` when fetch surfaces new commits.
- Record substantive syncs in `CHANGELOG.md` under `Upstream sync`.

## Governance

- Constitution: `.specify/memory/constitution.md` (currently v1.0.0).
- Contribution conventions inherited from upstream:
  `.github/CONTRIBUTING.md` (commit format `module: change`, no AI-generated
  docs prose, test PRs, descriptive PR descriptions).
- PR checks codified in `.github/pull_request_template.md`.
- Issues are currently disabled on the fork; bug reports go to upstream.

## Local development quick reference

The canonical build path matches upstream:

```sh
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build
```

Before pushing:

```sh
# QML
qmlformat -i $(find . -name '*.qml' -not -path './build/*')
python3 scripts/qml-lint-conventions.py

# C++
clang-format -i $(find plugin extras -name '*.cpp' -o -name '*.hpp')

# Build with project warning set
cmake --build build
```

CI runs `qmlformat` parity, `clang-format` parity, the convention linter,
a `clazy -Werror` build, and `qmllint`. All must pass before merge.
