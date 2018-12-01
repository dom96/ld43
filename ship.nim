import os

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

  target.drawScaled(sprite)
  sprite.destroy()

proc update*(ship: Ship, updateMultiplier: float) =
  # We don't calculate resultant force to simplify things.
  # But we can later: https://bit.ly/2AFDtkl
  let accel = rotate(vec2(1, 0), ship.rotation) * updateMultiplier * ship.thrust

  ship.speed = ship.speed + accel
  ship.pos = ship.pos + ship.speed



proc thrustUpDown*(ship: Ship, delta: float) =
  ship.thrust += delta
  ship.thrust = min(100, delta)
  ship.thrust = max(0, delta)

proc rotationUpDown*(ship: Ship, delta: float) =
  ship.rotation += delta