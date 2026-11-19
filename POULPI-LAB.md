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

A tag `pointer-shapes-v<upstream-date>-<upstream-sha8>` (for example `pointer-shapes-v20261114-e1eae81a`,
the date and short hash of the upstream commit the branch is based on) runs
`.github/workflows/poulpi-windows-release.yml`. It builds the Windows x86_64 portable zip, with the
same layout as upstream's `WezTerm-windows-*.zip`, and publishes a GitHub release with the zip and
its `.sha256`. `wezterm --version` reports upstream's version string for that base commit; the tag
carries the fork's identity. Binary names are upstream's (`wezterm.exe`, `wezterm-gui.exe`, ...).

Upstream's own workflows are disabled in this fork's Actions settings so they do not run here.

## Syncing with upstream

```sh
scripts/sync-upstream.sh          # check: try rebasing pointer-shapes on upstream main, report conflicts
scripts/sync-upstream.sh --push   # then push main (fast-forward only) and the rebased pointer-shapes
```

The script never forces `main` and stops on a conflict instead of resolving it. The
`poulpi_sync_check` workflow runs the check weekly and on demand. After a sync, tag the new base with
the name the script prints and push the tag to publish a release.
