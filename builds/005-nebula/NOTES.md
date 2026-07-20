# 005 — nebula

**date** 2026-07-20 · **lineage** 004-ember-field · **status** alive

004's million particles learn depth. Positions live in a volume now, a
slow camera orbits them, and the filaments are no longer painted by an
ad-hoc angle field — they are the intersection curves of two invisible
drifting noise surfaces, which the particles find and stream along.
Drag to orbit, wheel to approach.

## technique

- **MRT ping-pong state**: position and velocity each need xyz now, so
  one texel can't hold both — the sim pass writes two RGBA32F render
  targets (`layout(location=0/1)`) on one framebuffer, ping-ponged as a
  pair. Same feedback pattern as ever, twice as wide.
- **filaments as iso-surface intersections**: two scalar fbm fields
  `a(p)`, `b(p)`. Where `a=0` and `b=0` cross, the two surfaces
  intersect in space curves — 1-D filaments in 3-D, for free. One
  tetrahedral-sampled gradient per field (4 fbm taps each) yields the
  whole force system:
  - *gather* `-(a·∇a + b·∇b)` — gradient descent on `(a²+b²)/2`,
    falls onto the intersection curve and vanishes there (a natural
    spring, no tuning)
  - *flow* `∇a × ∇b` — tangent to both surfaces, so it streams
    particles *along* the filament they gathered onto; also
    divergence-free, the 3-D heir of 001's curl
- **camera on the CPU, projection in the vertex shader**: a proj·view
  mat4 built each frame in JS; `gl_VertexID` still does all the
  geometry. Perspective sets point size, `exp` fog dims the far side —
  the cloud reads as a volume even before it starts to turn.
- trail fade cut to 0.92 (from 004's 0.985): the camera moves, so long
  screen-space trails would smear the volume; short ones read as
  motion blur.
- containment is a soft radial spring past r=1 — the nebula has no
  walls, just reluctance.

## knobs

| knob          | value  | feel                                             |
|---------------|--------|--------------------------------------------------|
| `FIELD_SCALE` | 1.4    | lower = fewer, longer, more sweeping filaments   |
| `GATHER`      | 0.70   | 0 = pure streaming haze, 1 = bare glowing wires  |
| `DRAG`        | 0.86   | low inertia — settle onto the curves             |
| `DRIFT`       | 0.05   | how fast the two surfaces reconfigure            |
| `RESPAWN`     | 0.002  | haze density (newborns haven't converged yet)    |
| fade (shader) | 0.92   | trail length vs volume smearing                  |

## field notes

- in 2-D (004) filaments needed a hand-waved angle field; in 3-D the
  geometry hands you a principled one. Two level sets generically
  intersect in curves, and the same two gradients give both the
  convergence force and the along-filament flow. Fewer knobs, better
  structure.
- `FIELD_SCALE` matters more than anything: at 1.8 the intersection
  curves are short squiggles, at 1.4 they sweep across the whole ball.
- the unconverged respawn haze turned out to be the *body* of the
  nebula — the filaments are only legible because dim fog surrounds
  them. Trimmed `RESPAWN` to tame it, but don't remove it.
- center the fbm properly (subtract its mean, ≈0.44 for 3 octaves of
  value noise) or the iso-surfaces shrink to sparse blobs out in the
  distribution's tail and the filaments never thread the volume.
- a look-at basis with the x-axis flipped doesn't look "wrong", it
  looks *subtly cursed* — the whole scene rolls 180° and every drag
  feels inverted. Derive `cross(up, z)` on paper, not from vibes.

## next

- density-map self-gravity: deposit into a 3-D texture, blur, pull —
  filaments would clump into knots and cores like a real molecular cloud
- velocity-aligned streaks (the 004 line-segment idea survives 3-D)
- fly the camera *through* the volume instead of around it
