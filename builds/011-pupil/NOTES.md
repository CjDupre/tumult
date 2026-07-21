# 011 — pupil

**date** 2026-07-20 · **lineage** 010-archive · **status** alive

A 4,851-parameter neural network — Fourier features → 48 → 48 → RGB —
training live in this tab by real backprop with an in-shader Adam
optimizer.
Forward passes, backward deltas, and weight updates are all fragment
shaders; there is no library and no pretrained anything. Each frame
the network gets six steps of 1,024 random glimpses of a world it
never sees whole. **The image on screen is not the world — it is the
network's current belief about the world**, forever a few thousand
gradients behind. The falling sparks are its training samples, bright
where it is most wrong. The world drifts (move the pointer to stir
it), so belief never catches truth. Click once and the world becomes
your camera: it will chase your face and never quite arrive.

## technique

- **backprop as render passes**: ten small passes per training step —
  batch coords → Fourier features → two dense forwards → output error
  δ₃ (target sampled per-glimpse) → two backward delta passes → three
  SGD passes. Weights live in 33×32 and 33×3 R32F textures (bias in
  the last column), ping-ponged. Gradients are computed inside the
  SGD pass: each weight texel loops the 1,024-sample batch and sums
  δᵢ·aⱼ. No blending, no atomics, no libraries — just texelFetch.
- **the belief pass**: one fragment shader runs the entire network
  per pixel (≈2.3k multiply-adds each) at 55% resolution — beliefs
  are soft, and the upscale agrees with them.
- **training data made visible**: the spark overlay draws the current
  minibatch at its glimpse coordinates, brightness = per-sample loss.
  You are literally watching where SGD is looking, synchronized by
  construction because the sparks *are* the training step.
- deltas clamped ±4 as divergence insurance; Adam lr 2e-3.
- **Adam, in a fragment shader**: per-weight moments m and v live in a
  second render target of the update pass (MRT) — optimizer state is
  just more state-in-texture. Plain SGD learned the blobs in seconds
  and then crawled forever; Adam is why detail arrives at all.
- **the eye gets an EMA**: raw SGD weights jitter at 360 steps/s and the
  belief strobes. The display reads an exponential moving average of
  the weights (α = 0.05) — the optimizer keeps its nerves, the viewer
  gets calm. Same fix as 008's lesson: fast oscillation must render
  as a place, not a flash.
- the fallback world is domain-warped ink in the house palette; the
  webcam replaces it mid-training, and the network repaints itself
  from ink to face without resetting — watching that handover is the
  best moment of the piece.

## knobs

| knob             | value | feel                                        |
|------------------|-------|---------------------------------------------|
| `STEPS_PER_FRAME`| 6     | how fast it learns vs how dreamy it stays   |
| `B`              | 1024  | glimpse count — smaller = jitterier beliefs |
| `LR`             | 2e-3  | Adam units; higher hallucinates             |
| FF max ω         | ~19   | finest detail the eye can ever resolve      |
| world drift      | 0.05  | how fast truth outruns belief               |

## field notes

- **the network paints its dataset — style the dataset.** First run
  the world was a full-hue cosine palette and the output was rainbow
  slop, faithfully learned. Restraining the *world's* palette (ink,
  teal, pale gold) restyled the entire piece without touching the
  model. Data-driven art means art direction happens in the data.
- `blitFramebuffer` refuses float→fixed-point: the belief buffer must
  be RGBA8, which costs nothing since belief is clamped anyway.
- the camera must be cover-cropped to the canvas aspect or the
  network diligently learns a squashed face.
- a 48-wide MLP under-fits on purpose. Under-fitting IS the
  aesthetic: too much capacity and the piece converges into a plain
  screenshot of the target; too little and it stays mud. 4,851
  parameters is a portrait painter with a wide, soft brush.
- keep the training forward pass and the display forward pass
  byte-identical (same hashes, same frequencies) or the belief you
  render is not the belief you trained.
- the belief pass fetches every weight per pixel; at retina res that
  is billions of redundant cached reads a second and it spins fans for
  nothing. Beliefs are soft — render them small (dpr 1, 42% scale) and
  upscale.
- SGD at 480 steps/second on a phone-class integrated GPU would
  struggle; the M-series eats it. This build is the repo's first
  where "AI side of things" means the math, not an API.

## next

- second network that learns the *first network's error field* — a
  critic watching the student, both visible
- Adam optimizer in-shader (two more moment textures) for crisper
  convergence spikes
- audio world: the mic drives the target (008's bands as the image),
  so the pupil paints what it hears
