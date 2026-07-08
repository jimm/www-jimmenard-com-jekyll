#!/bin/bash
#
# Copies resume into _site. Finds the first one in RESUME_LOCS.

HERE="$(cd "$(dirname "$0")" >/dev/null && pwd)"
DEST="${HERE}/../_site/Jim_Menard_resume.pdf"
RESUME_LOCS=(
    "${writing}/resume/Jim_Menard_resume.pdf"
    "${dl}/Jim_Menard_resume.pdf"
    "${dl}/Jim Menard Resume.pdf"
)

mkdir -p "$(dirname "$DEST")"
for path in "${RESUME_LOCS[@]}" ; do
    if [ -f "$path" ] ; then
        cp "$path" "$DEST"
        chmod 644 "$DEST"
        exit 0
    fi
done
echo "warning: no resume found to copy"
