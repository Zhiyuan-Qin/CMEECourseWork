#!/bin/bash
# Author: Zhiyuan Qin
# Script: csvtospace.sh
# Desc: Convert commas to spaces while preserving empty fields.
# Input: One readable CSV file.
# Output: ../results/<input-filename>.txt
# Date: 2026-10-08

if [[ $# -ne 1 ]]; then
    echo "Please provide exactly one argument." >&2
    exit 2
fi

if [[ ! -f "$1" || ! -r "$1" ]]; then
    echo "File $1 does not exist or is not readable." >&2
    exit 1
fi

input_name=$(basename "$1")

output_file="../results/${input_name}.txt"

if ! mkdir -p ../results; then
    echo "Cannot create the results directory." >&2
    exit 1
fi

if ! tr "," " " < "$1" > "$output_file"; then
    echo "Error occurred while converting commas to spaces." >&2
    exit 1
fi
