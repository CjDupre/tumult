# 006 — hyphae

**date** 2026-07-20 · **lineage** 005-nebula · **status** alive

Two rival slime molds — 1,048,576 agents split down the middle — share
one glass ball. Each agent smells the pheromone volume ahead of it,
turns toward its own kind's trail and away from the other's, and walks.
Everything you see is their negotiation: glowing highways, contested
frontiers, territory. This build fuses the repo's two lineages — the
million-particle state textures of 004/005 with 003's raymarching —
and realizes 005's "deposit into a 3-D texture" idea as an organism.

## technique

- **Jones physarum, lifted to 3-D**: per agent, five sniffs of the
  trail volume (forward + four tilted around a local frame built from
  the heading), score = own smell − `REPEL` × rival smell, turn toward
  the winner, walk, deposit. That loop is the entire organism.
- **3-D volume in a 2-D texture**: 192³ voxels tiled as 16×12 slices
  of 192² in one 3072×2304 RG16F texture (R = species one's pheromone,
  G = the other's). Deposit is attribute-less points: `gl_VertexID` →
  agent texel → voxel → tile pixel, additive blend.
- **separable 3-D diffusion**: three blur passes; X and Y stay inside
  a slice, Z hops between tiles. Decay rides the last pass.
- **volumetric render**: raymarch the sphere, manual trilinear (two
  slices, hardware bilinear inside each — safe because the colony
  never touches tile borders), per-species emission palettes, and a
  3-tap shadow march toward the light so the network shades itself.
  Rendered at ¾ resolution into an HDR target; volumetrics forgive it.
- agent state is the same MRT ping-pong as 005 (pos + heading,
  RGBA32F), species stored in position's free w.

## knobs

| knob          | value | feel                                             |
|---------------|-------|--------------------------------------------------|
| `SENSE_D`     | 0.045 | mesh size of the network (~9 voxels)             |
| `TURN`        | 0.42  | commitment; low = drunkards, high = tram rails   |
| `JITTER`      | 0.09  | wanderlust — keeps highways alive, feeds branches|
| `REPEL`       | 1.6   | xenophobia; drives the territorial segregation   |
| `DEPOSIT`     | 0.10  | vs `DECAY` 0.90 — sets trail mortality           |
| `ABSORB`      | 0.035 | low = glowing translucent; high = matte clay     |

## field notes

- **agent-per-voxel density is the master knob.** At 128³ the swarm was
  50% of voxel count and everything fused into fat play-doh blobs; at
  192³ (14%, right in Jones' 6–15% band) the same rules made fine
  entwined strands. Resolution didn't sharpen the picture — it changed
  the *morphology*. When physarum looks wrong, resize the world, not
  the rules.
- the render was the second half of the fight: with high absorption the
  colony read as matte clay ropes. Cutting `ABSORB` ~3× and letting
  light pass *through* the medium (plus white-hot emission cores) is
  what turned tissue into bioluminescence.
- segregation is not programmed — both species start intermixed in one
  small cloud. `REPEL` alone unmixes them into interlocking territories
  within a few hundred ticks.
- 192 is not a power of two: every `& 127` / `>> 7` tile trick had to
  become honest integer div/mod. Worth it — voxel count beat bit hacks.
- physarum needs no respawn: unlike 004/005, agents never die. The
  colony is conserved; only the trails are mortal.

## next

- food: mouse ray drops nutrient into a third channel both species
  crave — watch them race, and fight over it
- asymmetric species (one faster, one stickier) — predator/prey
  dynamics instead of a fair war
- obstacle SDF inside the ball the colony must route around — physarum
  is a maze solver; give it a maze
