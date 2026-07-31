#!/usr/bin/env bash
#
# nightly_sweep.sh — the "forever" nightly job-sweep timer.
#
# Invoked by an OS crontab line (see the block at the bottom of this file, or
# docs/AUTORUN_SWEEP_CHARTER.md § 8). Runs Claude Code headless against the
# charter, which performs a 10-round international job sweep, re-ranks the
# Top-5, drafts missing materials, and commits locally. DRAFTS ONLY — the
# charter forbids submitting or sending anything.
#
# Install (the user does this; it modifies their crontab):
#     crontab -e
#   then add the line shown at the bottom of this file.
#
# Stop: crontab -e and delete that line.
#
set -euo pipefail

# --- Config -----------------------------------------------------------------

# Project root — auto-derived from this script's own location (scripts/ sits one
# level below the project root). Path-agnostic: works wherever the repo lives and
# keeps absolute local paths out of the committed file. Quoting handles spaces.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Claude binary. Auto-detect, else fall back to the known install path.
CLAUDE_BIN="${CLAUDE_BIN:-$(command -v claude 2>/dev/null || echo "${HOME}/.local/bin/claude")}"

# Permission mode for an UNATTENDED run. A cron job has no human to approve
# tool calls, so headless mode must be allowed to use its tools non-interactively.
# --dangerously-skip-permissions grants that. Review this: it lets the nightly
# agent read/write/web/commit without prompting. The charter's hard constraints
# (drafts only, no send, no push, no fabrication) are the safety boundary instead.
# To tighten, replace with e.g. --permission-mode acceptEdits (may stall on web tools).
CLAUDE_PERMS="${CLAUDE_PERMS:---dangerously-skip-permissions}"

# Model override. Empty = use the account default. The sweep is heavy; you may
# prefer a cheaper model for the nightly run, e.g. CLAUDE_MODEL="claude-sonnet-4-6".
CLAUDE_MODEL="${CLAUDE_MODEL:-}"

# Cron has a minimal PATH. Prepend the dirs claude/node typically live in.
export PATH="${HOME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH:-}"

# --- Setup ------------------------------------------------------------------

TODAY="$(date +%F)"
LOG_DIR="${PROJECT_DIR}/outputs/nightly_sweep"
LOG_FILE="${LOG_DIR}/${TODAY}.log"
LOCK_FILE="/tmp/jobhunter_nightly_sweep.lock"

log() { printf '%s | %s\n' "$(date '+%F %T')" "$*" >>"$LOG_FILE"; }

# --- Guards -----------------------------------------------------------------

# 1. The project lives on a mounted volume. If it isn't mounted, bail cleanly.
if [ ! -d "${PROJECT_DIR}/.git" ]; then
  mkdir -p "/tmp" 2>/dev/null || true
  echo "$(date '+%F %T') | ABORT: project dir not found (volume unmounted?): ${PROJECT_DIR}" \
    >>"/tmp/jobhunter_nightly_sweep.fallback.log"
  exit 1
fi

mkdir -p "$LOG_DIR"

# 2. Don't overlap with a still-running previous sweep.
if [ -e "$LOCK_FILE" ]; then
  if kill -0 "$(cat "$LOCK_FILE" 2>/dev/null)" 2>/dev/null; then
    log "ABORT: previous sweep (pid $(cat "$LOCK_FILE")) still running."
    exit 0
  fi
  log "WARN: stale lock found, overriding."
fi
echo "$$" >"$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# 3. Claude binary present?
if [ ! -x "$CLAUDE_BIN" ] && ! command -v "$CLAUDE_BIN" >/dev/null 2>&1; then
  log "ABORT: claude binary not found/executable at: ${CLAUDE_BIN}"
  exit 1
fi

# --- Run --------------------------------------------------------------------

cd "$PROJECT_DIR"

log "START nightly sweep. claude=${CLAUDE_BIN} model=${CLAUDE_MODEL:-<default>} perms=${CLAUDE_PERMS}"

PROMPT="Read docs/AUTORUN_SWEEP_CHARTER.md in full, then execute it end to end. \
Today is ${TODAY}. This is the unattended nightly job sweep: 10 rounds, ~6 Switzerland : ~4 abroad \
(per L-022), live-verify every role (L-007/L-011/L-013), write applications/_inbox/${TODAY}--nightly-sweep.md \
with a re-ranked Top-5, draft packages for any new Top-5 role that lacks one, run the modes/critic.md pass, \
and commit locally to master. Hard constraints: DRAFTS ONLY, never submit/send/post/push, never fabricate."

MODEL_ARG=()
[ -n "$CLAUDE_MODEL" ] && MODEL_ARG=(--model "$CLAUDE_MODEL")

# Headless print mode. stdout+stderr tee'd to the daily log.
# Mark this as the headless sweep run so the SessionStart self-heal hook skips itself here.
# Otherwise the headless claude -p (a new process) fires the hook, re-arms a doomed in-tool cron
# that dies when this run exits, and clobbers cron_state.json nightly, defeating the >5-day self-renew.
export JOBHUNTER_SWEEP_HEADLESS=1
if "$CLAUDE_BIN" -p "$PROMPT" "${MODEL_ARG[@]}" $CLAUDE_PERMS >>"$LOG_FILE" 2>&1; then
  log "DONE nightly sweep OK."
else
  rc=$?
  log "ERROR nightly sweep exited with code ${rc}."
  exit "$rc"
fi

# --- Crontab line to install (the user runs `crontab -e` and pastes this) ---
#
#   # job-hunter nightly sweep — fires 00:03 local, every day, forever.
#   3 0 * * * "<ABSOLUTE_PATH_TO_PROJECT>/scripts/nightly_sweep.sh"
#
# If cron can't find node/claude (PATH issues), use a login shell instead:
#   3 0 * * * /usr/bin/zsh -lc '"<ABSOLUTE_PATH_TO_PROJECT>/scripts/nightly_sweep.sh"'
#
# Replace <ABSOLUTE_PATH_TO_PROJECT> with this repo's absolute path on your
# machine (the directory that contains scripts/). The ready-to-paste line with
# the real path is provided in the install handoff, not committed here.
#
# To skip one night: comment the line out that evening, uncomment after.
# To stop forever: delete the line.
