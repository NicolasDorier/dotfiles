# Architecture

## Purpose

`SUPER+ALT+SPACE` replaces Omarchy's default direct Apps-menu binding with a
searchable Projects menu. The normal Apps menu remains available through the
root menu on `SUPER+SPACE`.

The feature is deliberately implemented as user configuration. It uses
Omarchy's public menu command and Hyprland override mechanism without changing
anything under `/usr/share/omarchy/`.

## Components

| Component | Dotfiles source | Runtime location |
| --- | --- | --- |
| Launcher | `bin/omarchy-project-launcher` | `~/.local/bin/omarchy-project-launcher` |
| Editor overrides | `config/omarchy/project-editors` | `~/.config/omarchy/project-editors` |
| Hyprland binding | `config/hypr/bindings.lua` | `~/.config/hypr/bindings.lua` |
| Recent ordering | Not tracked | `${XDG_STATE_HOME:-$HOME/.local/state}/omarchy-project-launcher/recent` |
| Symlink installation | `setup.sh` | Not applicable |

`setup.sh` links the launcher indirectly by linking the entire `bin` directory.
It links `project-editors` and this skill explicitly. The entire Hyprland
configuration directory is also linked.

## Execution Flow

1. Hyprland executes `omarchy-project-launcher` from the custom binding.
2. The launcher reads editor overrides as non-executable `folder=editor` data.
3. It discovers immediate, non-hidden child directories of `~/src`.
4. It excludes `tmp` and names containing tabs or newlines.
5. It restores valid entries from the recent-state file, then appends new or
   unseen projects alphabetically.
6. `omarchy menu select Projects ...` presents the searchable native Omarchy
   selection interface.
7. The selected project is moved to the front of the state file using an
   atomic temporary-file replacement.
8. The launcher resolves the project directory or unique Rider solution as the
   launch target.
9. The selected editor is launched through `uwsm-app`.

Cancelling the menu exits successfully without changing state or opening an
editor.

## Editor Resolution

Resolution is deterministic and stops at the first match:

1. An explicit entry in `project-editors`.
2. A root-level `*.sln` or `*.slnx` file selects Rider.
3. A root-level `pyproject.toml`, `setup.py`, or `requirements.txt` selects
   PyCharm.
4. A root-level `*.ipynb` selects DataSpell.
5. Everything else selects VS Code.

Because Python markers precede notebook detection, a project containing both
uses PyCharm unless explicitly overridden.

Current intentional overrides:

| Project | Editor | Reason |
| --- | --- | --- |
| `PythonLearning` | PyCharm | It lacks a recognized root Python marker. |
| `StudyNotes` | DataSpell | Its intended IDE cannot be inferred reliably. |
| `lightning` | VS Code | Its `pyproject.toml` is part of a mixed Rust/Python project. |

## Launch Behavior

- VS Code receives `--new-window` explicitly.
- Rider receives the root `.sln` or `.slnx` file when exactly one exists. With
  zero or multiple root solutions, it receives the project directory so Rider
  can resolve the ambiguous case.
- PyCharm and DataSpell receive the project directory. All three JetBrains
  editors use their `confirmOpenNewProject2=0` preference; in the installed
  builds, value `0` means open in a new window.
- `uwsm-app --` places each GUI launch in the expected desktop application
  scope.

## State And Portability

Only configuration and code belong in dotfiles. Recent ordering reflects
local usage and must remain machine-local. Stale state entries are discarded
when the launcher reads them, and newly discovered projects are appended in
case-insensitive alphabetical order.

The launcher assumes Bash, Omarchy's `omarchy menu select`, `uwsm-app`, and
standard commands available on this Omarchy installation. `--print` is the
side-effect-free diagnostic interface for agents and scripts.
