# 002 — coral bloom

**date** 2026-07-19 · **lineage** 001-ink-flow · **status** alive

Gray-Scott reaction-diffusion: two chemicals per texel, substrate A and
activator B. B eats A to make more B; A is fed in, B is killed off. Diffusing
at different rates, that tension grows colonies — dark-bellied cells with
luminous membranes that split, merge, and wander. Draw to seed growth;
press R to wipe the dish.

## technique

- same ping-pong feedback machinery as 001, but the state is *chemistry*,
  not color — a separate display pass renders it after the fact
- 18 simulation substeps per frame (RD converges slowly; one step per frame
  reads as frozen)
- **regime ridge**: feed/kill are not mixed independently — most of that
  rectangle is dead (B saturates or starves). Instead a noise field slides
  the parameters along the known pattern-forming ridge from mitosis
  (f=.0367, k=.0649) toward coral (f=.0545, k=.062), so different regions
  of the dish want different growth and the borders churn
- a wandering Lissajous seeder re-inoculates the dish if a regime collapses
- display: the gradient of B becomes a surface normal — key light, specular,
  rim light — so the chemistry reads as wet relief

## knobs

| knob          | value | feel                                                 |
|---------------|-------|------------------------------------------------------|
| `DB`          | 0.5   | B diffusion; the DA:DB ratio sets pattern character  |
| regime ridge  | mitosis→coral | which growth behaviors exist in the dish     |
| `PARAM_DRIFT` | 0.012 | how fast regions change their minds                  |
| `STEPS` (js)  | 18    | simulation speed vs GPU budget                       |

## field notes

- seeding B at full strength locks colony interiors into the stable
  *saturated* state — they fill solid and never stripe. Seed at 0.35.
- picking f/k independently from ranges finds dead zones constantly;
  interpolating along the published pattern ridge never dies.
- **headless Chrome cannot fast-forward rAF** — a 60s `--virtual-time-budget`
  delivers ~4 frames. Every stateful build now takes `?warp=N` and pre-runs
  N frames synchronously before first paint. `tools/capture.sh` uses it.

## next

- spatially varying diffusion (anisotropic laplacian) → directional growth
- feed the mouse velocity into the regime map: stirring changes the biology
- couple two RD systems and let them compete for substrate
