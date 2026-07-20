# 004 — ember field

**date** 2026-07-19 · **lineage** 001-ink-flow · **status** alive

1,048,576 particles combed by a drifting noise field, drawn as additive
embers with long fading trails. Filaments of light form where the field
gathers them. No geometry is ever uploaded: positions live in a 1024×1024
float texture the GPU updates itself, and the vertex shader reads each
particle's state by its index. The mouse is a vortex.

## technique

- **state-in-texture particles**: xy = position, zw = velocity, RGBA32F,
  ping-ponged by a fragment shader (same feedback pattern as 001/002 —
  the texel just *means* something different)
- **attribute-less draw**: `drawArrays(POINTS, 0, 2^20)` with an empty VAO;
  `gl_VertexID` → `texelFetch` is the entire vertex pipeline
- three buffers ping-ponging: particle state ×2, trail accumulation ×2;
  trails fade by 0.985/frame, points splat additively, display tone-maps
- hue drifts across *space*, speed only sets brightness — filaments read as
  continuous strokes instead of confetti
- a fraction of particles respawns each frame so the field never fully
  collapses onto its attractors

## knobs

| knob          | value  | feel                                            |
|---------------|--------|-------------------------------------------------|
| `GATHER`      | 0.85   | 0 = pure swirl (uniform fur), 1 = hard clumping |
| `FIELD_SCALE` | 1.3    | filament wavelength                             |
| `DRAG`        | 0.80   | low = hug the field; high = orbit and blur it   |
| `RESPAWN`     | 0.004  | rain of fresh particles                         |
| fade (shader) | 0.985  | trail length                                    |

## field notes

- **curl noise cannot make filaments.** It is divergence-free by
  construction — it advects a uniform particle density into a uniform
  particle density, forever. 001 uses that as a feature (ink that never
  piles up); here it was the bug. Filaments need divergence: an angle
  field (`dir = (cos, sin)(fbm·k)`) gathers particles onto sink lines.
  `GATHER` blends the two.
- high inertia (drag ≈ 0.96) makes particles *orbit* the sink lines and
  blur them out; low inertia (0.80) lets them settle in and the lines
  turn to silk
- positions must be RGBA32F — at 16-bit-half precision a million points
  visibly quantize into a grid
- short trail fades erase the accumulation that makes strands read;
  0.985 ≈ a 66-frame memory was the turning point

## next

- velocity → line segments (draw each particle as a 2-vertex streak)
- deposit into a density map and let density push back (cheap crowding)
- 3D: positions in a volume, project with a slow orbiting camera
