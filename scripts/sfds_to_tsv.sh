#!/usr/bin/env bash
#
# Converts sound definitions to TSV format.
#
# Usage:
#   ./convert.sh <input.txt> > output.tsv
#
# Or:
#   cat input.txt | ./convert.sh > output.tsv
#
# Input format:
#   <event> <volume> <sound1> <sound2> ...
#
# Output format:
#   event<TAB>volume<TAB>sound
#
# Each sound is written as a separate row.
#

echo -e "event\tvolume\tsound"

while read -r event volume sounds; do
    [[ -z "$event" ]] && continue

    for sound in $sounds; do
        printf "%s\t%s\t%s\n" "$event" "$volume" "$sound"
    done
done < "${1:-/dev/stdin}"