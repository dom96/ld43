import os

import csfml

import utils

type
  World* = ref object
    bgTexture*: Texture
    bgSprite*: Sprite

proc newWorld*(): World =
  result = World(
    bgTexture: newTexture(getAssetsDir() / "bg.png"),
    bgSprite: newSprite()
  )
  result.bgSprite.texture = result.bgTexture

proc draw*(world: World, target: RenderWindow) =
  target.drawScaled(world.bgSprite)