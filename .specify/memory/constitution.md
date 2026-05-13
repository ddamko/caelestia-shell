<!--
SYNC IMPACT REPORT
==================
Version change: (placeholder template, unratified) → 1.0.0
Bump rationale: MAJOR. Initial ratification of a real constitution for this fork.
  All previous content was unfilled template placeholders; replacing them with
  concrete, enforceable principles constitutes the foundational governance
  document and therefore warrants 1.0.0 rather than a 0.x pre-release.

Modified principles:
  - [PRINCIPLE_1_NAME]              → I. QML-First, C++ for Native Bridges
  - [PRINCIPLE_2_NAME]              → II. Lint, Format & Convention Compliance (NON-NEGOTIABLE)
  - [PRINCIPLE_3_NAME]              → III. User Configuration Is the Stable Contract
  - [PRINCIPLE_4_NAME]              → IV. Upstream Synchronization Discipline
  - [PRINCIPLE_5_NAME]              → V. Build & Distribution Reproducibility

Added sections:
  - Technology Stack & Distribution Constraints (was [SECTION_2_NAME])
  - Development Workflow & Quality Gates (was [SECTION_3_NAME])

Removed sections: none (all template slots filled).

Templates requiring updates:
  - .specify/templates/plan-template.md       ✅ compatible (generic Constitution Check
    placeholder still applies; gates now resolve to the five principles below)
  - .specify/templates/spec-template.md       ✅ no changes needed (no constitution coupling)
  - .specify/templates/tasks-template.md      ✅ compatible (treats tests as OPTIONAL,
    which matches Principle II's "tests where they pay off" stance)
  - .specify/templates/checklist-template.md  ✅ not reviewed in depth; no constitution
    coupling expected — flag for follow-up if a future amendment changes that

Runtime guidance docs reviewed:
  - README.md                                 ✅ describes user-facing config, build,
    install — aligned with Principles III and V
  - .github/CONTRIBUTING.md                   ✅ commit convention, formatting, no-AI-slop,
    test-your-PRs rules — folded into Principle II and Development Workflow
  - CLAUDE.md                                 ✅ minimal SPECKIT pointer; no changes needed

Deferred items / TODOs:
  - TODO(RATIFICATION_DATE): The date below (2026-05-13) is the fork-owner's initial
    adoption date for this constitution, not the original upstream project's founding
    date. If a different anchor date is preferred, amend with a PATCH bump.
-->

# caelestia-shell (fork) Constitution

This constitution governs the `ddamko/caelestia-shell` fork of
`caelestia-dots/shell`. It does not override upstream's `CONTRIBUTING.md`; it
adds fork-specific commitments and clarifies what "good" looks like in this
repository.

## Core Principles

### I. QML-First, C++ for Native Bridges

UI behavior, layout, animation, and composition MUST be expressed in QML
(declarative bindings, signals, and property animations) inside
`components/`, `modules/`, `services/`, and `utils/`. C++ inside
`plugin/src/Caelestia/` and `extras/` is reserved for capabilities QML cannot
practically provide: native Qt types exposed to the QML engine, audio
analysis, image analysis, calculator integration, HTTP, app database lookups,
toaster wiring, and similar OS- or Qt-level bridges. New C++ code MUST justify
why a QML/JS implementation is insufficient.

**Rationale**: Quickshell's strength is hot-reloadable, declarative QML.
Pushing business logic into C++ raises the contribution barrier for a
community "rice"-style project, slows iteration (rebuilds vs. file-watch
reload), and makes upstream merges harder.

### II. Lint, Format & Convention Compliance (NON-NEGOTIABLE)

Every commit on `main` MUST pass, with zero diagnostics:

- `qmlformat` (Qt 6) on every `.qml` file outside `build/`.
- `clang-format --Werror --dry-run` on every `.cpp` and `.hpp` under `plugin/`
  and `extras/`, using the repo's `.clang-format` (LLVM base, `IndentWidth: 4`,
  `ColumnLimit: 120`, `PointerAlignment: Left`).
