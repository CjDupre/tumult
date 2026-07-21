# 014 — speedpaint

**date** 2026-07-20 · **lineage** 013-impasto · **status** alive

013's strokes were one sprite, stamped — and it showed. This is a
brush ENGINE, built the way digital painting apps build theirs: every
stroke is a dragged path of spaced soft stamps walked along the
belief's contour field, with pressure taper, per-stroke size,
hardness, and opacity. The engram still learns the world (camera on
click); the painter speedpaints its belief with the concept artist's
oath — big soft opaque washes where the image is flat, small hard
strokes only where edges matter, and a mixer-brush color that loads
at the pickup point and drifts toward what is under the bristles.
Nothing is stamped twice.

## technique

- **the brush is a path**: stamp k of a stroke re-walks k steps along
  the contour direction (perpendicular to the belief's luminance
  gradient), with curvature smoothing so the path arcs like a wrist.
  Direction sign continuity (flip if dot < 0) keeps strokes from
  doubling back. 512 strokes × 14 stamps per frame, one draw call,
  `gl_VertexID` decomposed into (stroke, stamp).
- **edge economy**: size 64→18 px, hardness 1.1→9, opacity .36→.78,
  all keyed to local gradient magnitude. Flat passages get blocking
  washes; edges get accents. This one mapping is most of the look.
- **pressure taper**: a sine envelope over the stamp index scales
  size and opacity — strokes land, swell, and lift.
- error-driven placement and the never-cleared canvas carry over from
  013; matte finish (gentle S-curve + saturation lift), no impasto
  gloss — concept art is flat.

## knobs

| knob          | value    | feel                                    |
|---------------|----------|------------------------------------------|
| `STAMPS`      | 14       | stroke length                            |
| stamp spacing | 0.18×size| below ~0.2 or hard strokes bead into dots|
| size mix      | 64→18 px | blocking vs rendering                    |
| hardness mix  | 1.1→9    | airbrush vs inking pen                   |
| alpha mix     | .36→.78  | timid vs confident                       |
| mixer drift   | 0.45     | how much strokes smear through regions   |

## field notes

- **stamp spacing is the tell.** At 0.3×size, hard small brushes
  render as strings of beads — the exact "obvious loop" complaint.
  Real brush engines space at ~0.15–0.25 of tip size; 0.18 made
  strokes continuous and the stamping invisible.
- confidence is opacity: at wash alpha 0.10 the painting read as
  murky smoke over void. Doubling wash opacity turned the same
  strokes into deliberate blocking. Timidity looks like dirt.
- the gl_PointSize ceiling (64 on some GL stacks) is the real limit
  on wash breadth — bigger washes would need instanced quads.
- curvature smoothing 0.45 → 0.72 was the difference between worms
  and wrists.

## next

- two-pass sessions: underpainting with 3× point-size quads
  (instanced), then rendering passes — a real workflow loop
- stroke direction from a structure tensor (smoothed) instead of raw
  gradient — steadier flow along soft edges
- the diffusion bridge (013's flowers idea): img2img the belief
  through a local model and speedpaint THAT
