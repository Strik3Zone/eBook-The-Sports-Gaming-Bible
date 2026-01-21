#!/bin/bash
# Manual Changelog Update Script
# Usage: ./update-changelog.sh [date]
# If no date is provided, uses today's date

set -e

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set date variable
if [ -z "$1" ]; then
    TODAY=$(date -u +%Y-%m-%d)
    YESTERDAY=$(date -u -d "yesterday" +%Y-%m-%d)
else
    TODAY="$1"
    YESTERDAY=$(date -u -d "$TODAY - 1 day" +%Y-%m-%d 2>/dev/null || echo "$TODAY")
fi

echo -e "${BLUE}📋 Generating changelog for $TODAY${NC}"

# Create temporary file for new entries
TEMP_FILE=$(mktemp)

echo "### $TODAY" > "$TEMP_FILE"
echo "" >> "$TEMP_FILE"

# Track if we have any changes
HAS_CHANGES=false

# Get commits from the last 24 hours
echo -e "${YELLOW}🔍 Checking commits...${NC}"
COMMITS=$(git log --since="24 hours ago" --pretty=format:"- %s (%h)" --no-merges 2>/dev/null || echo "")
if [ -n "$COMMITS" ]; then
    echo "#### 🔄 Recent Commits" >> "$TEMP_FILE"
    echo "$COMMITS" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    HAS_CHANGES=true
    echo -e "${GREEN}✓ Found commits${NC}"
fi

# Get file changes statistics
echo -e "${YELLOW}🔍 Checking file changes...${NC}"
FILES_CHANGED=$(git log --since="24 hours ago" --name-only --pretty=format: --no-merges | sort -u | grep -v '^$' | wc -l)
if [ "$FILES_CHANGED" -gt 0 ]; then
    echo "#### 📁 Files Activity" >> "$TEMP_FILE"
    echo "- Modified/Added: $FILES_CHANGED file(s)" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    HAS_CHANGES=true
    echo -e "${GREEN}✓ Found file changes${NC}"
fi

# Try to get GitHub data if gh CLI is available
if command -v gh &> /dev/null; then
    echo -e "${YELLOW}🔍 Checking GitHub issues and PRs...${NC}"
    
    # Get closed issues
    ISSUES=$(gh issue list --state closed --limit 100 --json number,title,closedAt --jq "[.[] | select(.closedAt >= \"${YESTERDAY}T00:00:00Z\")] | .[] | \"- ✅ Closed: #\(.number) - \(.title)\"" 2>/dev/null || echo "")
    if [ -n "$ISSUES" ]; then
        echo "#### 📋 Issues Resolved" >> "$TEMP_FILE"
        echo "$ISSUES" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        HAS_CHANGES=true
        echo -e "${GREEN}✓ Found closed issues${NC}"
    fi
    
    # Get merged PRs
    PRS=$(gh pr list --state merged --limit 100 --json number,title,mergedAt --jq "[.[] | select(.mergedAt >= \"${YESTERDAY}T00:00:00Z\")] | .[] | \"- 🔀 Merged: #\(.number) - \(.title)\"" 2>/dev/null || echo "")
    if [ -n "$PRS" ]; then
        echo "#### 🎯 Pull Requests Merged" >> "$TEMP_FILE"
        echo "$PRS" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        HAS_CHANGES=true
        echo -e "${GREEN}✓ Found merged PRs${NC}"
    fi
    
    # Get opened issues
    NEW_ISSUES=$(gh issue list --state open --limit 100 --json number,title,createdAt --jq "[.[] | select(.createdAt >= \"${YESTERDAY}T00:00:00Z\")] | .[] | \"- 🆕 Opened: #\(.number) - \(.title)\"" 2>/dev/null || echo "")
    if [ -n "$NEW_ISSUES" ]; then
        echo "#### 📝 New Issues" >> "$TEMP_FILE"
        echo "$NEW_ISSUES" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        HAS_CHANGES=true
        echo -e "${GREEN}✓ Found new issues${NC}"
    fi
    
    # Get opened PRs
    NEW_PRS=$(gh pr list --state open --limit 100 --json number,title,createdAt --jq "[.[] | select(.createdAt >= \"${YESTERDAY}T00:00:00Z\")] | .[] | \"- 🔄 Opened: #\(.number) - \(.title)\"" 2>/dev/null || echo "")
    if [ -n "$NEW_PRS" ]; then
        echo "#### 🚀 New Pull Requests" >> "$TEMP_FILE"
        echo "$NEW_PRS" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        HAS_CHANGES=true
        echo -e "${GREEN}✓ Found new PRs${NC}"
    fi
else
    echo -e "${YELLOW}⚠ GitHub CLI not available, skipping issue/PR checks${NC}"
fi

# If no changes, add a note
if [ "$HAS_CHANGES" = false ]; then
    echo "_No activity recorded for this date_" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo -e "${BLUE}ℹ No changes detected${NC}"
fi

echo "---" >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"

# Update CHANGELOG.md
if [ ! -f CHANGELOG.md ]; then
    echo -e "${YELLOW}⚠ CHANGELOG.md not found${NC}"
    cat "$TEMP_FILE"
    rm -f "$TEMP_FILE"
    exit 1
fi

echo -e "${BLUE}📝 Updating CHANGELOG.md...${NC}"

# Create backup
cp CHANGELOG.md CHANGELOG.md.bak

# Find the CHANGELOG_START marker and insert new content after it
if grep -q "<!-- CHANGELOG_START -->" CHANGELOG.md; then
    awk -v new="$(cat $TEMP_FILE)" '
        /<!-- CHANGELOG_START -->/ {
            print
            print ""
            print new
            next
        }
        /^### [0-9]{4}-[0-9]{2}-[0-9]{2}/ {
            if (!found) {
                found=1
            }
        }
        {
            if (found || !/<!-- CHANGELOG_START -->/) {
                print
            }
        }
    ' CHANGELOG.md.bak > CHANGELOG.md
    
    # Update the last updated timestamp
    sed -i.tmp "s/\*Last updated: .*/\*Last updated: $TODAY (Manual Update)\*/" CHANGELOG.md
    rm -f CHANGELOG.md.tmp
    
    echo -e "${GREEN}✅ CHANGELOG.md updated successfully!${NC}"
else
    echo -e "${YELLOW}⚠ Warning: CHANGELOG_START marker not found in CHANGELOG.md${NC}"
fi

# Clean up
rm -f CHANGELOG.md.bak "$TEMP_FILE"

# Show what changed
echo -e "\n${BLUE}Changes preview:${NC}"
git diff CHANGELOG.md | head -50

echo -e "\n${GREEN}✨ Done! Review CHANGELOG.md and commit the changes.${NC}"