- The CI build with `-DCMAKE_CXX_COMPILER=clazy -DCMAKE_CXX_FLAGS=-Werror`
  and the full warning set declared in `CMakeLists.txt` (`-Wall -Wextra
  -Wpedantic -Wshadow -Wconversion -Wold-style-cast -Wnull-dereference
  -Wdouble-promotion -Wformat=2 -Wfloat-equal -Woverloaded-virtual
  -Wsign-conversion -Wredundant-decls -Wswitch -Wunreachable-code`).
- `qmllint --import disable` against the generated build qmltypes.
- `python3 scripts/qml-lint-conventions.py` (import grouping, section
  ordering, blank-line separators).

Commits MUST follow the `module: change` convention from `CONTRIBUTING.md`.
PR descriptions MUST be descriptive and call out breaking changes or side
effects explicitly. AI-generated README/docs prose is prohibited per upstream
rules; do not work around this.

Automated tests are OPTIONAL for QML widget behavior but RECOMMENDED for any
C++ utility code in `plugin/` that has non-trivial logic (parsing, math,
state machines). When tests exist, they MUST run and pass before merge.

**Rationale**: This is the de facto rule already enforced by upstream CI and
the maintainer's review style. Codifying it removes ambiguity and prevents
"format-only" follow-up PRs.

### III. User Configuration Is the Stable Contract

The user-facing contract is `~/.config/caelestia/shell.json` (and per-monitor
overrides under `~/.config/caelestia/monitors/<screen>/shell.json`), plus the
`caelestia shell …` IPC surface enumerated by `caelestia shell -s`.

- New behavior MUST be opt-in via an additive key in `shell.json` with a
  default that preserves the prior user-visible behavior.
- Removing or renaming an existing `shell.json` key, IPC target, or IPC
  function is a breaking change and MUST be called out in the PR description
  and release notes.
- `~/.config/caelestia/shell-tokens.json` is explicitly NOT stable; changes
  to token names, defaults, or semantics do not require deprecation, but the
  README's warning to that effect MUST remain.
- The list of ignored per-monitor keys in `README.md` MUST stay accurate
  when options are added or moved.

**Rationale**: This shell is consumed straight from the AUR and Nix flake by
users who do not edit source. Silent default changes break their desktops.

### IV. Upstream Synchronization Discipline

This repository is a fork. Local changes MUST be structured so that periodic
merges or rebases from `upstream/main` (`caelestia-dots/shell`) stay
tractable.

- Cosmetic-only diffs against upstream files (whitespace, reordering imports
  that already pass the linter, renaming local variables) are prohibited.
- Fork-specific features SHOULD live in new files or clearly delimited
  blocks rather than being scattered across upstream files.
- Any deliberate divergence from upstream MUST be documented — at minimum in
  the commit message, and for substantive divergence in a fork-local
  `CHANGELOG.md` or `README` section.
- Before opening a non-trivial feature PR in the fork, the author SHOULD
  evaluate whether the change belongs upstream and, if so, propose it there
  first.

**Rationale**: Upstream is active (latest release `v1.6.2`, frequent
commits). A fork that drifts cosmetically becomes unmaintainable inside one
or two release cycles.

### V. Build & Distribution Reproducibility

The canonical build path is, and MUST remain:

```
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build
```

Constraints:

- CMake ≥ 3.19, Ninja, C++20 (`CMAKE_CXX_STANDARD 20`,
  `CMAKE_CXX_EXTENSIONS OFF`).
- Qt 6 (`qt6-base`, `qt6-declarative`) is the only supported Qt major
  version; do not introduce Qt 5 fallbacks.
- The Nix flake (`flake.nix`) and any AUR PKGBUILD referenced by the README
  MUST continue to build a runnable shell after every PR. Adding a new
  system dependency requires updating both packaging paths in the same PR
  (or documenting why one is intentionally deferred).
- `ENABLE_MODULES` (`extras;plugin;shell`) and the four install-dir cache
  variables (`INSTALL_LIBDIR`, `INSTALL_QMLDIR`, `INSTALL_QSCONFDIR`,
  `DISTRIBUTOR`) MUST remain configurable; do not hard-code paths that
  those variables previously controlled.

**Rationale**: Multiple downstream consumers (AUR users, NixOS users, manual
builders) rely on this exact contract. Breakage here is invisible to anyone
who only tests their local checkout.

## Technology Stack & Distribution Constraints

