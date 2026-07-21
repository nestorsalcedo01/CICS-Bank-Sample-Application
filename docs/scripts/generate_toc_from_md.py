#!/usr/bin/env python3
"""
Generate _data/toc.yml from Markdown files in docs/docs/

Usage (run from the docs/ directory):
    python3 scripts/generate_toc_from_md.py

Output:
    _data/toc.yml
"""

import re
from pathlib import Path
import yaml

SECTION_MAPPING = {
    "about-cbsa": "About CBSA",
    "architecture": "Architecture",
    "installation-and-setup": "Installation and Setup",
    "build-and-deploy": "Build and Deploy",
    "modernization": "Modernization Journey",
    "programs": "Program Reference",
    "testing": "Testing",
    "zosconnect": "z/OS Connect EE",
    "reference": "Reference",
}


def get_title(md_file):
    """Extract title from front matter or first H1 heading."""
    try:
        content = md_file.read_text(encoding="utf-8")
        fm = re.search(
            r"^---\s*\n.*?title:\s*(.+?)\s*\n",
            content,
            re.MULTILINE | re.DOTALL,
        )
        if fm:
            return fm.group(1).strip().strip('"').strip("'")
        h1 = re.search(r"^#\s+(.+)$", content, re.MULTILINE)
        if h1:
            return h1.group(1).strip()
    except Exception as e:
        print(f"Warning reading {md_file}: {e}")
    return md_file.stem.replace("-", " ").title()


def collect_md_entries(section_dir, url_prefix):
    """Recursively collect TOC entries, skipping index.md files."""
    entries = []
    for item in sorted(section_dir.iterdir()):
        if item.is_dir():
            sub_url = f"{url_prefix}{item.name}/"
            sub_children = collect_md_entries(item, sub_url)
            if sub_children:
                entries.append({
                    "title": item.name.replace("-", " ").title(),
                    "url": sub_url,
                    "children": sub_children,
                })
        elif item.suffix == ".md" and item.name != "index.md":
            title = get_title(item)
            entries.append({
                "title": title,
                "url": f"{url_prefix}{item.stem}.html",
            })
    return entries


def generate_toc():
    docs_dir = Path("docs")
    if not docs_dir.exists():
        print("ERROR: docs/ folder not found. Run this script from the docs/ directory.")
        return

    toc = [{"title": "Home", "url": "/"}]

    # Use SECTION_MAPPING order for predictable sidebar ordering
    for section_slug, section_title in SECTION_MAPPING.items():
        section_dir = docs_dir / section_slug
        if not section_dir.is_dir():
            print(f"  Skipping (not found): {section_slug}/")
            continue

        url_prefix = f"/docs/{section_slug}/"
        children = collect_md_entries(section_dir, url_prefix)

        section_entry = {"title": section_title, "url": url_prefix}
        if children:
            section_entry["children"] = children

        toc.append(section_entry)
        print(f"  Section: {section_title} ({len(children)} children)")

    output = Path("_data/toc.yml")
    output.parent.mkdir(exist_ok=True)

    with open(output, "w", encoding="utf-8") as f:
        f.write("# Auto-generated TOC\n")
        f.write("# Run: python3 scripts/generate_toc_from_md.py to regenerate\n\n")
        yaml.dump(
            toc,
            f,
            sort_keys=False,
            default_flow_style=False,
            allow_unicode=True,
        )

    print(f"\nGenerated: {output}")


if __name__ == "__main__":
    generate_toc()
