import os, strformat

import csfml

import utils, consts

type
  Ship* = ref object
    pos*: Vector2f
    rotation*: float # Rotation of 0 is pointed right.
    thrust*: float
    acceleration*: Vector2f
    speed*: Vector2f
    shipTexture*: Texture

proc newShip*(): Ship =
  result = Ship(
    pos: vec2(10, screenSize[1] / 2),
    rotation: 0,
    thrust: 0.0,
    acceleration: vec2(0, 0),
    speed: vec2(0, 0),
    shipTexture: newTexture(getCurrentDir() / "assets" / "ship.png")
  )

proc draw*(ship: Ship, target: RenderWindow) =
  let sprite = newSprite(ship.shipTexture)

  sprite.position = ship.pos
  sprite.rotation = ship.rotation
  sprite.origin = vec2(
    sprite.localBounds.width / 2,
    sprite.localBounds.height / 2
  )

  target.drawScaled(sprite)

  # Debugging:
  let debugText = newText(
    fmt"T: {ship.thrust} S: {ship.speed} A: {ship.acceleration}", pixelFont, 8
  )
  debugText.position = vec2(5, 5)
  debugText.color = color(255, 255, 255, 255)
  target.drawScaled(debugText)

  sprite.destroy()

proc update*(ship: Ship, updateMultiplier: float) =
  # We don't calculate resultant force to simplify things.
  # But we can later: https://bit.ly/2AFDtkl
  ship.acceleration =
    rotate(vec2(1, 0), ship.rotation) * updateMultiplier * ship.thrust

  ship.speed = ship.speed + ship.acceleration
  ship.pos = ship.pos + ship.speed

proc thrustUpDown*(ship: Ship, delta: float) =
  ship.thrust += delta
  ship.thrust = min(100, delta)
  ship.thrust = max(0, delta)

proc rotationUpDown*(ship: Ship, delta: float) =
  ship.rotation += delta*10