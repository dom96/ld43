import math

import csfml

import consts

converter toCint*(x: int): cint = x.cint

proc drawScaled*[T](target: RenderWindow, obj: T) =
  let original = obj.scale
  let position = obj.position
  obj.scale = obj.scale * globalScale
  obj.position = position * globalScale
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