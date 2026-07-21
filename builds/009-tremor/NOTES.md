# 009 — tremor

**date** 2026-07-20 · **lineage** 008-nodal · **status** alive

The dataset is real: every M5.5+ earthquake since 1975 — 24,451 events
from the USGS catalog, ten bytes each, baked into the file — replayed
at one day per tick through two functions. A damped wave equation on
the sphere turns each event into rings that propagate and interfere;
a long integral leaves a permanent mark at each epicenter, colored by
depth. **No coastlines are stored anywhere in this build.** Watch for
a few minutes and the plate boundaries of the earth simply appear —
amber where the quakes are shallow, violet where slabs dive deep. The
catalog's last event happened the day this was committed. Drag to
orbit; the date ticks in the corner; fifty-one years loop in five
minutes and the map keeps everything it has learned.

## technique

- **the data**: USGS FDSN catalog, quantized to 10 bytes/event
  (u16 half-days since 1975, u16 lat, u16 lon, u8 magnitude, u8
  depth) → 260 KB of base64. Decoded into a Float32 time array
  (JS-side replay pointer) and an RGBA32F event texture (lat, lon,
  10^(0.65·(M−5.5)), depth) — so event injection is attribute-less
  point drawing with `drawArrays(POINTS, i0, n)` and `gl_VertexID`
  indexing the catalog directly.
- **the wave function**: leapfrog wave equation on a 1024×512 lat-lon
  grid with the spherical metric (φφ term ÷ cos²θ, tan θ drift term),
  cos clamped for CFL sanity and a sponge at the poles where the grid
  pinches. Longitude wraps; REPEAT sampling hides the dateline.
- **the integral**: epicenter splats accumulate forever in a second
  texture, shallow→amber, deep→violet. The map is this buffer.
- **render**: one analytic sphere intersection per pixel — no
  geometry; lat-lon from the surface normal samples both fields.
  Fresnel rim for atmosphere. Recent quakes flare as camera-facing
  sparks (back-face culled by hand in the vertex shader).

## knobs

| knob            | value  | feel                                        |
|-----------------|--------|---------------------------------------------|
| `DAYS_PER_TICK` | 1.0    | replay speed — 51 years ≈ 5¼ minutes        |
| `C2`            | 0.09   | ring speed (hemisphere in ~14 s)            |
| `DAMP`          | 0.998  | ring lifetime                               |
| `ULEAK`         | 0.9995 | wake clearance — see field notes            |
| amp exponent    | 0.65   | how much an M9 outshines an M5.5            |
| mark alpha      | ~0.05  | how many years the map takes to develop     |

## field notes

- **inject displacement, not velocity.** In 2D there is no Huygens
  principle: a velocity impulse leaves a permanent displacement
  plateau, and fifty years of plateaus whited out the whole globe. A
  displacement bump splits into rings and actually dies. One channel
  swap took the piece from ruined to right.
- the depth coloring is not decoration — it is the data speaking:
  violet (deep) only appears where slabs subduct (Tonga, Japan,
  the Andes), so the palette rediscovered geophysics on its own.
- quantizing to 10 bytes/event costs nothing visible: half-day time
  resolution at one-day ticks, ~5 km positional error at M5.5 ring
  scales. 24,451 real events fit in less space than one photograph.
- the catalog is the artwork's own proof of liveness: the final
  event is dated the same day as the commit. Rebuild the b64 blob
  and the piece stays current forever.
- replay + deterministic sim clock means `?warp=13224` is not an
  arbitrary preview moment — it is 2011-03-17, six days after Tōhoku,
  rings still crossing the Pacific.

## next

- great-circle wavefront sharpening: dispersion-compensated ring
  (split u into a few frequency bands with different speeds)
- live feed variant: fetch the past-hour USGS GeoJSON when served
  over http(s), falling back to the baked catalog on file://
- other catalogs entirely — the machinery replays *any* (t, lat,
  lon, magnitude) stream: lightning strikes, ship positions, flights
