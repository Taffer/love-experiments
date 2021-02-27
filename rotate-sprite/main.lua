-- Experiment 1 - Sprite Rotation
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {}
}

-- Current state of the game.
gameState = {
    tick = 0
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

function love.draw()
end

-- Event generation.
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
