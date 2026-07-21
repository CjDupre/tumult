# 013 — impasto

**date** 2026-07-20 · **lineage** 012-engram · **status** alive

012 kept, as asked; this is its painter. The engram still learns the
world underneath (grids + MLP, live backprop, camera on click) — but
the display is no longer the belief. It is a CANVAS, never cleared,
and ~900 brush strokes a frame that recompose it: each stroke samples
its color from the belief, orients along the image's contours (long
lazy strokes in flat passages, short dabs on edges), and sets its
opacity from the ERROR between canvas and belief — the painter only
reworks what changed. Strokes deposit thickness; the light rakes
across the ridges. When you move, the strokes flock to you.

## technique

- **error-driven repainting**: stroke opacity = how wrong the canvas
  is at that spot (plus a whisper of constant churn). The painting
  chases the belief the way the belief chases the world — a chain of
  three pursuits, each a few seconds behind the last.
- **strokes follow the grain**: orientation = perpendicular to the
  belief's luminance gradient where edges exist, easing into a lazy
  flow field in flat paint. Length and width shrink on edges —
  classic painterly rendering, driven by a live neural field.
- **impasto**: rgb alpha-blends (paint covers paint) while alpha
  ACCUMULATES (blendFuncSeparate) as thickness; the display shades
  thickness ridges with a raking light and gloss. Bristles and ragged
  tips are procedural, per-stroke.
- the canvas carries forward via a copy shader — float blits are not
  portable — and starts as toned ground with paper grain.

## knobs

| knob            | value    | feel                                     |
|-----------------|----------|------------------------------------------|
| strokes/frame   | 896      | patience of the painter                  |
| size mix        | 48→15 px | broad flats vs edge dabs                 |
| churn alpha     | 0.06     | how restless finished passages stay      |
| err threshold   | .035–.28 | how wrong is wrong enough to repaint     |
| bristle freq    | 9        | brush coarseness                         |
| world shadows   | +ultramarine | shadows must never impersonate bare canvas |

## field notes

- **dark paint impersonates bare canvas — twice.** First the painter
  skipped dark regions (error vs dark ground ≈ zero: bare canvas must
  COUNT as wrong). Then, converged, it painted them umber-on-umber and
  I spent an hour hunting a phantom eraser. The fix both times was in
  the palette: shadows are cool ultramarine, never canvas-brown, and a
  readPixels probe beats an hour of staring at screenshots.
- **float32 kills lazy hashes.** hash(id, stepIdx) degrades as
  stepIdx grows — by step ~5,000, fract(bigNumber × step) quantizes
  and stroke positions collapse onto a lattice. Feed hashes bounded
  time (mod 4096) or the piece dies of numerical old age. (011/012
  carry a mild version of this; it only bites after hours.)
- thickness must only accumulate. Making it a bounded moving average
  let low-alpha churn strokes slowly erode the impasto to nothing.
- a structured hash reads as composition: the first position hash put
  strokes on hidden curves — identical feathery clusters every run.
  If randomness has a shape, the audience will see it.

## next

- stroke motion: let strokes advect a little along 001's curl field
  before settling — wet paint that slides
- palette-knife mode: huge flat strokes when error is low, frantic
  small ones when the camera moves — emotional tempo from data
- the "growing flowers" idea: feed the belief through a local
  diffusion model (MLX/ComfyUI img2img) and let the painter paint THAT
  — the bridge from this repo to the machine's big-model side
