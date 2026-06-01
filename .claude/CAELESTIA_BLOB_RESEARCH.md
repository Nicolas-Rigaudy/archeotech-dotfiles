# Caelestia Blob System — Research Notes

**Source**: `github.com/caelestia-dots/shell` — `/plugin/src/Caelestia/Blobs/`
**Decision**: Not implemented now. Using plain QML Shape/Rectangle (option C). See this doc if we revisit.

---

## Frame sizing / spacing

Caelestia uses one constant for everything: `Config.border.thickness = 10px`.

- Collapsed bar strip width = 10px
- Top / right / bottom content inset = 10px
- Left inset = `bar.implicitWidth` (grows with bar)
- Frame corner rounding = `Config.border.rounding = 25px`
- SDF smoothing / feather radius = `Config.border.smoothing = 32`

When the bar is hidden all four sides are equal 10px → perfectly symmetric frame gap.

---

## What the blob system is

A custom Qt Quick Scene Graph material (`QSGMaterial` + `QSGMaterialShader`) that renders up to 16 signed-distance-field rounded rectangles in a single GLSL pass, with:

1. **Smooth merge (`smin`)** — cubic smooth-min with k=32px. Any two rects within 32px of each other "goo-merge" seamlessly.
2. **Spring physics (`BlobRect`)** — each rect tracks its scene velocity and applies a squash-and-stretch deformation matrix. Stiffness=200, damping=16. When a panel opens/closes and slides in, it squishes organically.
3. **Frame cutout (`BlobInvertedRect`)** — one per screen. Draws a hollow rectangle (outer shell minus inner hole). Includes "border sink" warping so panels merge flush into the frame without a gap.
4. **Per-corner radius reduction** — CPU pre-computes how much each corner is inside a neighbour's SDF zone and shrinks that corner's radius to ~2px there. This is what makes adjacent panels look seamlessly joined.
5. **Ownership masking** — each BlobRect only renders pixels it "owns", so multiple rects can overlap render areas without double-rendering.

### Key constants
| Value | Default |
|---|---|
| `border.thickness` | 10 px |
| `border.rounding` | 25 px |
| `border.smoothing` | 32 |
| `BlobRect` stiffness | 200 |
| `BlobRect` damping | 16 |
| `BlobRect` deformScale | 0.0005 |
| Max rects per group | 16 |

---

## Portability to pure QML

The shader is standard GLSL 300es/330 — no Qt private APIs. Full port is feasible via `ShaderEffect`.

### What maps cleanly
- SDF rounded rect + smin merge → direct GLSL port in `ShaderEffect`
- Per-corner radius → already in shader, just pass as uniform
- Border cutout (inverted rect) → porteable but complex (~100 shader lines)
- Spring physics → QML `NumberAnimation` or a small JS integrator

### What is hard
- Ownership masking (multi-rect partitioning) — needs careful uniform packing
- Passing `vec4[80]` uniform array — QML `ShaderEffect` supports this via `variant` → `QByteArray` UBO, but requires a C++ helper or a QML `ArrayBuffer` workaround
- The physics state machine (velocity tracking, at-rest snap) — doable in QML but verbose

### Effort estimate
- Full faithful port: ~2–3 days
- Single-rect shader (one popup, no merge): ~2–4 hours
- Current approach (plain Rectangle + Shape): already working, zero shader work

### GLSL core (smin + sdRoundedBox4)
```glsl
float sdRoundedBox4(vec2 p, vec2 center, vec2 halfSize, vec4 r) {
    // r = (topRight, bottomRight, bottomLeft, topLeft)
    p -= center;
    r.xy = (p.x > 0.0) ? r.xy : r.wz;
    r.x  = (p.y > 0.0) ? r.y  : r.x;
    vec2 q = abs(p) - halfSize + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

float smin(float a, float b, float k) {
    // Cubic smooth min (C2 continuous)
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * h * k * (1.0/6.0);
}
```

These two functions are the entire visual identity of the Caelestia look. Everything else is bookkeeping.

---

## Files fetched (all verbatim source available in session history)

- `blobmaterial.hpp / .cpp` — QSGMaterial + shader uniform packing
- `blobshape.hpp / .cpp` — base QQuickItem, polish/paint pipeline
- `blobrect.hpp / .cpp` — spring physics, per-corner radius, exclude list
- `blobinvertedrect.hpp / .cpp` — frame cutout geometry, border sink
- `blobgroup.hpp / .cpp` — group container, spatial dirty propagation
- `shaders/blob.vert` — trivial passthrough vertex shader
- `shaders/blob.frag` — full ~200-line SDF fragment shader
