import os

import csfml, csfml/ext

import utils

const screenSize = (1024, 768)

type
  Game = ref object
    window: RenderWindow

proc newGame(): Game =
  result = Game(
    window: newRenderWindow(videoMode(screenSize[0], screenSize[1]), "LD43")
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
