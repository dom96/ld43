import os, strutils, tables, random, sequtils, strformat

import csfml

import utils, consts

type
  JunkKind = enum
    JunkSatellite, JunkBooster, JunkSatelliteBig

  World* = ref object
    bgTexture*: Texture
    bgSprite*: Sprite

    junkTextures: array[JunkKind, Texture]
    junk*: seq[Junk]

  Junk* = ref object
    junkTexture: Texture
    junkSprite: Sprite
    kind: JunkKind
    name: string

    angularVelocity: float
    velocity: Vector2f

const
  bgScale = 3*globalScale
  bgMoveFactorY = 100_000
  bgMoveFactorX = 1_000
  bgBoundY = (-1000, 1000)
  bgBoundX = (0, 50_000)


const junkNames = {
  JunkSatellite: @[
    "Sputnik 1",
    "ERS 2",
    "Calsphere",
    "PasComSat",
    "Starshine"
  ],
  JunkBooster: @[
    "SpaceX",
    "Electron",
    "Ariane"
  ],
  JunkSatelliteBig: @[
    "ISS",
    "MIR"
  ]

}.toTable()

proc newJunk*(world: World, kind: JunkKind, pos: Vector2f): Junk =
  result = Junk(
    junkTexture: world.junkTextures[kind],
    junkSprite: newSprite(world.junkTextures[kind]),
    kind: kind,
    name: junkNames[kind][rand(junkNames[kind].high)]
  )

  result.junkSprite.position = pos
  result.junkSprite.scale = vec2(2, 2)

proc update*(junk: Junk, updateMultiplier: float) =
  junk.junkSprite.rotation =
    junk.junkSprite.rotation + (junk.angularVelocity * updateMultiplier)

  junk.junkSprite.position = junk.junkSprite.position + junk.velocity

proc draw*(junk: Junk, target: RenderWindow) =
  target.drawScaled(junk.junkSprite)

proc newWorld*(): World =
  result = World(
    bgTexture: newTexture(getAssetsDir() / "bg.png"),
    bgSprite: newSprite()
  )
  result.bgSprite.texture = result.bgTexture
  result.bgSprite.scale = vec2(bgScale, bgScale)
  result.bgSprite.position = vec2(0, screenSize[1] / 2)
  result.bgSprite.origin = vec2(
    0,
    result.bgSprite.localBounds.height / 2
  )

  for kind in JunkKind:
    result.junkTextures[kind] =
      newTexture(getAssetsDir() / toLower($kind) & ".png")

  # Generate random junk
  let junkKinds = toSeq(low(JunkKind) .. high(JunkKind))
  for x in countup(bgBoundX[0], bgBoundX[1], 100):
    for y in countup(bgBoundY[0], bgBoundY[1], 100):
      let r = rand(100.0)
      let prob = (x / bgBoundX[1])*100
      if r < prob:
        result.junk.add(
          newJunk(result, junkKinds[0], vec2(x, y))
        )

  echo("Created ", result.junk.len)

proc draw*(world: World, target: RenderWindow, view: View) =
  target.view = target.defaultView()
  target.drawScaled(world.bgSprite)

  target.view = view
  for junk in world.junk:
    draw(junk, target)

  target.view = target.defaultView()

proc update*(world: World, shipPos: Vector2f, updateMultiplier: float) =
  world.bgSprite.position = vec2(
    -shipPos.x / bgMoveFactorX,
    (screenSize[1] / 2) - (shipPos.y / bgMoveFactorY)
  )

  for junk in world.junk:
    update(junk, updateMultiplier)