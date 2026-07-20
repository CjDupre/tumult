# 007 — undertow

**date** 2026-07-20 · **lineage** 006-hyphae · **status** alive

001 was advection *pretending* to be a fluid. This is one: 262,144
particles of pressure-projected incompressible liquid in a tank that
rolls like a ship's hold — gravity's direction leans on two
incommensurate sine periods, so the water never finds a rest frame.
Flick the pointer to throw it around. Waves break, spray flies
ballistic, folded-in air pockets rise and pop.

## technique

- **FLIP/PIC on a collocated grid**: P2G splats particle velocity and
  weight to a 256-wide grid (attribute-less 3×3 points, additive blend,
  bilinear share computed per covered cell in the fragment shader);
  forces are added on the grid; 50 Jacobi sweeps solve pressure with
  free-surface air cells clamped to p=0 and walls mirroring ∂p/∂n=0;
  the projected velocity returns to particles as a FLIP delta with 10%
  PIC for calm. Pressure warm-starts from the previous frame.
- **density correction in the divergence RHS**: under-dense interior
  cells ask the solve for net inflow (clamped, gentle). Without it the
  liquid inflates ~1.5× and never recovers — projection *preserves*
  volume drift, it cannot undo it.
- **spray is ballistic**: airborne particles have no valid grid data
  (their FLIP delta is zero), so their velocity blends toward a
  particle-side gravity update as the bilerped fluid marker fades.
- **render**: density + speed-weighted density splatted at half res,
  blurred, then shaded — Beer-Lambert depth darkening, gradient
  normals for the specular glint, a glowing meniscus band along the
  D≈threshold contour, and pale mist where the liquid is agitated.

## knobs

| knob        | value | feel                                            |
|-------------|-------|-------------------------------------------------|
| `FLIP`      | 0.90  | 1.0 = lively but noisy, 0.0 = honey             |
| `JACOBI`    | 50    | fewer = springy compressible waves              |
| tilt amps   | 0.35 / 0.15 | how hard the sea rolls the tank           |
| corr gain   | 0.06  | volume restoration; too stiff *boils* the tank  |
| `SEP`       | 0.03  | particle-scale de-clumping (relative gradient!) |
| `VMAX`      | 3.0   | cells/tick cap — keeps splashes inside walls    |

## field notes

- **an anti-clump force on the absolute density gradient is a gas.**
  First run, the liquid boiled into foam that filled the tank. The
  push must be relative to local density (∇w / w), or with ~16
  particles per cell it dwarfs gravity.
- **a lone stray particle is spray, not liquid.** Marking any cell
  with w > 0.12 as fluid made the pressure solve hold foam open
  forever. Threshold at one full particle-weight fixed it.
- **pressure projection cannot restore volume, only preserve it.**
  FLIP noise slowly inflates the liquid; the fix is a density source
  term in the divergence RHS. But only for *interior* cells — surface
  cells are under-dense by definition (half-covered), and correcting
  them injects energy at the surface until the tank boils.
- airborne droplets froze mid-air at first: gravity lived on the grid,
  and the air's grid cells know nothing. Spray needs its own gravity.
- normals deep inside the body shade density noise as speckle — mask
  the normal strength to the surface band and the body turns to glass.
- entrained air pockets weren't designed, but the free-surface solve
  gives them buoyancy for free, so they rise and pop like real bubbles.
  Kept.

## next

- two immiscible liquids of different densities — a lava lamp with
  real dynamics
- solid obstacles (SDF pillars) for the waves to break against
- 3-D FLIP with screen-space surface reconstruction — the tank becomes
  an aquarium
