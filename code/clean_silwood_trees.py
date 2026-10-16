#!/usr/bin/env python3
"""Validate and clean the synthetic Silwood tree survey."""

from __future__ import annotations

import csv
import math
from pathlib import Path
from typing import Iterable


PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "silwood_trees_raw.csv"
RESULTS_DIR = PROJECT_ROOT / "results"

INPUT_FIELDS = [
    "record_id",
    "location",
    "genus",
    "species",
    "distance_m",
    "angle_degrees",
]
ISSUE_FIELDS = ["source_row", "record_id", "reasons"]
OAK_COUNT_FIELDS = ["species", "count"]


def load_records(path: Path = INPUT_PATH) -> list[dict[str, str]]:
    """Read the survey and check its column names."""
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != INPUT_FIELDS:
            raise ValueError(
                f"Expected columns {INPUT_FIELDS}, found {reader.fieldnames}"
            )
        return list(reader)


def validate_record(
    row: dict[str, str],
    source_row: int,
    accepted_ids: set[str],
) -> tuple[dict[str, str] | None, list[str]]:
    """Clean one record, or return the reasons it cannot be used."""
    reasons = []
    record_id = row["record_id"].strip()
    if record_id == "":
        reasons.append("missing record_id")
    elif not (len(record_id) == 5 and record_id.startswith("ST") and record_id[2:].isdigit()):
        reasons.append("invalid record_id")
    elif record_id in accepted_ids:
        reasons.append("duplicate record_id")
    
    allowed_locations = {"silwood bottom": "Silwood Bottom", "nash's field": "Nash's Field", "manor house": "Manor House", "reactor wood": "Reactor Wood"}
    location = row["location"].strip()
    location_key = location.lower()
    if location == "":
        reasons.append("missing location")
    elif location_key not in allowed_locations:
        reasons.append("invalid location")
    else:
        location = allowed_locations[location_key]

    allowed_genera = {"quercus": "Quercus",
                  "acer": "Acer",
                  "betula": "Betula",
                  "fagus": "Fagus",
                  "fraxinus": "Fraxinus"}
    genus = row["genus"].strip()
    genus_key = genus.lower()
    if genus == "":
        reasons.append("missing genus")
    elif genus_key not in allowed_genera:
        reasons.append("invalid genus")
    else:
        genus = allowed_genera[genus_key]

    allowed_species = ["robur",
                       "petraea",
                       "pseudoplatanus",
                       "pendula",
                       "sylvatica",
                       "excelsior"]
    species = row["species"].strip().lower()
    if species == "":
        reasons.append("missing species")
    elif species not in allowed_species:
        reasons.append("invalid species")

    allowed_pairs = [
        ("Quercus", "robur"),
        ("Quercus", "petraea"),
        ("Acer", "pseudoplatanus"),
        ("Betula", "pendula"),
        ("Fagus", "sylvatica"),
        ("Fraxinus", "excelsior")
    ]
    if genus_key in allowed_genera and species in allowed_species:
        if (genus, species) not in allowed_pairs:
            reasons.append("invalid genus/species combination")

    distance_text = row["distance_m"].strip()
    if distance_text == "":
        reasons.append("missing distance_m")
    else:
        try:
            distance = float(distance_text)
        except ValueError:
            reasons.append("invalid distance_m")
        else:
            if not math.isfinite(distance):
                reasons.append("invalid distance_m")
            elif not (0 < distance <= 100):
                reasons.append("distance_m out of range")

    angle_text = row["angle_degrees"].strip()
    if angle_text == "":
        reasons.append("missing angle_degrees")
    else:
        try:
            angle = float(angle_text)
        except ValueError:
            reasons.append("invalid angle_degrees")
        else:
            if not math.isfinite(angle):
                reasons.append("invalid angle_degrees")
            elif not (0 < angle < 90):
                reasons.append("angle_degrees out of range")

    if reasons:
        return None, reasons
    clean_record = {"record_id": record_id,
                    "location": location,
                    "genus": genus,
                    "species": species,
                    "distance_m": str(distance),
                    "angle_degrees": str(angle)}
    return clean_record, reasons


def process_records(
    rows: Iterable[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    """Sort records into accepted rows and issue reports."""
    accepted = []
    issues = []
    accepted_ids = set()
    for source_row, row in enumerate(rows, start=2):
        clean_record, reasons = validate_record(row, source_row, accepted_ids)
        if clean_record is not None: 
            accepted.append(clean_record)
            accepted_ids.add(clean_record["record_id"])
        else:
            issue = {
                "source_row": str(source_row),
                "record_id": row["record_id"].strip(),
                "reasons": "; ".join(reasons)
            }
            issues.append(issue)
    accepted.sort(key=lambda record: record["record_id"])
    return accepted, issues


def summarise_oaks(clean_records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Count accepted oak records by species."""
    counts = {}
    for record in clean_records:
        if record["genus"] == "Quercus":
            species = record["species"]
            if species not in counts:
                counts[species] = 1
            else:
                counts[species] = counts[species] + 1

    oak_counts = []
    for species in sorted(counts):
        summary = {"species": species, "count": str(counts[species])}
        oak_counts.append(summary)
    return oak_counts


def write_csv(
    path: Path,
    fieldnames: list[str],
    rows: Iterable[dict[str, str]],
) -> None:
    """Write rows to a CSV file, replacing an older copy."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Clean the survey and write the three result files."""
    clean_records, issues = process_records(load_records())
    oak_counts = summarise_oaks(clean_records)

    write_csv(
        RESULTS_DIR / "silwood_trees_clean.csv",
        INPUT_FIELDS,
        clean_records,
    )
    write_csv(
        RESULTS_DIR / "silwood_tree_issues.csv",
        ISSUE_FIELDS,
        issues,
    )
    write_csv(
        RESULTS_DIR / "oak_species_counts.csv",
        OAK_COUNT_FIELDS,
        oak_counts,
    )


if __name__ == "__main__":
    main()
