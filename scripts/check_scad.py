#!/usr/bin/env python3
"""Small dependency-free static checker for this OpenSCAD project."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCAD_ROOT = ROOT / "src"
OPENERS = {"(": ")", "[": "]", "{": "}"}
CLOSERS = {value: key for key, value in OPENERS.items()}


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return re.sub(r"//.*", "", text)


def check_balanced(path: Path, text: str) -> list[str]:
    errors: list[str] = []
    stack: list[tuple[str, int]] = []
    in_string = False
    escaped = False
    for index, char in enumerate(text):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue
        if char == '"':
            in_string = True
        elif char in OPENERS:
            stack.append((char, index))
        elif char in CLOSERS:
            if not stack or stack[-1][0] != CLOSERS[char]:
                errors.append(f"{path}: unmatched {char} at byte {index}")
            else:
                stack.pop()
    for char, index in stack:
        errors.append(f"{path}: unclosed {char} at byte {index}")
    return errors


def check_includes(path: Path, text: str) -> list[str]:
    errors: list[str] = []
    for target in re.findall(r"\b(?:include|use)\s*<([^>]+)>", text):
        resolved = (path.parent / target).resolve()
        if not resolved.is_file():
            errors.append(f"{path}: missing include <{target}>")
    return errors


def main() -> int:
    errors: list[str] = []
    files = sorted(SCAD_ROOT.rglob("*.scad"))
    if not files:
        errors.append("No .scad files found")
    for path in files:
        clean = strip_comments(path.read_text(encoding="utf-8"))
        errors.extend(check_balanced(path, clean))
        errors.extend(check_includes(path, clean))

    required = {
        "base_shell", "lid_shell", "reed_plate", "retainer_strip",
        "hinge_pin", "latch_clip", "render_selected",
    }
    corpus = "\n".join(path.read_text(encoding="utf-8") for path in files)
    for module in sorted(required):
        if not re.search(rf"\bmodule\s+{re.escape(module)}\s*\(", corpus):
            errors.append(f"Missing required module: {module}")

    if errors:
        print("Static checks failed:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    print(f"Static checks passed: {len(files)} OpenSCAD files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

