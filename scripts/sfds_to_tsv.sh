#!/usr/bin/env bash
#
# Converts sound definitions to TSV format.
#
# Usage:
#   ./sfds_to_tsv.sh <input.txt> > output.tsv
#
# Or:
#   cat input.txt | ./sfds_to_tsv.sh > output.tsv
#
# Input format:
#   <event> <volume> <sound1> <sound2> ...
#
# Output format (one row per event):
#   event<TAB>volume<TAB>sounds
#
# The multiple sound variants of an event are joined with ';' in a single
# cell. Volumes use '.' as the decimal separator. Blank lines and '//'
# comments are skipped.
#

echo -e "event\tvolume\tsounds"

while read -r event volume sounds; do
    event="${event//$'\r'/}"
    volume="${volume//$'\r'/}"
    sounds="${sounds//$'\r'/}"

    [[ -z "$event" ]] && continue
    [[ "$event" == //* ]] && continue

    volume="${volume//,/.}"
    sounds="${sounds// /;}"

    printf "%s\t%s\t%s\n" "$event" "$volume" "$sounds"
done < <(cat "${1:-/dev/stdin}"; echo)