- **Runtime**: Quickshell (git, not the last tagged release) on Hyprland on
  Wayland. The shell is launched via `caelestia shell -d` or
  `qs -c caelestia`.
- **Languages**: QML / JavaScript (UI and services), C++20 (native Qt plugin
  and small helpers), Python 3 (lint tooling under `scripts/`), Fish (CI
  glue). No other languages SHOULD be introduced without a corresponding
  amendment.
- **Runtime system dependencies** (as enumerated in `README.md`):
  `caelestia-cli`, `ddcutil`, `brightnessctl`, `app2unit`, `libcava`,
  `networkmanager`, `lm-sensors`, `fish`, `aubio`, `libpipewire`, `glibc`,
  `qt6-declarative`, `gcc-libs`, `material-symbols`, `caskaydia-cove-nerd`,
  `swappy`, `libqalculate`, `bash`, `qt6-base`. Adding a new mandatory
  runtime dependency requires updating the README and both packaging paths
  in the same PR.
- **Build dependencies**: CMake, Ninja, a C++20 compiler, Qt 6 dev packages,
  Python 3 (for the QML convention linter), Fish (for CI scripts).
- **Configuration format**: JSON. Configuration schema changes follow
  Principle III.
- **Default crash report URL**: This fork redirects crash reports to its own
  issue tracker (`shell.qml`, `QS_CRASHREPORT_URL`). Do not regress that to
  upstream unintentionally.

## Development Workflow & Quality Gates

1. **Branching**: Feature work happens on topic branches; `main` reflects
   the fork's deployable state. Sync with `upstream/main` regularly
   (Principle IV).
2. **Commits**: `module: change` subject line (lowercase module, imperative
   verb). Most-impactful change goes in the subject; secondary changes in
   the body. Co-authored work uses `Co-Authored-By:` trailers.
3. **Local checks before pushing**:
   - `cmake -B build -G Ninja && cmake --build build`
   - `qmlformat -i $(find . -name '*.qml' -not -path './build/*')` (or
     check with `--check`)
   - `clang-format -i $(find plugin extras -name '*.cpp' -o -name '*.hpp')`
   - `python3 scripts/qml-lint-conventions.py`
   - Manual smoke test: launch the shell on a real Hyprland session and
     exercise the changed surface.
4. **CI gates** (`.github/workflows/`): `check-format.yml` (qmlformat +
   clang-format + qml-lint-conventions), `lint.yml` (clazy `-Werror` build
   + qmllint). Both MUST be green before merge.
5. **Review**: PRs need at least one approval from the fork owner.
   Reviewers verify principle compliance, not just code correctness. A
   "Complexity Tracking" entry in the plan (per `plan-template.md`) is
   REQUIRED for any deliberate principle deviation.
6. **Testing posture**: Tests are OPTIONAL. When written, they live
   alongside the code they exercise and run in CI. Visual/manual
   verification on a real Hyprland session is the primary acceptance bar
   for QML changes.

## Governance

This constitution supersedes ad-hoc decisions within this fork. It does NOT
override upstream's `CONTRIBUTING.md`; where the two overlap, upstream
governs the shared coding style and PR conventions and this document adds
fork-specific commitments.

- **Amendments**: Open a PR that edits `.specify/memory/constitution.md`,
  the Sync Impact Report at the top of that file, and any dependent
  template under `.specify/templates/`. The PR description MUST state the
  version bump (MAJOR / MINOR / PATCH) and justify it.
- **Versioning policy**:
  - MAJOR — backward-incompatible removal or redefinition of a principle or
    governance rule.
  - MINOR — new principle or section added, or materially expanded guidance
    that changes day-to-day behavior.
  - PATCH — clarifications, wording fixes, link updates, non-semantic
    refinements.
- **Compliance review**: At each upstream release sync (or at least
  quarterly), the fork owner reviews this constitution against the current
  state of the repo and either reaffirms it or amends.
- **Conflict resolution**: If a PR appears to violate a principle, the
  reviewer cites the principle by Roman numeral in the review. The author
  either fixes the PR, amends the constitution in the same or a prior PR
  (with version bump), or documents the violation under "Complexity
  Tracking" in the corresponding plan.

**Version**: 1.0.0 | **Ratified**: 2026-05-13 | **Last Amended**: 2026-05-13
