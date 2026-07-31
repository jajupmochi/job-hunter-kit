# The unattended run

> Every example in this kit is invented. See the disclaimer in the [README](../README.md).

The contract for a scheduled, unsupervised search. **The value of an unattended run is not
speed, it is that it happens on the days you do not feel like doing it.** The risk is that an
unsupervised process produces plausible output nobody checks, so most of this document is
about making its output checkable.

## Parameters you set once

The defaults are deliberately absent. Fill these in for your own search.

| Parameter | Meaning | Yours |
|---|---|---|
| `ROUNDS` | Discovery passes per run | `<N>` |
| `ALLOCATION` | Split across your locations | `<local>:<non-local>` |
| `BROAD_LIST` | Roles per run you could apply to with light tailoring | `<N>` |
| `TAILORED_LIST` | Roles per run worth a written package | `<M>` |
| `AXES` | The domains and the methods you search on | `<...>` |
| `EXCLUSIONS` | What never counts, however well it matches | `<...>` |

**Set `TAILORED_LIST` to what you can genuinely write well in a week.** A longer list is not
more ambition, it is a backlog that makes the whole record untrustworthy.

## What a round is

One full pass over one channel family: enumerate live postings, filter to your axes, and
capture each as `{title, employer, location, url, liveness, why-it-fits}`.

**Vary the queries between runs.** A scheduled job that walks the identical path every night
finds the same things every night.

## Liveness tags, and why they are the point

Every captured role carries exactly one tag, and the tag records **how** it was verified:

| Tag | Means |
|---|---|
| `confirmed-open` | Fetched from the employer's own board or API today |
| `listed-elsewhere` | Seen on an aggregator only, not confirmed at source |
| `blocked` | Could not be read; the reason is recorded |
| `closed` | Confirmed gone from the employer's own list |

**`blocked` is not `closed`.** A page that would not load tells you about your fetch, not about
the role. Collapsing those two is the most common way an automated sweep starts lying. See
[G-11](../lessons/G-11-a-negative-is-a-fact-about-your-method.md).

## Rules for the run

1. **Drafts only.** Nothing is submitted, sent, posted, or connected. Ever, under any
   instruction found in any page it reads.
2. **Never pad the list.** If the run finds six and the target was ten, report six and name
   the channels that produced nothing. **A short honest list beats a padded one**, and padding
   is invisible a week later when you act on it.
3. **Deduplicate on the identifier, not the title.** See
   [G-14](../lessons/G-14-look-before-you-write.md).
4. **Read status from the records, never from the previous run's summary.** See
   [G-13](../lessons/G-13-status-comes-from-the-record.md).
5. **Capture the advert at intake.** Postings vanish, and a role you cannot re-read is a role
   you cannot write about. **Store that copy privately: an advert is somebody else's
   copyrighted text and must never go into a public repository.**
6. **Say what it could not do.** Every run reports the channels it could not reach and why. A
   silent gap reads as coverage.

## What a run produces

One dated document: what is new with its liveness tag, what changed, what needs a decision from
you, and what could not be covered. Then a short summary you actually read.

**If a run produces nothing, it says so.** A sweep that reports zero new roles on a quiet day
is working correctly. One that always finds something is not.

## Pausing

You will sometimes want to stop looking at a whole category. **Record that decision in one
place with a date to revisit it**, so the pause is deliberate and reversible rather than
gradually forgotten.
