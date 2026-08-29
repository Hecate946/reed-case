#!/usr/bin/env python3
"""Dependency-free manifold check for the final library STL.

Checks the actual exported triangle soup, not the OpenSCAD source:
- finite coordinates and non-degenerate triangles
- every welded undirected edge belongs to exactly two triangles
- paired triangles use each shared edge in opposite directions
- all faces belong to one connected component
- positive non-zero enclosed volume
- model is sitting on Z=0 after its print orientation

This is intentionally strict: the export command fails instead of handing a
questionable STL to a slicer.
"""
from __future__ import annotations

import argparse
import math
import struct
from collections import defaultdict, deque
from pathlib import Path

Vec = tuple[float, float, float]
Tri = tuple[Vec, Vec, Vec]


def _ascii_triangles(path: Path) -> list[Tri]:
    verts: list[Vec] = []
    tris: list[Tri] = []
    with path.open("r", encoding="utf-8", errors="strict") as fh:
        for raw in fh:
            line = raw.strip()
            if not line.startswith("vertex "):
                continue
            _, xs, ys, zs = line.split()
            verts.append((float(xs), float(ys), float(zs)))
            if len(verts) == 3:
                tris.append((verts[0], verts[1], verts[2]))
                verts.clear()
    if verts:
        raise ValueError("incomplete triangle at end of ASCII STL")
    return tris


def _binary_triangles(path: Path) -> list[Tri]:
    data = path.read_bytes()
    if len(data) < 84:
        raise ValueError("file is too short to be a binary STL")
    count = struct.unpack_from("<I", data, 80)[0]
    expected = 84 + count * 50
    if len(data) != expected:
        raise ValueError("binary STL length does not match triangle count")
    tris: list[Tri] = []
    off = 84
    for _ in range(count):
        vals = struct.unpack_from("<12fH", data, off)
        off += 50
        tris.append(((vals[3], vals[4], vals[5]),
                     (vals[6], vals[7], vals[8]),
                     (vals[9], vals[10], vals[11])))
    return tris


def load_stl(path: Path) -> list[Tri]:
    # OpenSCAD normally emits ASCII. Detect true binary STLs by their exact
    # header/count-derived byte length so a binary file beginning with 'solid'
    # is still handled correctly.
    data = path.read_bytes()
    if len(data) >= 84:
        count = struct.unpack_from("<I", data, 80)[0]
        if 84 + count * 50 == len(data):
            return _binary_triangles(path)
    return _ascii_triangles(path)


def cross(a: Vec, b: Vec) -> Vec:
    return (a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0])


def sub(a: Vec, b: Vec) -> Vec:
    return (a[0] - b[0], a[1] - b[1], a[2] - b[2])


def dot(a: Vec, b: Vec) -> float:
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]


def validate(path: Path, weld_digits: int = 5) -> None:
    tris = load_stl(path)
    if not tris:
        raise ValueError("STL contains no triangles")

    vertex_id: dict[tuple[float, float, float], int] = {}
    coords: list[Vec] = []

    def vid(v: Vec) -> int:
        if not all(math.isfinite(x) for x in v):
            raise ValueError(f"non-finite vertex: {v}")
        key = tuple(round(x, weld_digits) for x in v)
        if key not in vertex_id:
            vertex_id[key] = len(coords)
            coords.append(v)
        return vertex_id[key]

    edges: dict[tuple[int, int], list[tuple[int, int, int]]] = defaultdict(list)
    neighbours: list[set[int]] = [set() for _ in tris]
    signed_volume6 = 0.0

    for fi, tri in enumerate(tris):
        a, b, c = tri
        ab, ac = sub(b, a), sub(c, a)
        n = cross(ab, ac)
        area2 = math.sqrt(dot(n, n))
        if area2 <= 1e-10:
            raise ValueError(f"degenerate triangle at face {fi}")
        ia, ib, ic = vid(a), vid(b), vid(c)
        if len({ia, ib, ic}) != 3:
            raise ValueError(f"collapsed welded triangle at face {fi}")
        for u, v in ((ia, ib), (ib, ic), (ic, ia)):
            edges[(min(u, v), max(u, v))].append((fi, u, v))
        signed_volume6 += dot(a, cross(b, c))

    bad_edges = [(e, uses) for e, uses in edges.items() if len(uses) != 2]
    if bad_edges:
        counts: dict[int, int] = defaultdict(int)
        for _, uses in bad_edges:
            counts[len(uses)] += 1
        raise ValueError(f"non-manifold/open edges found: {dict(counts)}")

    for edge, uses in edges.items():
        (f0, u0, v0), (f1, u1, v1) = uses
        if not (u0 == v1 and v0 == u1):
            raise ValueError(f"inconsistent winding across edge {edge}")
        neighbours[f0].add(f1)
        neighbours[f1].add(f0)

    seen = {0}
    queue = deque([0])
    while queue:
        f = queue.popleft()
        for n in neighbours[f]:
            if n not in seen:
                seen.add(n)
                queue.append(n)
    if len(seen) != len(tris):
        raise ValueError(
            f"STL has multiple disconnected shells: reached {len(seen)} of {len(tris)} faces"
        )

    volume = signed_volume6 / 6.0
    if volume <= 1e-6:
        raise ValueError(f"non-positive enclosed volume: {volume:.6f} mm^3")

    xs = [v[0] for v in coords]
    ys = [v[1] for v in coords]
    zs = [v[2] for v in coords]
    bounds = (min(xs), min(ys), min(zs), max(xs), max(ys), max(zs))
    if abs(bounds[2]) > 0.02:
        raise ValueError(f"print-oriented STL is not seated at Z=0 (zmin={bounds[2]:.5f})")

    print("STL VALIDATION: PASS")
    print(f"  triangles: {len(tris):,}")
    print(f"  welded vertices: {len(coords):,}")
    print("  manifold: yes (every edge used exactly twice)")
    print("  winding: consistent")
    print("  connected shells: 1")
    print(f"  enclosed volume: {volume:,.2f} mm^3")
    print(
        "  oriented bounds: "
        f"{bounds[3]-bounds[0]:.2f} x {bounds[4]-bounds[1]:.2f} x {bounds[5]-bounds[2]:.2f} mm"
    )


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("stl", type=Path)
    ap.add_argument("--weld-digits", type=int, default=5)
    ns = ap.parse_args()
    validate(ns.stl, ns.weld_digits)


if __name__ == "__main__":
    main()
