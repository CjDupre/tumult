# 011 — pupil

**date** 2026-07-20 · **lineage** 010-archive · **status** alive

A 2,339-parameter neural network — Fourier features → 32 → 32 → RGB —
training by real stochastic gradient descent, live, in this tab.
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
- deltas clamped ±4 as divergence insurance; lr 0.22 on batch means.
- the fallback world is domain-warped ink in the house palette; the
  webcam replaces it mid-training, and the network repaints itself
  from ink to face without resetting — watching that handover is the
  best moment of the piece.

## knobs

| knob             | value | feel                                        |
|------------------|-------|---------------------------------------------|
| `STEPS_PER_FRAME`| 6     | how fast it learns vs how dreamy it stays   |
| `B`              | 1024  | glimpse count — smaller = jitterier beliefs |
| `LR`             | 0.22  | too high and belief hallucinates rainbow    |
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
- a 32-wide MLP under-fits on purpose. Under-fitting IS the
  aesthetic: too much capacity and the piece converges into a plain
  screenshot of the target; too little and it stays mud. 2,339
  parameters is a portrait painter with a mile-wide brush.
- keep the training forward pass and the display forward pass
  byte-identical (same hashes, same frequencies) or the belief you
  render is not the belief you trained.
- SGD at 360 steps/second on a phone-class integrated GPU would
  struggle; the M-series eats it. This build is the repo's first
  where "AI side of things" means the math, not an API.

## next

- second network that learns the *first network's error field* — a
  critic watching the student, both visible
- Adam optimizer in-shader (two more moment textures) for crisper
  convergence spikes
- audio world: the mic drives the target (008's bands as the image),
  so the pupil paints what it hears
