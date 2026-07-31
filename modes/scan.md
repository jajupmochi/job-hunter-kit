# Mode · scan

Find roles. Produce a list, not a decision.

## Before

Read [`_profile.md`](_profile.md) for the axes and exclusions, and
[SEARCH_STRATEGY.md](../docs/SEARCH_STRATEGY.md) for the channel families.

## Steps

1. **Pick the channels for this pass.** Rotate; do not run the same one every time.
2. **Query both axes**, domain and method, in each channel.
3. **Capture each hit** as `{title, employer, location, url, identifier, liveness, why-it-fits}`.
   The identifier is the requisition or posting id, and it is what deduplication uses.
4. **Verify liveness at the employer's own source** for anything you might act on. Tag it
   `confirmed-open`, `listed-elsewhere`, `blocked` or `closed`, and never collapse `blocked`
   into `closed`.
5. **Deduplicate against everything already recorded**, on the identifier.
6. **Report what you could not reach**, and why.

## Rules

- **Never pad the list.** Six real finds beat ten with four guesses.
- **Apply the exclusions.** A role that matches your method but sits in an excluded domain is
  a distraction, and it is the most tempting kind.
- **One line per role on why it fits.** If you cannot write that line, it does not go on the list.

## Output

A dated list, plus the channels that produced nothing. Then [`evaluate.md`](evaluate.md) on
anything that survives.
