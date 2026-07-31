# G-14 · Look before you write, and match on the identifier

Two habits that prevent two different kinds of silent damage.

## Look before you write

**List the folder before you write into it.** Read the file before you replace it. The cost is
one command; the cost of skipping it is overwriting work you did not know was there.

**Prefer an edit to a rewrite.** A rewrite silently drops everything it did not reproduce, and
because the result looks complete, nothing signals the loss.

**Verify from the artifact, not from your edit.** Check the rendered document, not the source.
Check the built file, not the build log. **A process that reports success can have written
nothing at all**, and the log will still say success.

## Match on the identifier, not the title

When deciding whether something is new, compare the **stable identifier**: the requisition
number, the posting id, the URL path segment that does not change.

**Titles are not identifiers.** The same role gets reposted under a reworded title. Two
genuinely different roles at one employer share a title. Deduplicating on the title merges
things that are different and separates things that are the same, and both failures are
invisible afterwards.

**Open every match.** When a check returns more than one hit, read all of them. A single-hit
assumption is how the second, real one gets missed.

Related: [G-11](G-11-a-negative-is-a-fact-about-your-method.md), [G-13](G-13-status-comes-from-the-record.md).
