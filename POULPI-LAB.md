# Poulpi-Lab fork of WezTerm

This is an unofficial fork of [wezterm/wezterm](https://github.com/wezterm/wezterm), maintained by
Poulpi-Lab. It exists for one reason: to ship a Windows build of WezTerm that supports mouse pointer
shapes (OSC 22, the kitty pointer-shapes protocol), so terminal applications can show a hand over
links and buttons, an I-beam over text and resize arrows over splitters.

WezTerm itself, its license (`LICENSE.md`) and its `README.md` are upstream's and unchanged.
Report WezTerm bugs upstream unless they come from the change below.

## What it carries

| Branch | Content |
|---|---|
| `main` | A mirror of upstream `main`, fast-forwarded only, never force-pushed. |
| `pointer-shapes` (default) | Upstream `main` plus the commits of upstream PR [wezterm/wezterm#8092](https://github.com/wezterm/wezterm/pull/8092) "feat: add support for Kitty Pointer Shapes Protocol" by NSPC911, rebased with their authorship kept, plus this file, `scripts/sync-upstream.sh` and the `poulpi-*` workflows. |

Once #8092 is merged upstream, this fork has no reason to exist and will be archived.

## Releases

Releases have their own number, so they never look like an upstream version: tags
`pointer-shapes-r1`, `pointer-shapes-r2`, ... A tag runs `.github/workflows/poulpi-windows-release.yml`,
which builds the Windows x86_64 portable zip (same layout as upstream's `WezTerm-windows-*.zip`) and
publishes a GitHub release with the zip and its `.sha256`. The release notes give the upstream
version it corresponds to (the upstream commit and date, and the latest upstream stable release
before it) and list the changes this fork adds on top. `wezterm --version` reports upstream's
version string for that base commit. Binary names are upstream's (`wezterm.exe`, `wezterm-gui.exe`, ...).

Upstream's own workflows are disabled in this fork's Actions settings so they do not run here.

## Syncing with upstream

```sh
scripts/sync-upstream.sh          # check: try rebasing pointer-shapes on upstream main, report conflicts
scripts/sync-upstream.sh --push   # then push main (fast-forward only) and the rebased pointer-shapes
```

The script never forces `main` and stops on a conflict instead of resolving it. The
`poulpi_sync_check` workflow runs the check weekly and on demand. After a sync, push the next
`pointer-shapes-r<N>` tag the script prints to publish a release.
