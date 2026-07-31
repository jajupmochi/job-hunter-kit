# Mode · tracker

One record per application, and one table over all of them.

## Per application

A folder named `<date>-<employer>-<role>/`, with one record file carrying at least:

| Field | Note |
|---|---|
| `status` | See below |
| `url`, `identifier` | The identifier is what deduplication uses |
| `deadline` | |
| `applied_date` | Empty until you actually send |
| `liveness` | With the date it was checked |
| `contact` | If a person is named |
| `outreach` | Every send and every silence, dated |
| `notes` | Why it is interesting, and what you decided |

## Status

`lead` · `evaluating` · `drafting` · `ready` · `applied` · `acknowledged` · `interview` ·
`offer` · `rejected` · `declined` · `withdrawn` · `closed`

**`ready` is the one that matters.** A finished package that was never sent is the most common
and most expensive failure in a job search, and it is invisible unless the status says so.

## The table

Generated from the records, never edited by hand.
**[G-13](../lessons/G-13-status-comes-from-the-record.md): status comes from the record, not
from your last summary.** `scripts/applications_tracker.py` builds one spreadsheet from a
folder of record files.

Worth surfacing in it: anything `ready` with a deadline approaching, anything applied and
silent for weeks, and anything with a named contact you have never used.

## Write decisions down the same day

Decided not to apply, decided to wait, sent it, heard back. **The same day, in the record.**
Otherwise the table quietly stops being true, and you will not notice until you act on it.
