#!/usr/bin/env python3
"""insider_posts_queries.py — build search queries/URLs for mining insider
"we're hiring" posts (the hidden-job method).

Insiders (founders, hiring managers, team members) post openings directly on
social platforms, bypassing the ATS/HR auto-screen. The method: search recent
POSTS (not Jobs) for exact-quoted "we're hiring"-type phrases + your target
field, filtered to the past week. See docs/JOB_SEARCH_PLAYBOOK.md § 4.

This script only BUILDS the search URLs. A human (or the `insider-hiring-posts`
skill, interactively in a logged-in browser) opens them, reads the results, and
the applicant sends any comment / DM / connect. It never opens a browser, never
logs in, and never acts. DRAFTS ONLY.

Two things learned from running this against a live platform:
  * Quote the FIELD, leave the LOCATION unquoted. A quoted place name combined
    with a narrow phrase and a short time window returns nothing at all. Use the
    platform's own geographic filter for place, and spend your specificity on
    the field instead.
  * --eu adds German and French hiring phrases. Wherever people post in a
    language other than English, a pure-English phrase set misses them, and the
    same will be true of any other language region you search in.

Usage:
  python3 scripts/insider_posts_queries.py --field "<your field>" \
      --field "<another title you would accept>" --location "<country>" \
      --remote --platform linkedin,google,x [--max-per-platform 8] [--json]
"""
import argparse
import json
import urllib.parse

# "magic keywords": exact-quoted hiring phrases insiders use in posts.
# Strongest / highest-signal first, so --max-per-platform keeps the best ones.
HIRING_PHRASES = [
    "we're hiring",
    "hiring now",
    "join our team",
    "looking for",
    "career opportunities",
    "now hiring",
    "we are hiring",
    "open role",
    "open position",
]

# German / French equivalents (Swiss / EU insiders often post in the local
# language). Added when --eu is passed.
EU_PHRASES = [
    "wir stellen ein",   # we're hiring (DE)
    "wir suchen",        # we're looking for (DE)
    "nous recrutons",    # we're hiring (FR)
    "nous recherchons",  # we're looking for (FR)
    "rejoignez notre équipe",  # join our team (FR)
]


def _quote(s: str) -> str:
    """Wrap a term in straight double quotes for exact-phrase matching."""
    return '"' + s.replace('"', "") + '"'


def build_keyword_queries(fields, phrases, quoted_extras=None, soft_extras=None):
    """Cartesian product of (hiring phrase) x (target field). `quoted_extras`
    (e.g. remote) are appended as exact-quoted constraints; `soft_extras`
    (e.g. a country) are appended unquoted so they widen rather than over-filter.
    Phrase is the outer loop so capping keeps a diverse set of phrases."""
    quoted_extras = quoted_extras or []
    soft_extras = soft_extras or []
    tail = ""
    if quoted_extras:
        tail += " " + " ".join(_quote(t) for t in quoted_extras)
    if soft_extras:
        tail += " " + " ".join(soft_extras)
    queries = []
    for phrase in phrases:
        for field in fields:
            queries.append(f"{_quote(phrase)} {_quote(field)}{tail}".strip())
    return queries


def linkedin_url(query: str) -> str:
    """LinkedIn content (Posts) search, filtered to the past week, sorted recent."""
    params = urllib.parse.urlencode(
        {"keywords": query, "datePosted": '"past-week"', "sortBy": '"date_posted"'},
        quote_via=urllib.parse.quote,
    )
    return "https://www.linkedin.com/search/results/content/?" + params


def google_url(query: str) -> str:
    """Google, restricted to public LinkedIn posts, past week (tbs=qdr:w).
    A login-free path; note LinkedIn-post indexing is sparse/stale, so this is a
    weak supplement to the logged-in LinkedIn path, not a replacement."""
    params = urllib.parse.urlencode(
        {"q": f"site:linkedin.com/posts {query}", "tbs": "qdr:w"},
        quote_via=urllib.parse.quote,
    )
    return "https://www.google.com/search?" + params


def x_url(query: str) -> str:
    """X / Twitter search, Latest tab (f=live)."""
    params = urllib.parse.urlencode(
        {"q": query, "f": "live"}, quote_via=urllib.parse.quote
    )
    return "https://x.com/search?" + params


PLATFORMS = {"linkedin": linkedin_url, "google": google_url, "x": x_url}


def build(fields, location=None, remote=False, eu=False, phrases=None,
          platforms=("linkedin", "google", "x"), max_per_platform=8):
    """Return {platform: [{query, url}, ...]} for the given target fields."""
    if phrases is None:
        phrases = list(HIRING_PHRASES)
        if eu:
            phrases += EU_PHRASES
    quoted_extras = ["remote"] if remote else []
    soft_extras = [location] if location else []
    queries = build_keyword_queries(fields, phrases, quoted_extras,
                                    soft_extras)[:max_per_platform]
    out = {}
    for plat in platforms:
        fn = PLATFORMS[plat]
        out[plat] = [{"query": q, "url": fn(q)} for q in queries]
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--field", action="append", required=True, dest="fields",
                    help="target field / role (repeatable), e.g. --field 'machine learning'")
    ap.add_argument("--location", default=None, help="optional soft (unquoted) location term")
    ap.add_argument("--remote", action="store_true", help="append a quoted 'remote' constraint")
    ap.add_argument("--eu", action="store_true", help="also include German / French hiring phrases")
    ap.add_argument("--phrase", action="append", dest="phrases", default=None,
                    help="override all hiring phrases (repeatable)")
    ap.add_argument("--platform", default="linkedin,google,x",
                    help="comma list from: linkedin, google, x")
    ap.add_argument("--max-per-platform", type=int, default=8,
                    help="cap the number of searches per platform (default 8)")
    ap.add_argument("--json", action="store_true", help="emit JSON instead of markdown")
    args = ap.parse_args()

    platforms = [p.strip() for p in args.platform.split(",")
                 if p.strip() in PLATFORMS]
    if not platforms:
        ap.error("no valid --platform (choose from linkedin, google, x)")

    result = build(args.fields, location=args.location, remote=args.remote,
                   eu=args.eu, phrases=args.phrases, platforms=platforms,
                   max_per_platform=args.max_per_platform)

    if args.json:
        print(json.dumps({"fields": args.fields, "location": args.location,
                          "remote": args.remote, "eu": args.eu, "platforms": result},
                         ensure_ascii=False, indent=2))
        return

    print(f"# Insider hiring-post searches  (fields: {', '.join(args.fields)})")
    print("# DRAFTS ONLY: open these, read results, you send any comment/DM/connect.\n")
    for plat, items in result.items():
        print(f"## {plat.upper()}  ({len(items)} searches)")
        for it in items:
            print(f"- `{it['query']}`\n  {it['url']}")
        print()


if __name__ == "__main__":
    main()
