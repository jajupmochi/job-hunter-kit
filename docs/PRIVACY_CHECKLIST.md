# What must never be published

> Every example in this kit is invented. See the disclaimer in the [README](../README.md).

A job search generates the most sensitive collection of documents most people ever assemble
about themselves. **If any part of your workspace is in version control, assume one day it
will be public**, and set it up so that day is uneventful.

## The split

**Two repositories, not one.** A private one with your search in it, and a public one, if you
want one at all, with only the method.

| Private, always | Public, if you want |
|---|---|
| CVs, letters, forms, every application | The method and the rules |
| Identity documents, diplomas, certificates, photographs | Scripts and templates with placeholders |
| **Other people's names, emails, phone numbers** | Platform and tooling notes |
| Salaries, offers, negotiation notes | Lessons, stated so they name nobody |
| Interview notes and debriefs | |
| Contacts, referees, outreach logs | |
| Your own truth-anchor list | |
| **Adverts captured verbatim** (somebody else's copyrighted text) | |

## The one that gets missed

**Other people's data is not yours to publish, and it is the easiest thing to leak.**

Your own name in a public repository is your decision. A colleague's name, a hiring manager's
email, a professor who recommended a website to you, a former supervisor listed in an outreach
log: none of those people agreed to anything. **They will be in your notes because notes are
where you put things, and they will survive an anonymisation pass because that pass looks for
your identifiers, not theirs.**

Check for third parties as a separate step, with a separate search. `scripts/preflight_public.sh`
does this: it looks for titles followed by names, for recommendation phrases, and for email
addresses anywhere in the tree.

## Anonymisation fails quietly, in four ways

Every one of these was found in this repository after a pass that was believed complete.

1. **Half a name survives.** A first name is replaced and the surname is not, or the reverse.
   `CV_Sam_Jia` looks anonymised and is not.
2. **A word boundary hides it.** Searching for `\bJia\b` returns nothing in `CV_Sam_Jia`,
   because an underscore is a word character. **A grep that returns zero is not proof; run it
   against something you know is present first.** See
   [G-11](../lessons/G-11-a-negative-is-a-fact-about-your-method.md).
3. **The identifying detail is not a name.** A conference plus a year plus a first-authorship,
   or a lab plus a topic, can identify one person in a single search even with every name
   removed.
4. **Two stand-ins for the same thing.** Replace an employer with one invented name in some
   files and a different one in others, and a reader sees two employers where there was one.

**And the tool itself can be the leak.** A gate that greps for your private identifiers must
not carry the list of them in a tracked file, or it publishes exactly what it exists to
prevent. Keep the list in a gitignored file. See `.private-identifiers.example`.

## History counts as published

Removing something from the working tree does not remove it from history. **Anyone can read
every version of every file that was ever committed.** If something private was committed, the
history has to be rewritten and the remote force-updated, and anything already cloned or
mirrored is beyond recall.

## The gates

Three layers, because each catches what the others miss.

1. **`.gitignore`**, so private files are never staged.
2. **`.githooks/pre-commit` and `.githooks/pre-push`**, running the preflight locally. Install
   with `git config core.hooksPath .githooks`.
3. **CI**, running the same preflight on every push, because a hook only protects the machine
   it is installed on.

**A gate that cannot run has not passed.** If the preflight cannot find your identifier list,
it fails rather than skipping, and CI fails when the secret holding that list is unset.

## Before making anything public

1. Run `./scripts/preflight_public.sh` and read every hit rather than the summary line.
2. Search the tree for third parties by hand, separately from the automated pass.
3. Search the **history**, not only the tree.
4. Have someone else look, or come back to it a day later. **You cannot see your own
   identifiers**, because to you they are just words.
