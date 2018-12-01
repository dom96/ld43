import os, lenientops

import csfml, csfml/ext

import consts, utils

type
  Game = ref object
    window: RenderWindow

proc newGame(): Game =
  result = Game(
    window: newRenderWindow(
      videoMode(int(screenSize[0]*globalScale), int(screenSize[1]*globalScale)),
      "Space Junkies"
    )
  )

proc draw(game: Game) =
  game.window.clear(Black)

  game.window.display()

when isMainModule:
  var game = newGame()

  while game.window.open:
    for event in game.window.events:
      if event.kind == EventType.Closed or
        (event.kind == EventType.KeyPressed and event.key.code == KeyCode.Escape):
          game.window.close()

    game.draw()
