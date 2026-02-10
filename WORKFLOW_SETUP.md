# Setting Up the Release Workflow

The release workflow is ready in `release-workflow.yml` but needs to be added to `.github/workflows/` on GitHub.

## Add via GitHub Web UI

1. Go to https://github.com/omniaura/mac-overflow
2. Create new file: `.github/workflows/release.yml`
3. Copy content from `release-workflow.yml`
4. Commit to main

## How It Works

Push commits with conventional format:
- `feat:` triggers minor release (0.1.0 → 0.2.0)
- `fix:` triggers patch release (0.1.0 → 0.1.1)
- `chore:` no release

## First Release

Once workflow is added, just push a feat commit and it builds automatically!

Then users can install:
```bash
brew tap omniaura/tap https://github.com/omniaura/mac-overflow
brew install --cask mac-overflow
```
