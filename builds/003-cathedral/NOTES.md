# 003 — cathedral

**date** 2026-07-19 · **lineage** origin · **status** alive

The first build with no feedback buffer: every pixel shoots a ray into a
signed distance field and walks it until it hits. The field is a mandelbox —
fold space at the walls, invert the middle, scale, repeat ten times — and
its fold scale oscillates slowly, so the whole structure perpetually
dissolves and re-crystallizes. Nothing is modeled; the architecture is one
equation. Drag to orbit.

## technique

- **ray marching** a distance estimator: step forward by the distance to the
  nearest surface, `d < ε` is a hit. 120 steps, ε grows with distance
- **mandelbox DE**: box fold (`clamp(z,-1,1)*2-z`), conditional sphere fold,
  then `z*scale + p`, tracking the running derivative for the distance bound
- **orbit trap** coloring: the minimum `|z|²` across iterations indexes a
  cosine palette — structure gets its color from its own dynamics
- **step-count AO**: rays that struggled to arrive were in crevices —
  `1 - steps/maxSteps` squared is free ambient occlusion
- near-misses accumulate as `exp(-d·14)` glow → atmospheric haze, no fog pass
- tetrahedral normals, sun + sky lighting, distance fog, fresnel rim

## knobs

| knob           | value | feel                                       |
|----------------|-------|--------------------------------------------|
| `BREATH_DEPTH` | 0.34  | how far the fold scale swings — how violently it rebuilds |
| `BREATH_RATE`  | 0.055 | breaths per unit time                      |
| `FOLDS`        | 10    | detail depth (cost is per-pixel × per-step)|
| `ORBIT_RATE`   | 0.045 | camera revolution speed                    |

## field notes

- marching at 0.85× the DE keeps the animated scale from producing
  overstepping artifacts at fold boundaries
- render density capped at 1.25× dpr — ray marching cost is per-pixel;
  retina-full-res × 120 steps × 10 folds is real money even on an M5 Max
- stateless build: it needs no `?warp` support — the image is a pure
  function of time

## next

- interior flythrough: camera on a path *inside* the box, near-clip glow
- soft shadows (a second march toward the sun)
- animate the box-fold limit as well as the scale — different anatomy
