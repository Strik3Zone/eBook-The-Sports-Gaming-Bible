# 📋 Changelog Quick Reference

## What's the Changelog?

The changelog automatically tracks all repository activity daily, including:
- Commits and code changes
- Issues opened and closed
- Pull requests created and merged
- File modifications

## Where to Find It

- **Main Changelog**: [CHANGELOG.md](../CHANGELOG.md)
- **Documentation**: [CHANGELOG_GUIDE.md](./CHANGELOG_GUIDE.md)
- **Table of Contents**: Listed under "Quick Links"

## How It Updates

### Automatic (Default)
- Runs **daily at 00:00 UTC**
- No action required from you
- Changes are committed automatically

### Manual Trigger (via GitHub)
1. Go to **Actions** tab
2. Select **Daily Changelog Update**
3. Click **Run workflow**

### Manual Trigger (locally)
```bash
# Run from repository root
./.github/scripts/update-changelog.sh

# Or for a specific date
./.github/scripts/update-changelog.sh 2026-01-20
```

## Understanding the Format

Each entry shows:
- **Date** - When the activity occurred
- **Commits** - Code changes with short descriptions
- **Issues** - New and resolved issues with links
- **Pull Requests** - Opened and merged PRs with links
- **Files** - Number of files modified

### Icons Used
- 🔄 Commits
- 📋 Issues
- 🎯 Merged PRs
- 🚀 New PRs
- 📁 File activity
- ✨ New features
- 🐛 Bug fixes
- 📝 Documentation

## For GitBook Users

The changelog integrates seamlessly with GitBook:
1. It's already configured in `.gitbook.yaml`
2. Listed in the table of contents
3. Uses GitBook-compatible markdown
4. Includes proper navigation links

## Need More Info?

See the full [Changelog Guide](./CHANGELOG_GUIDE.md) for:
- Customization options
- Troubleshooting
- Advanced features
- Integration details

---

*Part of The Sports Gaming Bible automated documentation system*
