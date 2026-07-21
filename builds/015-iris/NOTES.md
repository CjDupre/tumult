# 015 — iris

**date** 2026-07-20 · **lineage** 014-speedpaint · **status** alive

014's painter, dosed. The eye lineage completes: pupil (011) saw,
engram (012) remembered, iris — the rainbow goddess — hallucinates.
Three psychedelic layers, every one a slow drift (the no-strobe rule
holds even on acid):

1. **analog video feedback** — the canvas carry-forward is no longer
   a copy: each frame the painting's history zooms, rotates, melts
   under a slow noise warp, and rotates hue. History becomes spiral
   rainbow trails; the painter keeps repainting reality on top, so
   the subject perpetually re-emerges from its own dissolution.
2. **synesthetic color** — stroke hue is rotated by a sine of the
   stroke's VALUE (luminance banding, i.e. live solarization) plus a
   global spectral phase; edge strokes get an extra half-turn toward
   their complement, so contours vibrate the way staring too long
   makes them.
3. **display chemistry** — radial chromatic aberration and a hard
   chroma lift.

## knobs

| knob            | value    | feel                                 |
|-----------------|----------|---------------------------------------|
| feedback zoom   | ~0.0016/f| how fast history spirals away         |
| feedback rotate | ~0.0018/f| the twist of the trails               |
| melt amplitude  | 0.0035   | how liquid the past is                |
| hue drift       | 0.007/f  | full spectrum in ~15 s of history     |
| band frequency  | 8.5      | how many hue bands share the frame    |
| chroma lifts    | 1.45/1.35| courage                               |

## field notes

- psychedelic ≠ random rainbow: every hue here is a *function* —
  value bands choose hue, edges choose complements, history carries
  its spectral age. Structure is what separates lysergic from lurid.
- the feedback warp does double duty: it also solved 013's "dirtier
  over time" ailment for good, because the melt slowly digests any
  stale paint and the error-driven painter re-covers it. Perpetual
  self-cleaning, disguised as a hallucination.
- hue rotation about the luminance axis (Rodrigues around (1,1,1)/√3)
  is three lines and needs no colorspace conversion.
- all three layers ride existing machinery: the feedback is the copy
  pass, the synesthesia is a stroke-color line, the aberration is two
  extra display taps. Psychedelia as seasoning, not architecture.

## next

- audio-reactive phase: 008's mic bands driving hue-band frequency
  and melt amplitude — the colors listen
- kaleidoscope mode on drag: reflect the feedback warp across n
  pointer-set axes
- the diffusion bridge still stands: hallucinated flora through a
  local img2img model, painted by this brush, melted by this feedback
