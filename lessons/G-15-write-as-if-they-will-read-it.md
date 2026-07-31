# G-15 · Write every note as if the people in it will read it

**Your private notes become public more often than you expect.** A repository goes open, a
document gets shared, a screenshot circulates, a folder syncs somewhere. The only reliable
protection is that there was nothing in them you would not defend.

This is the rule that would have prevented every finding in this kit's own privacy audit.

## Three things that keep appearing in job-search notes

### 1. Other people's data

Names, emails, phone numbers, profile URLs, who recommended whom, who you plan to contact and
when. **None of those people agreed to anything.**

Your own name in a public file is your decision to make. A hiring manager's email is not. A
former supervisor listed in an outreach log with a date beside it is not. **They end up in
your notes because notes are where things go**, and they survive anonymisation because that
pass looks for your identifiers, not theirs.

**Write third parties by role, not by name**, unless the name is doing work the role cannot:
"the hiring manager", "a researcher whose work overlaps mine", "the person who posted it".
Keep the actual names in one place you never share.

### 2. Judgements about countries, institutions and categories of people

This is the one that causes real harm, and it is invisible while you write it, because in your
own head it is just prioritisation.

| The private thought | How it reads when published |
|---|---|
| Ranking countries into tiers by wealth | Readers from the lower tiers are told where they stand |
| "X only if the fit is exceptional" applied to a country | The same, with a number on it |
| Calling a whole country a fallback | The same, worse |
| Rating universities as mid-tier or low-prestige | Named institutions publicly downgraded, and their staff with them |
| Blaming a writing defect on a language group | Every reader from that group is told their register is the failure mode |
| Naming a national style as the thing to avoid | The same |
| Calling a category of role filler | Everyone doing that job |
| Comparing people you are asking for help to game characters | Exactly what it sounds like |

**Every one of those is a real example from a repository that was published.** None was written
with any intent behind it. Each was a shorthand for a legitimate personal decision, written
down in the fastest available words.

**The fix is not to stop prioritising.** It is to record the decision without the ranking:

> Not: *"L3, anywhere else. Only if fit is exceptional."*
> But: *"I can work in A and B without sponsorship. Elsewhere I would need a permit, so a role
> there has to be worth that effort. Here is where I have decided the line sits."*

The second says the same thing operationally, is more useful because it says **why**, and
insults nobody.

### 3. Judgements about platforms and companies

Naming a commercial product and asserting it will get you banned, characterising an employer
as a place that does not let people publish, or describing a company's business in unflattering
terms are all **publishable claims about identifiable businesses**.

Keep the operational fact, drop the verdict. "Most platforms' terms prohibit automated
applying" is a fact. "Product X will get your account banned" is an allegation.

## The test

Before writing a judgement into a file, ask: **would I say this in a room containing the people
it is about?**

If no, write the decision instead of the verdict. **You almost always need the decision and
almost never need the verdict**, and the decision is the part that will still be useful to you
in six months.

## A second test, for tone

**Would this embarrass me if it appeared under my name, with no context?** Notes are written in
shorthand, and shorthand read cold sounds harsher than it felt. A phrase that was a joke to
yourself is not a joke to a stranger.

## The mechanical backstop

Judgement is not enough on its own, because you cannot see your own shorthand. Keep an
automated check for the classes above, run it before anything is shared, and read every hit
rather than the summary line. See [`scripts/preflight_public.sh`](../scripts/preflight_public.sh)
and [PRIVACY_CHECKLIST.md](../docs/PRIVACY_CHECKLIST.md).

**And check history, not just the current files.** See
[G-11](G-11-a-negative-is-a-fact-about-your-method.md): a search that finds nothing has to be
controlled before you believe it.

Related: [G-07](G-07-every-claim-has-a-source.md), [G-03](G-03-show-do-not-assert.md).
