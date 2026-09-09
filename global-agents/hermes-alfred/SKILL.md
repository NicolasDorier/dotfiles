---
name: hermes-alfred
description: Configure, administer, troubleshoot, or update the Hermes Agent family assistant "Alfred" on its VPS. Use ONLY for requests about Alfred, @alfred_a5624_bot, or this deployed Hermes instance.
---

# Hermes Alfred

Manage the deployed family assistant carefully and carry requested work through
inspection, implementation, and verification.

## Deployment Context

Key locations and access:

- Host: `alfred.nicolas-dorier.com`
- Hermes service account: `hermes`
- Connect with `ssh hermes@alfred.nicolas-dorier.com`
- Interactive working directory: `/home/hermes/workspace`
- Managed installation: `/home/hermes/.hermes/hermes-agent`
- Runtime configuration: `/home/hermes/.hermes/config.yaml`
- Secrets: `/home/hermes/.hermes/.env`
- Personality and safety policy: `/home/hermes/.hermes/SOUL.md`
- User service: `hermes-gateway.service`

The last recorded installed version is Hermes Agent `0.21.1`. Treat that as a
hint, not a guarantee; inspect the live version when version details matter.

`alfred.nicolas-dorier.com` is a locally resolved DNS name in /etc/hosts.

## Operating Rules

- Inspect the relevant live files, effective configuration, service state, and
  installed version before changing anything.
  is perfectly current.
- Verify exact configuration keys and behavior against the installed source or
  documentation for the live Hermes version. Do not guess from newer online
  documentation.
- Make the smallest change that satisfies the request. Preserve unrelated live
  settings and user changes.
- Keep all runtime state on the VPS under the dedicated `hermes` account. Work
  from `~/workspace`, not from the managed source tree, unless source inspection
  is necessary.
- The `hermes` account has no sudo access. Never grant it sudo, store a sudo
  password, weaken SSH hardening, or expose an application port.
- Host-level maintenance belongs to the separate `ubuntu` administrator
  account. Use it only when the task explicitly requires host administration.
- Do not create persistent backups or snapshots unless the user requests one.
  Temporary local files used for a safe edit must be removed after validation.
- Do not install community skills unless explicitly requested.
- Do not modify the managed Hermes source as a substitute for supported
  configuration unless the user explicitly requests maintaining a source
  customization.

## Secrets

- Never print, copy, summarize, or commit the contents of `.env`, API keys,
  Telegram tokens, SSH private keys, session cookies, or other credentials.
- Check secret presence without revealing values. Avoid commands that dump the
  full environment or `.env`.
- If a new secret is required, ask the user to enter it through an appropriate
  interactive or provider-controlled flow rather than placing it in a command,
  patch, note, or chat response.
- Preserve `.env` mode `0600` and the ownership of every edited runtime file.

## Policy Invariants

Unless the user explicitly requests a policy change, preserve these controls:

- Only the two recorded numeric Telegram user IDs are authorized, and only the
  recorded family supergroup is allowed.
- Unauthorized DMs are silently ignored; pairing and allow-all access stay off.
- Group sessions remain shared, Telegram DM topics remain disabled, and busy
  input remains queued.
- The owner remains the sole administrator. Regular-user command restrictions
  remain different between DMs and the family group.
- Telegram gets only clarification, cron management, memory, session search,
  skills, vision, and web capabilities.
- DM-sensitive facts never enter shared memory or group responses.
- The dashboard and OpenAI-compatible API server remain disabled.
- The gateway runs unprivileged as a systemd user service and Telegram remains
  outbound-only.

## Change Workflow

1. Read the relevant deployment-note sections and identify the invariants the
   request touches.
2. Inspect the live version and only the relevant remote state. Redact sensitive
   output before reporting it.
3. Inspect the installed Hermes implementation or matching version docs for any
   uncertain key, command, toolset expansion, or restart behavior.
4. Explain and ask before proceeding only when the request is ambiguous,
   destructive, affects credentials, weakens a security boundary, or conflicts
   with the deployment policy. Otherwise implement directly.
5. Apply a minimal remote edit while preserving file ownership and permissions.
6. Use Hermes commands to validate effective behavior where possible. Restart
   the gateway only when the changed setting requires it.
7. Verify service health and inspect focused recent logs for regressions without
   exposing message content or secrets.
8. Report the files/settings changed, verification performed, and any remaining
   live test that requires Telegram or provider interaction.

Useful inspection and verification commands include:

```bash
hermes --version
hermes doctor
hermes tools
hermes sessions list
hermes gateway status
systemctl --user status hermes-gateway.service
journalctl --user -u hermes-gateway.service
```

Prefer bounded, focused log queries over an unbounded `journalctl -f` during
automated work. A healthy service is not sufficient proof of policy: when tool
access changes, verify the effective Telegram and cron tool lists as well.

## Documentation

- Repository: <https://github.com/NousResearch/hermes-agent>
- Documentation: <https://hermes-agent.nousresearch.com/docs/>
