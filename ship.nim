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
    rocketTexture*: Texture

proc newShip*(): Ship =
  result = Ship(
    pos: vec2(10, screenSize[1] / 2),
    rotation: 0,
    thrust: 0.0,
    acceleration: vec2(0, 0),
    speed: vec2(0, 0),
    rocketTexture: newTexture(getCurrentDir() / "assets" / "rocket.png")
  )

proc draw*(ship: Ship, target: RenderWindow) =
  let sprite = newSprite(ship.rocketTexture)

  sprite.position = vec2(screenSize[0] / 2, screenSize[1] / 2)
  sprite.rotation = ship.rotation
  sprite.origin = vec2(
    sprite.localBounds.width / 2,
    sprite.localBounds.height / 2
  )

  target.drawScaled(sprite)

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