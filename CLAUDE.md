# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a personal `.github` repository for **eswat2** that holds shared GitHub Actions reusable workflows. There is no application code, build system, or test runner — the repo's only artifact is `.github/workflows/npm-publish-reusable.yml`.

## Workflow architecture

`npm-publish-reusable.yml` is a `workflow_call` workflow consumed by downstream Ionic/Stencil component repos (all under `~/github/ionic/`). The calling repos live at `eswat2/<repo>` and reference it via:

```yaml
uses: eswat2/.github/.github/workflows/npm-publish-reusable.yml@main
```

### Step order in the reusable workflow

1. Checkout → Setup Node (OIDC `id-token: write` required for provenance)
2. `corepack enable && corepack prepare pnpm@latest --activate` (pnpm via corepack, not a pinned version)
3. `pnpm install --frozen-lockfile`
4. `npm install -g npm@latest` (updates npm independently of Node setup)
5. Conditional `pnpm test`, `pnpm build`, `pnpm card` (controlled by boolean inputs)
6. `${{ inputs.publish-command }}` (defaults to `npm publish --access public --provenance`)

### Inputs

| Input | Default | Notes |
|---|---|---|
| `node-version` | `'22'` | Passed to `actions/setup-node@v4` |
| `run-tests` | `true` | Runs `pnpm test` |
| `run-build` | `true` | Runs `pnpm build` |
| `run-card` | `false` | Runs `pnpm card` (npx business card repos only) |
| `publish-command` | `npm publish --access public --provenance` | Full publish shell command |

## Active consumer repos

9 repos publish via this workflow (all tagged `v*.*.*`): `analog-clock-components`, `funnel-gfx-wc`, `proto-autos-wc`, `proto-icons-wc`, `proto-ikon-loader-wc` (published as `proto-ikon-loader`), `proto-ikons-wc`, `proto-logo-wc`, `proto-sudoku-wc`, `proto-tinker-wc`.

Local wrapper/demo repos (`wc-*`) do **not** publish via this workflow.

## Changing the workflow

Changes merged to `main` take effect immediately for all callers pinned to `@main`. There is no staging environment — test changes in a fork or a temporary branch reference (`@branch-name`) in a single consumer repo before merging.
