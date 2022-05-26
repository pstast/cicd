#!/bin/bash

COMMIT=$(git rev-list --max-count=1 HEAD)
echo COMMIT=$COMMIT


# check whether current commit already has revision number

TAGS=$(git tag --points-at $COMMIT | grep -E '^r[0-9]+$')
if [ -n "$TAGS" ]; then
    echo "This commit already has a revision number: $TAGS"
    exit
fi

# fetch all tags
git fetch origin --tags --quiet

LASTTAG=$(git tag | grep -E '^r[0-9]+$' | sort -n -r | head -n 1)

if [ -z "$LASTTAG" ]; then
    LASTTAG=r0
fi

echo LASTTAG=$LASTTAG

LASTREV=${LASTTAG:1}
echo LASTREV=$LASTREV

NEWREV=$((LASTREV+1))
NEWTAG=r$NEWREV
echo NEWREV=$NEWREV
echo NEWTAG=$NEWTAG

git tag $NEWTAG $COMMIT
git push --tags
