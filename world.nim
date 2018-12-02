import os

import csfml

import utils, consts

type
  World* = ref object
    bgTexture*: Texture
    bgSprite*: Sprite

const bgScale = 3*globalScale

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

proc draw*(world: World, target: RenderWindow, view: View) =
  target.view = view

  target.view = target.defaultView()
  target.drawScaled(world.bgSprite)

proc update*(world: World, shipPos: Vector2f) =
  world.bgSprite.position = vec2(
    -shipPos.x / 1000, (screenSize[1] / 2) - (shipPos.y / 10000)
  )