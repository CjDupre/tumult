# 001 — ink flow

**date** 2026-07-19 · **lineage** origin · **status** alive

Colored ink advected through a curl-noise flow field, accumulated in a
half-float feedback buffer. The image is never cleared — every frame is the
previous frame, disturbed. Mouse stirs the field and deposits hue-cycling
strokes.

## technique

- **feedback loop** — ping-pong RGBA16F framebuffers; the simulation pass
  reads frame *n−1* and writes frame *n*. All apparent motion is this loop.
- **advection** — each pixel samples slightly upstream along the flow field
  and inherits that color. Bilinear filtering provides free diffusion.
- **curl noise** — flow field is the curl of 5-octave value-noise fbm.
  Curl makes it divergence-free: everything swirls, nothing piles up.
- **cosine palette** — `0.5 + 0.5·cos(2π(t + phase))` per channel, both for
  the ambient ink source and the mouse strokes.
- display pass tone-maps with `1 − e^(−1.4c)`, vignette, gamma 2.2.

## knobs

All constants at the top of the `sim-fs` shader:

| knob            | value  | feel                                        |
|-----------------|--------|---------------------------------------------|
| `NOISE_SCALE`   | 2.2    | swirl size — higher = tighter, busier       |
| `FLOW_STRENGTH` | 0.0016 | travel speed — 0.006 is violent churn       |
| `DECAY`         | 0.995  | ink lifetime — 0.97 turns it smoky/ephemeral|
| `DRIFT`         | 0.06   | how fast the field itself morphs            |
| `INK_AMOUNT`    | 0.016  | ambient source strength                     |

## field notes

- Half-float buffers matter: RGBA8 feedback posterizes within seconds as
  repeated decay quantizes toward gray.
- Finite-difference curl with `e = 0.02` in noise space is stable; smaller
  epsilons amplify fbm's high octaves into jitter.
- Decaying mouse velocity between events (`v *= 0.5` per frame) reads as
  momentum without simulating any.

## next

- audio-reactive: FFT bass → `FLOW_STRENGTH`, highs → ink injection
- webcam as the ink source instead of fbm blobs
- store velocity in the buffer's alpha/extra channels → self-advecting flow
  (a real step toward stable-fluids)
