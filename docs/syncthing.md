# Syncthing

Syncthing keeps the Hermes receipt archive synchronized with this workstation.

## Topology

| Device | Folder | Mode |
| --- | --- | --- |
| Hermes | `/home/hermes/workspace/receipts` | Send and receive |
| Workstation | `~/Alfred/Receipts` | Send and receive |

Both devices run Syncthing as an enabled systemd user service. Connections use
Syncthing's authenticated, encrypted device protocol. The management interface
is bound to localhost and is available at <http://127.0.0.1:8384> on the
workstation.

The folder ID is `hermes-receipts`. Staggered file versioning retains replaced
or deleted files for 90 days on each receiving device. `.receipt.lock` is
excluded in `.stignore` because it is local transaction-lock state, not archive
content.

## Workstation Setup

Run the dotfiles setup script. It installs the Arch `syncthing` package and
enables the package-provided user service.

```bash
./setup.sh
```

The device identity and synchronization database are intentionally not kept in
Git. On a new workstation, open <http://127.0.0.1:8384>, pair it with Hermes,
and add the folder offered by Hermes at `~/Alfred/Receipts`.

Configure the new folder as follows:

- Folder ID: `hermes-receipts`
- Folder type: Send & Receive
- File versioning: Staggered File Versioning
- Maximum age: `7776000` seconds (90 days)
- Ignore pattern: `.receipt.lock`

## Runtime State

Do not commit or copy these files between machines:

- `~/.local/state/syncthing/`
- `~/.config/syncthing/` on older installations
- Syncthing certificates, private keys, `config.xml`, indexes, or API keys
- `~/Alfred/Receipts/` and its `.stversions/` directory

Back up the receipt content separately. Syncthing provides replication and file
history, but it is not an offline backup because deletions synchronize.

## Operations

```bash
systemctl --user status syncthing.service
systemctl --user restart syncthing.service
journalctl --user -u syncthing.service
```

Hermes uses the same user service. Its GUI remains bound to its own localhost;
use an SSH tunnel only when administration is necessary:

```bash
ssh -L 8385:127.0.0.1:8384 hermes@170.75.162.15
```

Then open <http://127.0.0.1:8385>.
