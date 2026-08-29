#!/usr/bin/env python3
"""Merge OpenSCAD ASCII STLs into one pre-oriented binary library STL.

This intentionally keeps the source solids as overlapping shells rather than
asking OpenSCAD 2021 to perform an extremely expensive full CGAL union across
hundreds of ventilation apertures. The monolithic core overlaps both face
sheets by 0.15 mm, so normal slicers merge the layer polygons into one physical
piece. No third-party Python packages are required.
"""
from __future__ import annotations

import argparse
import math
import struct
from pathlib import Path

Vec = tuple[float, float, float]
Tri = tuple[Vec, Vec, Vec]


def load_ascii_stl(path: Path) -> list[Tri]:
    verts: list[Vec] = []
    tris: list[Tri] = []
    with path.open("r", encoding="utf-8", errors="strict") as f:
        for line in f:
            line = line.strip()
            if not line.startswith("vertex "):
                continue
            _, xs, ys, zs = line.split()
            verts.append((float(xs), float(ys), float(zs)))
            if len(verts) == 3:
                tris.append((verts[0], verts[1], verts[2]))
                verts.clear()
    if verts:
        raise ValueError(f"Incomplete triangle in {path}")
    if not tris:
        raise ValueError(f"No triangles found in {path}")
    return tris


def rot_y(v: Vec, deg: float) -> Vec:
    a = math.radians(deg)
    c, s = math.cos(a), math.sin(a)
    x, y, z = v
    return (x * c + z * s, y, -x * s + z * c)


def add(v: Vec, dz: float = 0.0) -> Vec:
    return (v[0], v[1], v[2] + dz)


def transform_triangles(
    tris: list[Tri], *, face: str, core_h: float, angle: float
) -> list[Tri]:
    out: list[Tri] = []
    for tri in tris:
        t: list[Vec] = []
        for v in tri:
            if face == "a":
                v = add(v, core_h)
            elif face == "b":
                v = rot_y(v, 180.0)
            elif face != "core":
                raise ValueError(face)
            # Centre the finished tray around the core mid-plane before the
            # shared 45-degree library orientation.
            v = add(v, -core_h / 2.0)
            v = rot_y(v, angle)
            t.append(v)
        out.append((t[0], t[1], t[2]))
    return out


def normal(tri: Tri) -> Vec:
    a, b, c = tri
    ux, uy, uz = b[0]-a[0], b[1]-a[1], b[2]-a[2]
    vx, vy, vz = c[0]-a[0], c[1]-a[1], c[2]-a[2]
    nx = uy*vz - uz*vy
    ny = uz*vx - ux*vz
    nz = ux*vy - uy*vx
    mag = math.sqrt(nx*nx + ny*ny + nz*nz)
    if mag == 0:
        return (0.0, 0.0, 0.0)
    return (nx/mag, ny/mag, nz/mag)


def write_binary_stl(path: Path, tris: list[Tri]) -> None:
    zmin = min(v[2] for tri in tris for v in tri)
    lifted: list[Tri] = [
        tuple((x, y, z - zmin) for x, y, z in tri)  # type: ignore[arg-type]
        for tri in tris
    ]
    header = b"HECATE946 Behn tray one-piece library export"[:80].ljust(80, b" ")
    with path.open("wb") as f:
        f.write(header)
        f.write(struct.pack("<I", len(lifted)))
        for tri in lifted:
            n = normal(tri)
            vals = [*n, *tri[0], *tri[1], *tri[2]]
            f.write(struct.pack("<12fH", *vals, 0))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--face-a", type=Path, required=True)
    ap.add_argument("--face-b", type=Path, required=True)
    ap.add_argument("--core", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--core-h", type=float, required=True)
    ap.add_argument("--angle", type=float, default=45.0)
    ns = ap.parse_args()

    tris: list[Tri] = []
    tris += transform_triangles(load_ascii_stl(ns.face_a), face="a", core_h=ns.core_h, angle=ns.angle)
    tris += transform_triangles(load_ascii_stl(ns.face_b), face="b", core_h=ns.core_h, angle=ns.angle)
    tris += transform_triangles(load_ascii_stl(ns.core), face="core", core_h=ns.core_h, angle=ns.angle)
    ns.out.parent.mkdir(parents=True, exist_ok=True)
    write_binary_stl(ns.out, tris)
    print(f"Wrote {ns.out} ({len(tris):,} triangles)")


if __name__ == "__main__":
    main()
