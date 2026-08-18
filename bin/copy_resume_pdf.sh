#!/bin/bash
#
# Copies resume into _site. Finds the first one in RESUME_LOCS.

HERE="$(cd "$(dirname "$0")" >/dev/null && pwd)"
DEST="${HERE}/../_site/Jim_Menard_resume.pdf"
# We assume the copy in the downloads folder is newer than what's in
# $writing/resume.
RESUME_LOCS=(
    "${dl}/Jim_Menard_resume.pdf"
    "${dl}/Jim_Menard_Resume.pdf"
    "${dl}/Jim Menard Resume.pdf"
    "${writing}/resume/Jim_Menard_resume.pdf"
)

mkdir -p "$(dirname "$DEST")"
resume_path="$(ls -1t "${RESUME_LOCS[@]}" 2>/dev/null | head -1)"
if [ -f "$resume_path" ] ; then
    cp "$resume_path" "$DEST"
    chmod 644 "$DEST"
else
    echo "warning: no resume found to copy"
    exit 1
fi
