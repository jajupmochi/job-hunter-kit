# data/

One file: `platforms.yml`, a catalogue of places job postings live.

It is a **starting point, not a recommendation and not a ranking.** Which platforms
are worth your time depends on your field, your seniority, and where you are
allowed to work, and none of that can be decided here. Edit the file. Delete what
does not apply to you and add what does.

## Why the file has a `kind` and an `access` field

Those two fields exist so an agent can pick a retrieval method instead of treating
every URL the same.

`kind` says what the platform is: an aggregator searching across employers, an
applicant tracking system hosting one employer's board, an academic listing, a
regional site, or a community channel where openings are mentioned before they
are advertised.

`access` says what it takes to read it. `open` means a plain fetch returns the
postings. `json` means there is an endpoint that returns structured data, which
is the reliable path. `spa` means the page is JavaScript and a plain fetch returns
an empty shell, so a browser is needed. `login` means an account is required.

**The `json` entries are the ones worth learning.** When you know an employer's
name, their applicant tracking system returns the authoritative list of what is
open today, with ids and dates, in one request. That is a stronger signal than
any aggregator, because an aggregator can show you a posting that closed last
week and an employer's own board cannot.

## What is deliberately not here

No target lists, no contacts, no notes about specific employers, no ratings. Those
are personal, they go stale, and a public repository is the wrong place for them.
Keep yours in your own private copy.
