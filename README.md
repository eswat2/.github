# eswat2/.github

Personal reusable GitHub Workflows and shared configuration for my open-source projects.

## Available Reusable Workflows

### npm-publish-reusable.yml

A reusable workflow for consistently building, testing, and publishing npm packages across my repositories.

**Usage example** (in any repo's `.github/workflows/publish.yml`):

```yaml
name: Publish package

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  publish:
    permissions:
      contents: read
      id-token: write
    uses: eswat2/.github/.github/workflows/npm-publish-reusable.yml@main
    with:
      node-version: '22'
      run-tests: true
      run-build: true
      run-card: false           # Set to true if your package includes an npx business card script
      publish-command: 'npm publish --access public --provenance'
```

#### Inputs

| Input              | Type    | Default     | Description |
|--------------------|---------|-------------|-------------|
| `node-version`     | string  | `'22'`      | Node.js version to use |
| `run-tests`        | boolean | `true`      | Run `pnpm test` before publishing |
| `run-build`        | boolean | `true`      | Run `pnpm build` before publishing |
| `run-card`         | boolean | `false`     | Run `pnpm card` (for npx business card generation) |
| `publish-command`  | string  | `'npm publish --access public --provenance'` | The final publish command |

#### Features
- Uses **pnpm** with frozen lockfile for reproducible installs
- Supports **provenance** and OIDC for secure publishing
- Configurable test/build/card steps
- Works with both `main` and `master` default branches

#### Usage notes

See [Ionic Component Publish — Actions Usage Summary](docs/ionic-publish-actions-summary.md) for real-world timing data, active repo list, and Pro plan minute budget analysis.

## How to Use

1. Reference the workflow using `uses: eswat2/.github/.github/workflows/...@main`
2. Pass inputs as needed for your project
3. Keep your calling workflow minimal (just triggers + permissions + call)
