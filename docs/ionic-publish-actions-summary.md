# Ionic Component Publish — Actions Usage Summary

*Recorded: June 14, 2026*

## Overview

On June 14, 2026, all active Ionic/Stencil component packages were published to npm using the reusable workflow in this repo ([`npm-publish-reusable.yml`](../.github/workflows/npm-publish-reusable.yml)). Each repo triggers on a `v*.*.*` tag push, runs `pnpm install`, test, build, and `npm publish --access public --provenance`.

**Total billed Actions time for the initial sweep: ~26 minutes** across 11 repositories.

## Initial Publish (11 repos)

| Repository | Visibility |
|---|---|
| `analog-clock-components` | Public |
| `funnel-gfx-wc` | Private |
| `proto-autos-wc` | Private |
| `proto-daisy-db` | Private |
| `proto-daisy-ui` | Private |
| `proto-icons-wc` | Private |
| `proto-ikon-loader-wc` | — |
| `proto-ikons-wc` | Private |
| `proto-logo-wc` | Private |
| `proto-sudoku-wc` | Private |
| `proto-tinker-wc` | Public |

> **Note:** The ikon loader package is published as `proto-ikon-loader` on GitHub/npm (not `proto-ikon-loader-wc`).

**Average per repo:** ~2.4 minutes (26 min ÷ 11 repos). Most of that time is pnpm install and build; the publish step itself is fast.

## Current Active Set (9 repos)

The daisy-related packages were removed from local development to focus on the web component libraries:

**Removed locally:**
- `proto-daisy-db`
- `proto-daisy-ui`
- `wc-daisy-ui`

**Active publish targets:**

1. `analog-clock-components`
2. `funnel-gfx-wc`
3. `proto-autos-wc`
4. `proto-icons-wc`
5. `proto-ikon-loader` (local folder: `proto-ikon-loader-wc`)
6. `proto-ikons-wc`
7. `proto-logo-wc`
8. `proto-sudoku-wc`
9. `proto-tinker-wc`

**Local `wc-*` wrapper/demo repos** (not part of the publish sweep):

`wc-alt`, `wc-analog`, `wc-autos`, `wc-funnel`, `wc-logo`, `wc-proofs`, `wc-sudoku`, `wc-tinker`, `wc-xplor`

All live under `~/github/ionic/`.

## Actions Minutes — Budget Analysis

GitHub account: **eswat2** (Pro plan)

| Plan | Included private-repo minutes/month |
|---|---|
| Free | 2,000 |
| **Pro** | **3,000** |

Public repositories consume **unlimited** Actions minutes at no cost. Only private-repo minutes count against the monthly quota.

### Estimated monthly usage

| Scenario | Per sweep | Daily (×30) |
|---|---|---|
| All 9 repos private | ~21 min | ~630 min |
| 6 private + 3 public | ~14 min | ~420 min |

With Pro (3,000 min/month), either scenario leaves **~2,400+ minutes** for PR checks, other repos, and incidental CI — even with a daily full publish habit.

A single full sweep uses roughly **1% of the monthly Pro allowance**.

## Takeaways

- ~2.4 min/repo is normal for the current reusable workflow on `ubuntu-latest`.
- Publishing all active components once a day is comfortably within the Pro plan budget.
- Removing the daisy repos trims the sweep by ~5 minutes and narrows focus to the `*-wc` component libraries.
- Deleting repos locally does not unpublish npm packages or remove GitHub remotes — it only clears local working copies.

## Optimization levers (if needed later)

These are not necessary today but are available if minutes ever become a concern:

- Set `run-tests: false` on publish-only tag workflows
- Set `run-build: false` for packages that don't require a build step
- Add pnpm store caching to the reusable workflow
- Make more repos public (unlimited Actions minutes)