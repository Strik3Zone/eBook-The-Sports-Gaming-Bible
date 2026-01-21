# 📚 Changelog System Documentation

## Overview

The Sports Gaming Bible repository features an automated changelog system that tracks and documents all repository activities in a clean, GitBook-style format.

## Features

### Automated Daily Updates

The changelog automatically updates every day at **00:00 UTC** and includes:

- 🔄 **Recent Commits** - All commits from the last 24 hours
- 📋 **Issues Resolved** - Closed issues with links
- 🎯 **Pull Requests Merged** - Successfully merged PRs
- 📝 **New Issues** - Recently opened issues
- 🚀 **New Pull Requests** - Recently opened PRs
- 📁 **File Activity** - Statistics on modified files

### GitBook-Style Format

The changelog follows GitBook conventions:
- Clean markdown formatting
- Emoji icons for quick visual scanning
- Chronological organization (newest first)
- Links to relevant issues and PRs
- Consistent structure across entries

## How It Works

### Automatic Updates (GitHub Actions)

1. **Schedule**: Runs daily via cron at 00:00 UTC
2. **Collection**: Gathers git commits, issues, and PR data
3. **Generation**: Creates formatted changelog entry
4. **Update**: Inserts new entry into CHANGELOG.md
5. **Commit**: Automatically commits and pushes changes

### Manual Trigger

You can manually trigger the workflow:

1. Go to the **Actions** tab in GitHub
2. Select **Daily Changelog Update** workflow
3. Click **Run workflow**
4. Choose the branch and click **Run workflow**

### Local Manual Update

Use the provided script for local updates:

```bash
# Update with today's date
./.github/scripts/update-changelog.sh

# Update with specific date
./.github/scripts/update-changelog.sh 2026-01-20
```

**Prerequisites**:
- Git installed and configured
- GitHub CLI (`gh`) for issue/PR data (optional)

## File Structure

```
.
├── CHANGELOG.md                          # The changelog file
├── .github/
│   ├── workflows/
│   │   └── daily-changelog.yml          # GitHub Actions workflow
│   └── scripts/
│       └── update-changelog.sh          # Manual update script
└── docs/
    └── CHANGELOG_GUIDE.md               # This file
```

## Changelog Format

### Entry Structure

Each daily entry follows this format:

```markdown
### YYYY-MM-DD

#### 🔄 Recent Commits
- Commit message (hash)
- Another commit (hash)

#### 📋 Issues Resolved
- ✅ Closed: #123 - Issue title

#### 🎯 Pull Requests Merged
- 🔀 Merged: #456 - PR title

#### 📝 New Issues
- 🆕 Opened: #789 - Issue title

#### 🚀 New Pull Requests
- 🔄 Opened: #012 - PR title

#### 📁 Files Activity
- Modified/Added: X file(s)

---
```

### Legend

The changelog uses emoji icons for quick identification:

| Icon | Meaning |
|------|---------|
| ✨ | Added - New features or content |
| 🔧 | Changed - Changes to existing functionality |
| 🐛 | Fixed - Bug fixes |
| 🗑️ | Removed - Removed features or files |
| 🔒 | Security - Security improvements |
| 📝 | Documentation - Documentation updates |
| 🎨 | Style - Formatting and style changes |
| ⚡ | Performance - Performance improvements |
| 🧪 | Testing - Test additions or changes |

## Customization

### Modify Update Frequency

Edit `.github/workflows/daily-changelog.yml`:

```yaml
on:
  schedule:
    # Change this cron expression
    - cron: '0 0 * * *'  # Daily at midnight
    # Examples:
    # - cron: '0 */6 * * *'  # Every 6 hours
    # - cron: '0 0 * * 1'    # Weekly on Monday
```

### Customize Entry Format

Edit the script section in the workflow or the manual script to change:
- Header text
- Emoji icons
- Information collected
- Formatting style

### Add Custom Sections

In `.github/workflows/daily-changelog.yml`, add custom sections:

```bash
# Example: Add repository stats
echo "#### 📊 Repository Stats" >> "$TEMP_FILE"
CONTRIBUTORS=$(git log --since="24 hours ago" --format='%aN' | sort -u | wc -l)
echo "- Active contributors: $CONTRIBUTORS" >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"
```

## Best Practices

### For Contributors

1. **Write Clear Commit Messages**: They appear directly in the changelog
2. **Use Conventional Commits**: Helps categorize changes
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation
   - `chore:` for maintenance

3. **Link Issues in PRs**: Automatically shows relationships
4. **Review Changelog**: Check daily updates for accuracy

### For Maintainers

1. **Monitor Workflow**: Check Actions tab for failures
2. **Adjust Frequency**: Modify if updates are too frequent/sparse
3. **Curate Manually**: Add important notes to the Unreleased section
4. **Archive Old Entries**: Move older entries to separate files if needed

## Troubleshooting

### Workflow Not Running

- Check if Actions are enabled in repository settings
- Verify the workflow file has correct syntax
- Ensure `GITHUB_TOKEN` has proper permissions

### Missing Data

- **No Issues/PRs**: Requires GitHub CLI and proper permissions
- **No Commits**: Check if branch has recent activity
- **Empty Entries**: Normal if no activity in 24 hours

### Permission Errors

Ensure the workflow has these permissions:
```yaml
permissions:
  contents: write
  pull-requests: read
  issues: read
```

### Script Fails Locally

- Ensure script is executable: `chmod +x .github/scripts/update-changelog.sh`
- Check git is properly configured
- Install GitHub CLI for issue/PR data: `gh auth login`

## Integration with GitBook

To integrate with GitBook:

1. **Add to SUMMARY.md**:
```markdown
# Summary

* [Introduction](README.md)
* [Changelog](CHANGELOG.md)
* [Other Sections](...)
```

2. **Configure .gitbook.yaml**:
```yaml
root: ./

structure:
  readme: README.md
  summary: SUMMARY.md

redirects:
  changelog: CHANGELOG.md
```

3. **Enable in GitBook Settings**:
   - Navigate to your GitBook space
   - Go to Integrations
   - Connect your GitHub repository
   - GitBook will automatically sync CHANGELOG.md

## Advanced Features

### Filtering by Labels

Customize the workflow to filter issues/PRs by labels:

```bash
# Get closed issues with specific label (filtered with jq)
YESTERDAY=$(date -u -d "yesterday" +%Y-%m-%d)
gh issue list --label "bug" --state closed --json number,title,closedAt --jq "[.[] | select(.closedAt >= \"${YESTERDAY}T00:00:00Z\")] | .[] | \"- ✅ #\(.number) - \(.title)\""
```

### Release Notes Generation

Use the changelog to generate release notes:

```bash
# Extract entries between dates for release
sed -n '/### 2026-01-15/,/### 2026-01-01/p' CHANGELOG.md > RELEASE_NOTES.md
```

### Notification Integration

Add notifications to the workflow:

```yaml
- name: Notify on Discord/Slack
  if: steps.generate.outputs.has_changes == 'true'
  uses: some-notification-action@v1
  with:
    webhook: ${{ secrets.WEBHOOK_URL }}
    message: "Changelog updated for ${{ steps.generate.outputs.today }}"
```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitBook Documentation](https://docs.gitbook.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)

## Support

For issues or questions about the changelog system:

1. Check this documentation
2. Review workflow logs in Actions tab
3. Open an issue with the `documentation` label
4. Contact repository maintainers

---

*Last updated: 2026-01-21*
