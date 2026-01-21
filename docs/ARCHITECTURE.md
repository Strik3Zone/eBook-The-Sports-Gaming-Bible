# 🏗️ Changelog System Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   CHANGELOG SYSTEM                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────┐
│   GitHub Events     │
│                     │
│  • Commits          │
│  • Issues           │
│  • Pull Requests    │
│  • File Changes     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│              AUTOMATED TRIGGERS                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Scheduled  │  │    Manual    │  │    Local     │     │
│  │   (Daily)    │  │   Trigger    │  │    Script    │     │
│  │              │  │              │  │              │     │
│  │  00:00 UTC   │  │  On-Demand   │  │  ./update-   │     │
│  │   Cron Job   │  │  Via Actions │  │  changelog   │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │             │
│         └──────────────────┼──────────────────┘             │
│                            ▼                                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│           CHANGELOG GENERATION WORKFLOW                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Checkout Repository (with full history)                 │
│  2. Collect Git Commits (last 24 hours)                     │
│  3. Query GitHub API (issues, PRs)                          │
│  4. Calculate File Statistics                               │
│  5. Format Data (GitBook style)                             │
│  6. Update CHANGELOG.md                                      │
│  7. Commit & Push Changes                                   │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                OUTPUT: CHANGELOG.md                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  # 📋 Changelog                                             │
│  > Daily automated updates...                               │
│                                                              │
│  ## Change History                                          │
│  <!-- CHANGELOG_START -->                                   │
│                                                              │
│  ### 2026-01-21                                             │
│  #### 🔄 Recent Commits                                     │
│  - Feature X (abc123)                                       │
│                                                              │
│  #### 📋 Issues Resolved                                    │
│  - ✅ Closed: #123                                          │
│                                                              │
│  #### 🎯 Pull Requests Merged                               │
│  - 🔀 Merged: #456                                          │
│                                                              │
│  <!-- CHANGELOG_END -->                                     │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   DISTRIBUTION                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   GitHub     │  │   GitBook    │  │    Local     │     │
│  │   Repository │  │   Integration│  │    Viewers   │     │
│  │              │  │              │  │              │     │
│  │  Web View    │  │  Auto-Sync   │  │  Markdown    │     │
│  │  via GitHub  │  │  to Docs     │  │  Readers     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Components

### 1. Data Sources
- **Git Log**: Commit history and file changes
- **GitHub API**: Issues and pull request data
- **Repository**: File system changes

### 2. Triggers
- **Scheduled**: Daily cron job at 00:00 UTC
- **Manual**: GitHub Actions workflow dispatch
- **Local**: Shell script for development

### 3. Processing
- **Collection**: Gather data from multiple sources
- **Formatting**: Convert to GitBook markdown
- **Insertion**: Update CHANGELOG.md file
- **Version Control**: Commit and push changes

### 4. Output
- **CHANGELOG.md**: Main changelog file
- **GitBook Ready**: Formatted for documentation
- **Human Readable**: Clear, scannable format

## Data Flow

```
Commits ──┐
          │
Issues ───┼──► Collection ──► Formatting ──► CHANGELOG.md ──► GitBook
          │
PRs ──────┤
          │
Files ────┘
```

## File Relationships

```
Repository Root
├── .gitbook.yaml ..................... GitBook config (references CHANGELOG)
├── README.md ......................... Links to changelog
├── Table of Contents.md .............. Contains changelog quick links
├── CHANGELOG.md ...................... Main changelog file (auto-updated)
│
├── .github/
│   ├── workflows/
│   │   └── daily-changelog.yml ....... Automation workflow
│   └── scripts/
│       └── update-changelog.sh ....... Manual update script
│
└── docs/
    ├── CHANGELOG_GUIDE.md ............ Full documentation
    ├── CHANGELOG_QUICK_REF.md ........ Quick reference
    └── ARCHITECTURE.md ............... This file
```

## Update Cycle

```
Day 1, 00:00 UTC
    ↓
Workflow Triggers
    ↓
Collect Activity (Day 0)
    ↓
Generate Entry
    ↓
Update CHANGELOG.md
    ↓
Commit Changes
    ↓
Push to Repository
    ↓
Wait 24 Hours
    ↓
Day 2, 00:00 UTC
    ↓
(Repeat)
```

## Security & Permissions

```
GitHub Actions Workflow
    │
    ├─ contents: write ......... Update CHANGELOG.md
    ├─ pull-requests: read ..... Read PR data
    └─ issues: read ............ Read issue data
```

## Integration Points

### GitBook
- Configured in `.gitbook.yaml`
- Auto-syncs on push
- Available in navigation

### GitHub
- Actions tab for manual trigger
- Visible in commit history
- Linked in README

### Local Development
- Script available for testing
- Same format as automated
- Requires GitHub CLI for full data

## Maintenance

### Regular Tasks
- Monitor workflow runs (Actions tab)
- Review changelog entries monthly
- Update format as needed

### Customization Points
- Cron schedule in workflow
- Data collection queries
- Formatting templates
- Icon choices

### Troubleshooting Paths
1. Check Actions logs
2. Review CHANGELOG_GUIDE.md
3. Test with local script
4. Verify permissions

---

*For detailed usage instructions, see [CHANGELOG_GUIDE.md](CHANGELOG_GUIDE.md)*
*For quick reference, see [CHANGELOG_QUICK_REF.md](CHANGELOG_QUICK_REF.md)*
