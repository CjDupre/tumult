# 012 — engram

**date** 2026-07-20 · **lineage** 011-pupil · **status** alive

011 kept, as asked; this is its cure. The pupil could never see
clearly because a plain MLP is nearsighted by construction — so this
build adds the trick that made "NeRF in seconds" possible:
**multiresolution trainable feature grids**. Five grids (24² → 384²)
each store a learned 2-vector per cell; samples gather them
bilinearly, a small MLP turns features into color, and backprop
pushes gradients *through* the MLP *into* the grid cells. ~176,000
parameters training live at ~360 steps/s. Coarse grids converge in a
blink, fine grids etch the detail — the image develops like a
photograph. The grids also decay gently, so the memory fades wherever
the eye stops looking: show it your camera, then look away, and watch
the old scene dissolve.

## technique

- **the encoding is the capacity**: features(p) = bilinear reads from
  five grids (10 numbers) → MLP 10→32→32→RGB. The MLP is tiny; the
  knowledge lives in ~175k grid cells that only train where samples
  land — which is why it's both sharp *and* fast.
- **P2G as backprop**: gradients w.r.t. features scatter into grid
  cells with exactly 007's fluid trick — additive 3×3 point splats
  whose fragment computes the bilinear hat weight. The FLIP machinery
  turned out to be an autograd primitive.
- **Adam everywhere**: per-cell moments ride in a second MRT target
  of the grid update pass; the MLP uses 011's perpetual AdamW
  (decay, fat ε, clamp). Batch 2,048 glimpses × 6 steps/frame.
- EMA copies of every parameter tensor feed the display — the
  no-strobe rule now covers ~176k parameters.
- grid decay 5e-5/step ≈ one-minute half-life: graceful forgetting,
  and it doubles as regularization on a drifting world.

## knobs

| knob         | value  | feel                                          |
|--------------|--------|-----------------------------------------------|
| `LVL`        | 24…384 | coarsest thought … finest detail it can hold  |
| `LR_GRID`    | 0.01   | how fast detail etches in                     |
| `GRID_DECAY` | 0.99995| the forgetting — lower = shorter memory       |
| `B`          | 2048   | glimpses per step                             |
| filigree     | ×18    | the world's sharpness test pattern            |

## field notes

- **raw-coordinate inputs let the MLP be lazy.** With (x, y) offered
  beside the (zero-initialized) features, it learned a smooth picture
  through coordinates and ignored the grids — same blobs as 011.
  Remove the crutch, init the features with noise, and all spatial
  signal is forced into the grids. Architecture is incentive design.
- **a smooth world can't demonstrate sharpness.** After the fix the
  image barely changed — because a two-octave noise world *has* no
  fine detail. The filigree layer (thin ridgelines at 18× frequency)
  exists so the fine grids have something only they can represent.
  Judge a reconstruction on a target worth reconstructing.
- the multi-scale convergence is visible and lovely: blobs at t≈1 s,
  contours by t≈4 s, wire-thin lines by t≈10 s — a developing
  photograph, which is the piece.
- sparse-visit Adam is fine: cells the batch misses coast on decayed
  momentum. 384² cells at 2,048 samples/step means a fine cell trains
  a few times a second, and that is enough.

## next

- the obvious one: a THIRD dimension. Grids in a volume + camera pose
  from the orbit = an actual NeRF in a tab
- let 008's mic bands modulate `GRID_DECAY` per region — sound that
  erases memory
- two engrams, one world, different decay rates — short- and
  long-term memory disagreeing about what they saw
