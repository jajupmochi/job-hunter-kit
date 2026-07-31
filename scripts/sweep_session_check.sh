#!/usr/bin/env bash
#
# sweep_session_check.sh - SessionStart hook for the nightly job-sweep self-heal.
#
# Wired via .claude/settings.json (hooks.SessionStart). On each session start it
# prints a short directive block to stdout, which Claude Code injects into the
# session context. Claude then ACTS on the ACTION lines:
#   1) re-arm the in-session 00:25 summary cron if it is missing (new process),
#   2) surface any nightly-sweep summary that has not been shown yet.
# In-tool crons are session-scoped, so a brand-new session (startup/resume) has
# none, and Claude re-arms it; this is what makes the feature survive restarts.
# Must never fail the session start: best-effort, always exit 0.

# Skip entirely inside the headless nightly sweep run (nightly_sweep.sh exports this). The self-heal
# is only for interactive sessions; otherwise the headless claude -p would re-arm a doomed cron and
# clobber cron_state.json nightly, defeating the >5-day self-renew.
[ -n "${JOBHUNTER_SWEEP_HEADLESS:-}" ] && exit 0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null)" || exit 0
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd 2>/dev/null)" || exit 0
STATE="${PROJECT_DIR}/outputs/nightly_sweep/cron_state.json"
PROMPT_FILE="${PROJECT_DIR}/scripts/sweep_cron_prompt.txt"
TODAY="$(date +%F 2>/dev/null)"

last_armed="none"; last_summary="none"; cron_id="none"
if [ -f "$STATE" ]; then
  vals="$(python3 - "$STATE" <<'PY' 2>/dev/null
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    print(d.get("last_armed", "none"), "||", d.get("last_summary_date", "none"), "||", d.get("cron_id", "none"))
except Exception:
    print("none || none || none")
PY
)"
  last_armed="$(printf '%s' "$vals" | awk -F' \\|\\| ' '{print $1}')"
  last_summary="$(printf '%s' "$vals" | awk -F' \\|\\| ' '{print $2}')"
  cron_id="$(printf '%s' "$vals" | awk -F' \\|\\| ' '{print $3}')"
fi

latest="$(ls -1 "${PROJECT_DIR}/applications/_inbox/"*--nightly-sweep.md 2>/dev/null | sort | tail -1)"
ldate="none"
[ -n "$latest" ] && ldate="$(basename "$latest" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' 2>/dev/null)"

echo "[NIGHTLY-SWEEP SELF-HEAL | ${TODAY}] state: last_armed=${last_armed} cron_id=${cron_id} last_summary_date=${last_summary}"
echo "ACTION FOR CLAUDE (nightly-sweep self-heal protocol):"
echo "1) Run CronList. If a cron with schedule '25 0 * * *' is already listed it is alive, so skip re-arm. Otherwise (new process after startup/resume) re-arm: read ${PROMPT_FILE} and CronCreate (cron '25 0 * * *', recurring, durable) with that exact content as the prompt; then write ${STATE} with last_armed set to the current date-time and cron_id set to the new id (keep last_summary_date)."
if [ "$ldate" != "none" ] && [ "$ldate" != "$last_summary" ]; then
  echo "2) MISSED SUMMARY: the latest sweep doc $(basename "$latest" 2>/dev/null) (date ${ldate}) has not been shown. Read it and post a short Chinese summary to the user now, then set last_summary_date=${ldate} in ${STATE}."
else
  echo "2) No missed sweep summary (latest doc date ${ldate} already shown)."
fi
exit 0
