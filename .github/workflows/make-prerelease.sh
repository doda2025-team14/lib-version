#!/usr/bin/env bash
set -e

BRANCH="${BRANCH_NAME:-unknown}"

if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
  echo "Not creating prerelease on main branch."
  exit 0
fi

# Extract base version (e.g., 1.2.0)
VERSION=$(xmlstarlet sel -t -v "/project/version" pom.xml)
BASE_VERSION=$(echo "$VERSION" | sed 's/-SNAPSHOT//')

# Example prerelease tag: v1.2.0-alpha.1
LABEL=$(echo "$BRANCH" | tr '/' '-' )
PREFIX="v${BASE_VERSION}-${LABEL}"

# Find latest prerelease of this branch
LAST=$(git tag --list "${PREFIX}.*" | sort -V | tail -1)

if [[ -z "$LAST" ]]; then
  NEXT="${PREFIX}.1"
else
  NUM=$(echo "$LAST" | awk -F. '{print $NF}')
  NEXT="${PREFIX}.$((NUM + 1))"
fi

echo "Creating prerelease tag: $NEXT"

# Create tag
git tag "$NEXT"
git push origin "$NEXT"

# Create GitHub prerelease
gh release create "$NEXT" --prerelease --notes "Prerelease for $BRANCH"