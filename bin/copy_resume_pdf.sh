#!/bin/bash

HERE="$(cd "$(dirname "$0")" >/dev/null && pwd)"
DEST="${HERE}/../_site/Jim_Menard_resume.pdf"
RESUME="${writing}/resume/Jim_Menard_resume.pdf"
DL_RESUME="${dl}/Jim_Menard_resume.pdf"
DL_RESUME_SPACES="${dl}/Jim Menard Resume.pdf"

mkdir -p "$(dirname "$DEST")"
if [ -f "$RESUME" ] ; then
    cp "$RESUME" "$DEST"
elif [ -f "$DL_RESUME" ] ; then
    cp "$DL_RESUME" "$DEST"
elif [ -f "$DL_RESUME_SPACES" ] ; then
    cp "$DL_RESUME_SPACES" "$DEST"
fi
