#!/bin/bash

if [[ $# -ne 3 ]]; then
    printf 'Usage: %s input1 input2 output\n' "$0" >&2
    exit 2
fi
cat "$1" > "$3" || exit 1
cat "$2" >> "$3" || exit 1
echo "Merged File is"
cat "$3"