# Experiment 1 - Scrolling Texture

Old games used a technique to animate textures where they shifted the sprite one
row or column per frame. An easy/cheesy way to do this is to just produce a set
of sprites that are shifted already and treat them as individual frames.

I want to see if there's a way to do it without duplicating and modifying the
sprite. I'm thinking that ancient platforms (think Commodore C=64 or Apple ][)
wouldn't have the memory to waste for this sort of thing.

The goal is to do this with one draw call, rather than two. I haven't thought
of a way to make this work without doubling the width (or height) of the
sprite, depending on which way you want to rotate.

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

### Graphics

* `character_robot_jump.png` - From Kenny.nl's freely usable
  [Toon Characters 1](https://kenney.nl/assets/toon-characters-1) collection.
* `character_robot_jump-2y.png` - Kenny.nl's robot sprite, tiled using
  `montage` from ImageMagick:

  ``` sh
  montage character_robot_jump.png character_robot_jump.png -tile 1x2 -background none character_robot_jump-2y.png
  ```
