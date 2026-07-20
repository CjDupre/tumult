#!/usr/bin/env bash
# scaffold the next build:  tools/new-build.sh "title of piece"
# seeds it from the newest build — iterate, don't start over.
set -euo pipefail
cd "$(dirname "$0")/.."

[[ $# -ge 1 ]] || { echo 'usage: tools/new-build.sh "title of piece"' >&2; exit 1; }

title="$*"
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')

last=$(ls builds | sort | tail -1)
next=$(printf '%03d' $(( 10#${last%%-*} + 1 )))
dir="builds/${next}-${slug}"
date=$(date +%Y-%m-%d)

mkdir "$dir"
cp "builds/${last}/index.html" "${dir}/index.html"

cat > "${dir}/NOTES.md" <<EOF
# ${next} — ${title}

**date** ${date} · **lineage** ${last} · **status** sketch

One line on what this piece is.

## technique

-

## knobs

-

## field notes

-

## next

-
EOF

python3 - "$next" "${next}-${slug}" "$title" "$date" "$last" <<'PY'
import json, sys
nid, slug, title, date, last = sys.argv[1:6]
with open('builds.json') as f:
    builds = json.load(f)
builds.append({"id": nid, "slug": slug, "title": title, "date": date,
               "lineage": last, "techniques": [], "blurb": ""})
with open('builds.json', 'w') as f:
    json.dump(builds, f, indent=2)
    f.write('\n')
PY

echo "seeded ${dir} from builds/${last}"
echo "→ edit ${dir}/index.html, fill in ${dir}/NOTES.md, tag it in builds.json"
