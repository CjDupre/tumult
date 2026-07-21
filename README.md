<div align="center">

# t u m u l t

**real-time generative graphics that never sit still.**

every frame is the last frame, disturbed.

[**live gallery**](https://cjdupre.github.io/tumult/) · [builds](#builds) · [anatomy](#anatomy-of-a-build) · [rules](#the-rules)

<a href="https://cjdupre.github.io/tumult/builds/001-ink-flow/"><img src="builds/001-ink-flow/preview.png" alt="build 001 — ink flow" width="100%"></a>
<sub>a still from build 001 — the live version has never looked like this since</sub>

</div>

---

Nothing here is a video and nothing here is a render. Every piece is a small
GPU program running at your display's refresh rate, feeding its own output
back into itself. Open one, leave it for an hour, and it will be somewhere
it has never been.

## builds

| # | piece | techniques | live | notes |
|---|-------|------------|------|-------|
| 010 | **archive** | data sculpture · projection morphing · real seismic data | [run](https://cjdupre.github.io/tumult/builds/010-archive/) | [notes](builds/010-archive/NOTES.md) |
| 009 | **tremor** | real seismic data · wave equation on a sphere · emergent cartography | [run](https://cjdupre.github.io/tumult/builds/009-tremor/) | [notes](builds/009-tremor/NOTES.md) |
| 008 | **nodal** | chladni figures · audio-reactive · modal synthesis | [run](https://cjdupre.github.io/tumult/builds/008-nodal/) | [notes](builds/008-nodal/NOTES.md) |
| 007 | **undertow** | flip fluid · pressure solve · free surface | [run](https://cjdupre.github.io/tumult/builds/007-undertow/) | [notes](builds/007-undertow/NOTES.md) |
| 006 | **hyphae** | 3d physarum · two species · volumetric raymarch | [run](https://cjdupre.github.io/tumult/builds/006-hyphae/) | [notes](builds/006-hyphae/NOTES.md) |
| 005 | **nebula** | 3d gpu particles · iso-surface filaments · orbiting camera | [run](https://cjdupre.github.io/tumult/builds/005-nebula/) | [notes](builds/005-nebula/NOTES.md) |
| 004 | **ember field** | gpu particles · flow field · additive trails | [run](https://cjdupre.github.io/tumult/builds/004-ember-field/) | [notes](builds/004-ember-field/NOTES.md) |
| 003 | **cathedral** | ray marching · mandelbox · orbit trap | [run](https://cjdupre.github.io/tumult/builds/003-cathedral/) | [notes](builds/003-cathedral/NOTES.md) |
| 002 | **coral bloom** | reaction-diffusion · gray-scott · gradient lighting | [run](https://cjdupre.github.io/tumult/builds/002-coral-bloom/) | [notes](builds/002-coral-bloom/NOTES.md) |
| 001 | **ink flow** | feedback loop · curl noise · advection · cosine palette | [run](https://cjdupre.github.io/tumult/builds/001-ink-flow/) | [notes](builds/001-ink-flow/NOTES.md) |

Every build is one self-contained `index.html` and one `NOTES.md` recording
the technique, the knobs, what was learned, and where it points next. Builds
are never edited after the next one exists — the sequence *is* the changelog.

## the rules

Constraints breed style. Every build must:

1. be a **single html file** — no dependencies, no build step, no network
2. survive being opened straight from `file://`
3. run in **real time** — if it can be a video, it doesn't belong here
4. carry its own `NOTES.md` — a build you can't explain is a build you got lucky on
5. name its **lineage** — which build it was seeded from

## anatomy of a build

The engine of almost everything here is a feedback loop across two
framebuffers — read the previous frame, disturb it, write the next one:

```glsl
vec2 flow = curl(fbm_field(p, uTime));          // a flow field that never repeats
vec3 prev = texture(uPrev, uv - flow * dt).rgb; // advection: inherit from upstream
outColor  = vec4(prev * DECAY + inject(p), 1.0);
```

Because the buffer is never cleared, structure accumulates: history is the
medium. The rest — noise octaves, palettes, tone curves — is seasoning.
Each build's `NOTES.md` documents its particular seasoning.

Stateful builds also accept `?warp=N`, which pre-runs N simulation frames
before first paint — headless browsers can't fast-forward
`requestAnimationFrame`, so each piece knows how to fast-forward itself
(`tools/capture.sh` uses this to shoot the previews).

## running locally

```sh
git clone https://github.com/CjDupre/tumult && cd tumult
open builds/001-ink-flow/index.html   # any build runs from file://
python3 -m http.server                # …or serve the whole gallery at :8000
```

## starting a new build

```sh
tools/new-build.sh "smoke column"
```

This seeds `builds/002-smoke-column/` from the newest build, stubs its
`NOTES.md`, and registers it in `builds.json` (which drives the gallery).
Then: edit one constant, refresh, repeat until it's something else.

## license

[MIT](LICENSE)
