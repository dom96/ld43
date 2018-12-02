import math, os

import csfml

import consts

converter toCint*(x: int): cint = x.cint

let pixelFont* = newFont(getCurrentDir() / "assets" / "PICO-8.ttf")

proc getAssetsDir*(): string =
  getCurrentDir() / "assets"

proc drawScaled*[T](target: RenderWindow, obj: T) =
  let original = obj.scale
  let position = obj.position
  obj.scale = obj.scale * globalScale
  obj.position = position * globalScale

  # Only draw the object if it's within this target's view.
  let view = target.view
  let viewRect = rect(
    view.center.x - screenSize[0].float, view.center.y - screenSize[1].float,
    screenSize[0].cfloat*2, screenSize[1].cfloat*2
  )
  if viewRect.contains(obj.position):
    target.draw(obj)
  obj.scale = original
  obj.position = position

proc rotate*(vec: Vector2f, deg: float): Vector2f =
  let angRad = degToRad(deg)
  let cos = math.cos(angRad)
  let sin = math.sin(angRad)
  return vec2(
    vec.x * cos - vec.y * sin,
    vec.x * sin + vec.y * cos
  )

proc rotate*(vec: Vector2f, deg: float, origin: Vector2f): Vector2f =
  let angRad = degToRad(deg)
  let cos = math.cos(angRad)
  let sin = math.sin(angRad)
  return vec2(
    ((vec.x - origin.x) * cos) - ((origin.y - vec.y) * sin) + origin.x,
    ((origin.y - vec.y) * cos) - ((vec.x - origin.x) * sin) + origin.y
  )