# G-09 · Measure a rule change against real data before applying it

**The obvious fix is often net negative, and you cannot tell without counting.**

## The pattern

You notice a rule misfiring. A filter catching the wrong things, a phrase ban flagging a
sentence that was fine, a category rule mis-sorting. The instinct is to change the rule.

**Run the old rule and the new rule over your real data first, and look at every difference.**
Not a sample. Every one.

## The measurement

For each difference ask: **is this one now right, or now wrong?** Then count.

A change that fixes three misfires while creating four new ones is a regression, and it will
look like an improvement from the three examples that prompted it. **Those three are the ones
you noticed, which is exactly why they are not a sample.**

## Worked shape

A classifier was catching items it should not. Deleting the offending term would have fixed
**three** false positives and created **four** false negatives. Narrowing the term instead
fixed all three and created none. **Only the count made that visible**, and the count took two
minutes.

## The generalisation

This applies to any rule you maintain about your own search: which roles are worth applying
to, which sources are worth checking, which phrases to avoid. **Rules accumulate on the
strength of one bad experience each. Occasionally check whether they still pay for
themselves.**

Related: [G-08](G-08-change-only-what-the-rule-requires.md), [G-11](G-11-a-negative-is-a-fact-about-your-method.md).
