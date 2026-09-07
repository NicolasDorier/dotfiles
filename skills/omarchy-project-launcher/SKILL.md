---
name: omarchy-project-launcher
description: Use when customizing or debugging the Omarchy project launcher, SUPER+ALT+SPACE Projects menu, project editor routing, project discovery, or recent-project ordering on this machine.
---

# Omarchy Project Launcher

Use this skill for changes involving the custom Projects menu. Read
[`architecture.md`](architecture.md) before editing anything.

## Sources Of Truth

Always edit the dotfiles sources, not packaged Omarchy files:

- Launcher: `~/dotfiles/bin/omarchy-project-launcher`
- Editor overrides: `~/dotfiles/config/omarchy/project-editors`
- Keybinding: `~/dotfiles/config/hypr/bindings.lua`
- Installation links: `~/dotfiles/setup.sh`

The corresponding files under `~/.local/bin` and `~/.config` are symlinks.
Never modify `/usr/share/omarchy/` for this feature.

## Common Changes

### Change A Project's Editor

Add or update a line in `config/omarchy/project-editors`:

```text
ProjectFolder=editor
```

The folder name must match an immediate child of `~/src`. Supported editor
values are `code`, `rider`, `pycharm`, and `dataspell`. Remove an override to
return that project to automatic inference.

### Add A Project

Normally no configuration change is required. Any new immediate directory
under `~/src` appears automatically, except `tmp`. Add an editor override only
when inference gives the wrong result.

### Add An Editor

Update all three launcher locations together:

1. The override parser's allowed editor values.
2. `editor_for` if the editor should be inferred.
3. The launch `case`, using `uwsm-app --` for the GUI command.

Do not use `eval` to parse configuration. Verify the executable with
`command -v` through the launcher's existing check.

### Change The Shortcut

Check current bindings first:

```bash
omarchy menu keybindings --print
```

When replacing an existing binding, keep an explicit `hl.unbind(...)` before
the new `o.bind(...)`. After editing Hyprland configuration, always run:

```bash
hyprctl reload
hyprctl configerrors
```

### Reset Recent Ordering

The ordering history is runtime state, not dotfiles configuration. With user
approval, remove:

```text
${XDG_STATE_HOME:-$HOME/.local/state}/omarchy-project-launcher/recent
```

The next menu invocation starts alphabetically. Do not add this file to Git.

## Verification

Run these after launcher changes:

```bash
bash -n ~/dotfiles/bin/omarchy-project-launcher
shellcheck ~/dotfiles/bin/omarchy-project-launcher
~/dotfiles/bin/omarchy-project-launcher --print
```

Confirm that `--print` contains every expected direct child of `~/src`, omits
`tmp`, and reports the intended editor and launch target for representative
projects. A Rider project with exactly one root solution must report that
`.sln` or `.slnx` file as its target. The diagnostic mode must not open the
menu, launch an editor, or update recency.

After binding changes, also confirm:

```bash
omarchy menu keybindings --print
```

Do not launch a project merely to test routing unless the user asks, because
that opens an IDE and changes recent-project state.
