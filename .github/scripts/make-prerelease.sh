#!/usr/bin/env bash
set -e
set -x

BRANCH="${BRANCH_NAME:-unknown}"

if [[ "$BRANCH" == "master" ]]; then
  echo "Not creating prerelease on main branch."
  exit 0
fi

if [[ ! -f pom.xml ]]; then
  echo "ERROR: pom.xml not found!"
  exit 1
fi


# Extract base version and removes snapshot
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

if [[ -z "$VERSION" ]]; then
  VERSION="1.0.0-SNAPSHOT"
  echo "VERSION not found in pom.xml, using default: $VERSION"
fi


BASE_VERSION=$(echo "$VERSION" | sed 's/-SNAPSHOT//')


LABEL=$(echo "$BRANCH" | tr '/' '-' )
PREFIX="v${BASE_VERSION}-${LABEL}"

TIMESTAMP=$(TZ="Europe/Amsterdam" date +%d%m%y-%H%M%S)

NEXT="v${BASE_VERSION}-${LABEL}-${TIMESTAMP}"

echo "Creating prerelease tag: $NEXT"

# Create tag
git tag "$NEXT"
git push origin "$NEXT"

# Create GitHub prerelease
gh release create "$NEXT" --prerelease --notes "Prerelease for $BRANCH"