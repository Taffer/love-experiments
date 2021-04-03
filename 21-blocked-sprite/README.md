# Experiment 21 - Blocked Sprite

In this experiment, we'll take experiment *17 - Sprite Joystick* and add
some blocks that restrict movement. I was trying to do this as part of a new
lighting Experiment, but it wasn't working, so I decided to simplify a little.

![Experiment 21 - Sprite Joystick](experiment-21.png)

You can run it from this directory with:

```sh
./love .
```

If you're using Sublime Text:

1. Open the project.
1. Under Tools -> Build System, choose "Launch Löve2D". You only need to pick
   the build system once, it's stored in the workspace file.
1. Choose Tools -> Build or press its shortcut (Ctrl+B).

Press Escape to exit the demo.

## Credits

This is written in Lua, using the [LÖVE](https://love2d.org/) 2D game engine. I
didn't know about that until I stumbled on [CS50's Introduction to Game
Development](https://www.edx.org/course/cs50s-introduction-to-game-development).

Check the `.lua` file headers for individual credits; stuff I wrote is released
under the [MIT license](LICENSE.md).

* [middleclass](https://github.com/kikito/middleclass) by Enrique García Cota

### Graphics

* `col.png` - A [column](https://opengameart.org/content/pixel-column), by
  mold, resized and cropped to 32x32.
* `grass.png` - A
  [grass tile](https://opengameart.org/content/grass-tiles-0), by Invincible.
* `LiberationMono-Bold.ttf` - An open source font from the
  [liberationfonts](https://github.com/liberationfonts/liberation-fonts) repo;
  this is licensed under the
  [SIL Open Font License](https://github.com/liberationfonts/liberation-fonts/blob/master/LICENSE).
* [`LPC_Sara`](https://opengameart.org/content/lpc-sara) - Stephen "Redshrike"
  Challener as graphic artist and William.Thompsonj as contributor. Mandi Paugh
  is the original artist of Sara and creator of the
  [OGA](https://opengameart.org/) mascot.
