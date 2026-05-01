#!/usr/bin/env python3
"""Download every photo from a public SmugMug album.

Delegates to ``gallery-dl``, which tracks SmugMug's gallery layout
and handles original-size downloads, retries, and resume on rerun.

Usage::

    pip install gallery-dl
    python scripts/download_smugmug_album.py \\
        https://jerrymeyerstudioli.smugmug.com/Bruh-Goldrich/n-SXTL2W \\
        --dest downloads/bruh-goldrich
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("url", help="Public SmugMug album URL")
    parser.add_argument(
        "--dest",
        default="downloads",
        help="Output directory (default: ./downloads)",
    )
    args = parser.parse_args()

    if shutil.which("gallery-dl") is None:
        sys.stderr.write(
            "gallery-dl not found. Install it with: pip install gallery-dl\n"
        )
        return 1

    Path(args.dest).mkdir(parents=True, exist_ok=True)
    return subprocess.call(["gallery-dl", "--dest", args.dest, args.url])


if __name__ == "__main__":
    raise SystemExit(main())
