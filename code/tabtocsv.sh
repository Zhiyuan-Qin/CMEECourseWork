#!/bin/bash
# Author: Zhiyuan Qin zq725@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files with commas
#       saves the output into a .csv file
# Arguments: 1-> tab delimited file
# Date: Oct 2026

if [[ $# -ne 1 ]]; then
    echo "Please provide exactly one argument." >&2
    exit 2
fi

if [[ ! -f "$1" || ! -r "$1" ]]; then
    echo "File $1 does not exist or is not readable." >&2
    exit 1
fi

echo "Creating a comma delimited version of $1 ..."

input_name=$(basename "$1")

output_file="../results/${input_name}.csv"

if ! mkdir -p ../results; then
    echo "Cannot create the results directory." >&2
    exit 1
fi

if ! tr "\t" "," < "$1" > "$output_file"; then
    echo "Error occurred while converting tabs to commas." >&2
    exit 1
fi

echo "Done!"

exit
