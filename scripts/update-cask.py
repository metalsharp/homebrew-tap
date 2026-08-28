#!/usr/bin/env python3
"""Update the MetalSharp cask from the latest GitHub release metadata."""

from __future__ import annotations

import argparse
import json
import re
import sys
import urllib.request
from pathlib import Path

RELEASE_API = "https://api.github.com/repos/metalsharp/MetalSharp/releases/latest"
CASK = Path(__file__).resolve().parents[1] / "Casks" / "metalsharp.rb"
VERSION_RE = re.compile(r"^v(?P<version>\d+\.\d+\.\d+)$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")


def latest_release() -> tuple[str, str]:
    request = urllib.request.Request(
        RELEASE_API,
        headers={"Accept": "application/vnd.github+json", "User-Agent": "metalsharp-homebrew-tap"},
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        release = json.load(response)

    match = VERSION_RE.fullmatch(str(release.get("tag_name", "")))
    if not match:
        raise RuntimeError(f"latest release has an unsupported tag: {release.get('tag_name')!r}")
    version = match.group("version")
    expected_name = f"MetalSharp-{version}-arm64.dmg"
    asset = next((item for item in release.get("assets", []) if item.get("name") == expected_name), None)
    if asset is None:
        raise RuntimeError(f"latest release is missing {expected_name}")

    digest = str(asset.get("digest", ""))
    if not digest.startswith("sha256:"):
        raise RuntimeError(f"{expected_name} is missing a GitHub SHA-256 digest")
    sha256 = digest.removeprefix("sha256:")
    if not SHA256_RE.fullmatch(sha256):
        raise RuntimeError(f"{expected_name} has an invalid SHA-256 digest")
    return version, sha256


def replace_exact(source: str, pattern: str, replacement: str, label: str) -> str:
    updated, count = re.subn(pattern, replacement, source, count=1, flags=re.MULTILINE)
    if count != 1:
        raise RuntimeError(f"expected exactly one {label} stanza, found {count}")
    return updated


def update_cask(check: bool) -> int:
    version, sha256 = latest_release()
    source = CASK.read_text(encoding="utf-8")
    updated = replace_exact(source, r'^  version "[^"]+"$', f'  version "{version}"', "version")
    updated = replace_exact(updated, r'^  sha256 "[0-9a-f]+"$', f'  sha256 "{sha256}"', "sha256")

    if updated == source:
        print(f"MetalSharp cask is current at {version}")
        return 0
    if check:
        print(f"MetalSharp cask is outdated; latest release is {version}", file=sys.stderr)
        return 1
    CASK.write_text(updated, encoding="utf-8")
    print(f"Updated MetalSharp cask to {version}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="fail instead of modifying an outdated cask")
    return update_cask(parser.parse_args().check)


if __name__ == "__main__":
    raise SystemExit(main())
