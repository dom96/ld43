import os, lenientops

import csfml, csfml/ext

import consts, utils, ship

type
  Game = ref object
    window: RenderWindow
    ship: Ship
    updateClock: Clock

proc newGame(): Game =
  result = Game(
    window: newRenderWindow(
      videoMode(int(screenSize[0]*globalScale), int(screenSize[1]*globalScale)),
      "Space Junkies"
    ),
    ship: newShip(),
    updateClock: newClock()
  )

  result.window.framerateLimit = 60

proc draw(game: Game) =
  game.window.clear(Black)
  game.ship.draw(game.window)

  game.window.display()

proc update(game: Game) =
  let updateMultiplier = game.updateClock.restart().asSeconds()

  game.ship.update(updateMultiplier)

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
