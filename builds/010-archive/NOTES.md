# 010 — archive

**date** 2026-07-20 · **lineage** 009-tremor · **status** alive

009's critique was fair: the globe rendered the data but never
*modulated* it. Here the dataset never changes — the function does.
The same 24,451 earthquakes (identical bytes to 009) become a million
particles, ~43 per event, each carrying its record. Four projections
of that record take turns as the attractor: the **globe** (009's
world, now made of dust), a **time helix** (fifty-one years coiled,
one turn ≈ 6½ years, aftershock sequences tied into knots), the
**magnitude wall** (time × magnitude × depth — the Gutenberg-Richter
wedge draws itself), and a **storm** (the archive dissolved into
turbulence, then recondensed). Every morph sweeps in chronological
order — the oldest records migrate first — so even the transitions
replay the timeline. The replay cursor from 009 still runs
underneath: when a particle's own date comes around, it flares.

## technique

- **projection morphing**: per particle, target =
  `mix(proj_A(record), proj_B(record), s)` where `s` is a smoothstep
  *staggered by the record's own timestamp* — the morph is itself a
  function of the data. Mid-morph, a churn envelope (`s(1−s)`) hands
  the swarm briefly to 005's cross-gradient turbulence, so every
  transition passes through weather.
- **records as particles**: `gl_VertexID % 24451` maps the million
  particles onto the catalog texture; a per-particle hash gives each
  its seat inside the event's cloud, whose radius scales with
  magnitude. Reuses 005's MRT pos/vel ping-pong verbatim.
- **three data dimensions, three color duties**: era → hue (1975
  teal → 2026 amber), depth → pull toward subduction violet,
  replay flare → white heat. In the helix the era gradient becomes
  visible strata; in the globe it distinguishes old faults from
  recently active ones.
- the storm is not decoration: spring force fades to near zero and
  the same fbm-gradient filament flow from 005 takes the swarm —
  the archive literally becomes weather, then remembers itself.

## knobs

| knob            | value | feel                                       |
|-----------------|-------|--------------------------------------------|
| `SEG_LEN`       | 26 s  | attention span per projection              |
| stagger (×0.35) |       | how strongly morphs sweep chronologically  |
| `SPRING`/`DRAG` | .014/.88 | crisp assembly vs drifting dunes        |
| `STORMY`        | 0.009 | how feral the storm and transitions get    |
| helix turns     | 8     | ≈ 6½ years per coil                        |

## field notes

- the helix's knots were not designed: they are aftershock sequences
  — hundreds of events at one place within weeks — pulled into the
  same coil neighborhood. The data ties its own knots.
- monochrome was the first failure: depth alone colors everything
  amber (most quakes are shallow). Splitting color duties across
  *three* data dimensions (era hue, depth pull, replay flare) is what
  made the piece chromatic without inventing anything.
- chronological stagger turns a crossfade into a narrative: you watch
  1975 leave first and 2026 leave last, every single morph.
- 43 particles per record matters — one point per event is a scatter
  plot; a magnitude-scaled cloud per event is a *presence*. The
  M9s arrive in the helix like storms landing on a wire.
- same bytes as 009, zero new data — everything new here is
  modulation. That was the entire point.

## next

- more projections: a Gutenberg-Richter frequency bar-swarm; energy
  cumulative-sum staircase (the M9s become cliffs)
- let the pointer *grab* the swarm mid-morph and smear it
- generalize the loader: any (t, lat, lon, value) CSV → the same
  four dreams; try lightning strikes or a year of commits
