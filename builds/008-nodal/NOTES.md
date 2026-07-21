# 008 — nodal

**date** 2026-07-20 · **lineage** 007-undertow · **status** alive

The first build where the input is *data from the room*: a Chladni
plate. A million grains of sand ride a steel plate vibrating as a
superposition of six standing-wave modes. Sand random-walks hardest
where the plate moves most and slides toward stillness — the glowing
figures are never drawn, they are simply where the shaking stops.
Click once and the mode amplitudes come from your microphone's FFT
(bass rings the coarse figures, treble the fine ones); untouched, an
internal score makes the plate sing to itself. A fingertip on the
plate rattles the sand around it.

## technique

- **modal synthesis, no grid**: plate displacement is analytic —
  `u_i = cos(mπx)cos(nπy) − cos(nπx)cos(mπy)` summed over six (m,n)
  slots with live amplitudes. Displacement *and* gradient come out of
  one loop per grain per tick; there is no simulation lattice at all,
  which makes this the cheapest build in the repo and still the
  million-grain motif.
- **overdamped sand**: no velocity state. Each grain steps
  `−u∇(u)·SLIDE` (gradient descent on u², i.e. toward nodal lines)
  plus a random kick scaled by `|u|` (the plate throws it). Two terms,
  and every classic Chladni behavior emerges — including the slow
  boil of grains trapped at antinode saddle points.
- **sound → geometry**: an AnalyserNode gives six log-spaced band
  energies (80 Hz–6 kHz) with fast attack / slow release; band *i*
  drives mode slot *i*, so pitch literally selects geometry, the same
  mapping a physical plate performs by resonance.
- **warp-safe fallback score**: with no mic (or before the click),
  staggered narrow solo envelopes walk the six modes deterministically
  off the sim clock — which is also what headless capture sees.
- renderer: settled grains (low local `|u|`) burn white-gold, restless
  grains are dim ember dust; the show pass re-evaluates the mode sum
  per pixel and adds a faint blue antinode shimmer — the invisible
  cause behind the visible figure.

## knobs

| knob         | value   | feel                                         |
|--------------|---------|----------------------------------------------|
| `SLIDE`      | 0.00055 | how greedily sand seeks the lines            |
| `SHAKE`      | 0.0045  | line crispness vs dust haze                  |
| `FLOOR`      | 0.00018 | idle tremor — sand never fully dies          |
| `MODES[6]`   | (1,2)…(3,6) | the plate's vocabulary of figures        |
| score period | 54 s    | how long each figure holds the stage         |
| fade         | 0.88    | afterimage length during transitions         |

## field notes

- the antinode regions shade themselves into dark satin "pillows" for
  free: the per-pixel `|u|` shimmer plus vignette reads as soft 3-D
  relief that was never modeled.
- convergence is fast (~10 s), so at any settled moment nearly all
  sand is *on* the lines — between-line dust only exists in the
  seconds after a mode change. The piece lives in those transitions:
  a million grains scattering and re-gathering into a new figure.
- narrow solo envelopes matter: broad overlapping mode amplitudes give
  mushy compound figures. `sin⁶` solos keep one mode leading with one
  humming under it, which is also how a real plate driven by a bow
  behaves.
- `getUserMedia` needs a user gesture, so the mic is claimed on first
  click — and the piece must be complete without it, both for the
  headless preview and for anyone who denies the prompt.

## next

- drive it with a *song* (media element instead of mic) and let beat
  onsets strike the plate like a mallet
- circular plate (Bessel modes) — the classic cymatics look
- 3-D: a vibrating volume with nodal *surfaces*, raymarched like 006
