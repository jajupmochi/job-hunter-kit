#!/usr/bin/env bash
# preflight_public.sh — refuse to publish if anything private slipped in.
#
# Run from the repository root. Exit 0 means safe to push.
#
# THE PATTERN LIST IS NOT IN THIS FILE, ON PURPOSE.
# An earlier version hard-coded the owner's real name, account handle, university,
# supervisors and project names into this script so it could grep for them. That
# published, in a public file, exactly the list it existed to keep out. The names
# now live in .private-identifiers, which is gitignored. Copy
# .private-identifiers.example to .private-identifiers and put your own in it.
#
# Six gates. Each one has caught something real at least once.
set -uo pipefail
fail=0
IGNORE=(--exclude-dir=.git --exclude=".private-identifiers")

# This script necessarily CONTAINS the patterns it searches for, so it matches itself.
# --exclude on the basename did not reliably suppress that once --include filters were
# added, so the self-hit is filtered by path instead: explicit, and obviously correct.
selfless() { grep -v '^\./scripts/preflight_public\.sh:'; }

# This repository's own "owner/name", derived from the remote rather than hard-coded.
# The owner's account handle unavoidably appears in this repo's own clone URL, and that
# one occurrence is intentional. Allowing it ANYWHERE would hide a real leak, so it is
# allowed only on a line that names this repository. Empty when there is no remote, in
# which case nothing is allowed, which is the safe direction.
OWNER_REPO=$(git config --get remote.origin.url 2>/dev/null \
             | sed -E 's#^.*[:/]([^/:]+/[^/]+?)(\.git)?$#\1#')
own_repo_url() {
  if [ -n "${OWNER_REPO:-}" ]; then grep -vF "$OWNER_REPO"; else cat; fi
}

hdr() { printf '\n== %s ==\n' "$1"; }
ok()  { printf '   ok: %s\n' "$1"; }
bad() { printf '   FAIL: %s\n' "$1"; fail=1; }

# ---------------------------------------------------------------------------
hdr "1. your own private identifiers"
if [ ! -f .private-identifiers ]; then
  bad "no .private-identifiers file; copy .private-identifiers.example and fill it in"
  echo "        Without it this gate cannot run, and a missing gate is not a passing gate."
else
  # One pattern per line, blank lines and # comments ignored, joined into one alternation.
  PAT=$(grep -vE '^\s*(#|$)' .private-identifiers | paste -sd'|' -)
  if [ -z "$PAT" ]; then
    bad ".private-identifiers is empty; put at least your name and account handle in it"
  elif grep -rInE "$PAT" "${IGNORE[@]}" . | selfless | own_repo_url | grep -q . ; then
    grep -rInE "$PAT" "${IGNORE[@]}" . | selfless | own_repo_url
    bad "a private identifier appears above"
  else
    ok "none of your listed identifiers appear"
  fi
fi

# ---------------------------------------------------------------------------
hdr "2. de-identification leftovers"
# A redaction placeholder means a de-identification pass ran and did not finish.
# Found in data/ on 2026-07-31: dozens of <REDACT_subjective> and <REDACT_log> markers.
REDACT_PAT='<REDACT[_A-Za-z]*>|<REDACTED>|XXX_REDACT|\[REDACTED\]'
if grep -rInE "$REDACT_PAT" "${IGNORE[@]}" . | selfless | grep -q . ; then
  grep -rInE "$REDACT_PAT" "${IGNORE[@]}" . | selfless
  bad "redaction placeholders are still in the tree"
else
  ok "no redaction placeholders"
fi

# ---------------------------------------------------------------------------
hdr "3. real people named in passing"
# The de-identification pass replaced names it knew about. It missed three real
# people sitting in a free-text column, because they were introduced by a word
# rather than by a field name. Titles and recommendation verbs are the giveaway.
PERSON_PAT='(Prof\.|Professor|Dr\.|PD Dr)[[:space:]]+[A-Z][a-z]+[[:space:]]+[A-Z][a-z]+|推荐([^人]|$)|introduced me|referred me|my supervisor'
PERSON_IN=(--include='*.md' --include='*.yml' --include='*.yaml' --include='*.txt' --include='*.py' --include='*.sh')
if grep -rInE "$PERSON_PAT" "${IGNORE[@]}" "${PERSON_IN[@]}" . | selfless | grep -q . ; then
  grep -rInE "$PERSON_PAT" "${IGNORE[@]}" "${PERSON_IN[@]}" . | selfless
  bad "a real person may be named above; check each hit by hand"
else
  ok "no third parties named"
fi

# ---------------------------------------------------------------------------
hdr "4. contact details"
MAIL_PAT='[[:alnum:]._%+-]+@[[:alnum:].-]+\.[A-Za-z]{2,}'
MAIL_OK='example\.(com|org)|@company|<[^>]*@|noreply@|your-?email'
if grep -rInE "$MAIL_PAT" "${IGNORE[@]}" . | selfless | grep -vE "$MAIL_OK" | grep -q . ; then
  grep -rInE "$MAIL_PAT" "${IGNORE[@]}" . | selfless | grep -vE "$MAIL_OK"
  bad "an email address is present"
else
  ok "no email addresses"
fi

# ---------------------------------------------------------------------------
hdr "5. paths out of a private workspace"
# A path to a private file leaks the shape of the private workspace, and sometimes
# the filename says more than the content would have.
#
# `applications/_inbox/` on its own is this kit's OWN convention and is fine. What
# is not fine is a reference to a SPECIFIC dated file from somebody's real search,
# which is how "2026-04-30--tier-A-B-candidates.md" reached a public repository.
PATH_PAT='/home/[a-z][a-z0-9_-]+/|/Users/[a-z][a-z0-9_-]+/|/media/[a-z][a-z0-9_-]+/|_inbox/20[0-9]{2}-[0-9]{2}-[0-9]{2}--[a-zA-Z]|(^|[^a-z])private/[a-z]|important_references'
if grep -rInE "$PATH_PAT" "${IGNORE[@]}" . | selfless | grep -q . ; then
  grep -rInE "$PATH_PAT" "${IGNORE[@]}" . | selfless
  bad "a private-workspace path is referenced above"
else
  ok "no private paths"
fi

# ---------------------------------------------------------------------------
hdr "6. personal documents and secrets"
found=$(find . -path ./.git -prune -o -type f \( -iname '*.pdf' -o -iname '*.docx' -o -iname '*.doc' \
        -o -iname '*.xlsx' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.heic' \) -print)
if [ -n "$found" ]; then
  echo "$found"; bad "binary documents present; check every one by hand"
else
  ok "no binary documents"
fi

if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --no-git -v >/dev/null 2>&1 && ok "gitleaks found no secrets" || bad "gitleaks reported findings; run 'gitleaks detect --no-git -v'"
else
  echo "   SKIP: gitleaks is not installed; a skipped gate is not a passing gate"
fi

# ---------------------------------------------------------------------------
echo
if [ "$fail" -eq 0 ]; then echo "PREFLIGHT PASSED"; else echo "PREFLIGHT FAILED"; fi
exit "$fail"
