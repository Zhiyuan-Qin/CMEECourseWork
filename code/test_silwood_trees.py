"""Tests for the tree-survey cleaning functions."""

from clean_silwood_trees import validate_record, process_records, summarise_oaks

valid_row = {
    "record_id": "ST901",
    "location": "Manor House",
    "genus": "Quercus",
    "species": "robur",
    "distance_m": "10",
    "angle_degrees": "45"
}

clean_record, reasons = validate_record(valid_row, 2, set())