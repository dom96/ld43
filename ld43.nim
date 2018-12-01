import os, lenientops, strformat

import csfml, csfml/ext

import consts, utils, ship, world

type
  Game = ref object
    window: RenderWindow
    ship: Ship
    world: World
    camera: View
    updateClock: Clock

proc newGame(): Game =
  result = Game(
    window: newRenderWindow(
      videoMode(int(screenSize[0]*globalScale), int(screenSize[1]*globalScale)),
      "Space Junkies"
    ),
    ship: newShip(),
    world: newWorld(),
    camera: newView(),
    updateClock: newClock()
  )

  result.window.framerateLimit = 60

proc draw(game: Game) =
  game.window.clear(Black)
  game.world.draw(game.window, game.camera)
  game.ship.draw(game.window)
  # Debugging:
  let debugText = newText(
    fmt"T: {game.ship.thrust} S: {game.ship.speed} A: {game.ship.acceleration}",
    pixelFont, 8
  )
  debugText.position = vec2(5, 5)
  debugText.color = color(255, 255, 255, 255)
  game.window.drawScaled(debugText)

  game.window.display()

proc update(game: Game) =
  let updateMultiplier = game.updateClock.restart().asSeconds()

  game.camera.center = game.ship.pos
  game.ship.update(updateMultiplier)
  game.world.update(game.ship.pos)

when isMainModule:
  var game = newGame()

  while game.window.open:
    for event in game.window.events:
      if event.kind == EventType.Closed:
        game.window.close()

      if event.kind == EventType.KeyPressed:
        case event.key.code
        of KeyCode.Escape:
          game.window.close()
        of KeyCode.W:
          game.ship.thrustUpDown(1)
        of KeyCode.S:
          game.ship.thrustUpDown(-1)
        of KeyCode.A:
          game.ship.rotationUpDown(1)
        of KeyCode.D:
          game.ship.rotationUpDown(-1)
        else: discard


    game.update()
    game.draw()
