import csv
import site


def load_observations(path):
    with open(path, newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))

def parse_count(count_text):
    if count_text == "":
        return None
    if not isinstance(count_text, str):
        raise ValueError("count_text must be text")
    count = int(count_text)
    if count < 0:
        raise ValueError("count_text must be non-negative")
    return count

def summarise_site(rows, site):
    if not isinstance(rows, list):
        raise ValueError("rows must be a list")
    if not isinstance(site, str):
        raise ValueError("site must be text")
    if site == "":
        raise ValueError("site must be non-empty")
    total = 0
    missing = 0
    has_known_count = False
    seen = set()
    for row in rows:
        if not isinstance(row, dict):
            raise ValueError("each row must be a dictionary")
        if set(row) != {"site", "date", "count"}:
            raise ValueError("each row must have exactly the keys 'site', 'date', and 'count'")
        for field in ("site", "date", "count"):
            if not isinstance(row[field], str):
                raise ValueError(f"row[{field!r}] must be text")
        if row["site"] == "" or row["date"] == "":
            raise ValueError("row['site'] and row['date'] must be non-empty")
        count = parse_count(row["count"])
        record = (row["site"], row["date"], row["count"])
        if record in seen:
            continue
        seen.add(record)
        if row["site"] == site:
            if count is None:
                missing = missing + 1
            else:
                total = total + count
                has_known_count = True
    if has_known_count:
        return (total, missing)
    else:
        return (None, missing)

def suggested_total(rows, site):
    total = 0
    seen = set()
    for row in rows:
        record = (row["site"], row["date"], row["count"])
        if record in seen:
            continue
        seen.add(record)
        if row["site"] == site and row["count"] != "":
            total += int(row["count"])
    return total

if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    for site in sorted({row["site"] for row in rows}):
        summary = summarise_site(rows, site)
        print(f"{site}: {summary}")
