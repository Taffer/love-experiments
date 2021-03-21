-- Experiment 13 - Rect Fades
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
    quads = {},
}

-- Current state of the game.
gameState = {
    alpha = 1, -- Current alpha for the overlayed rectangle.
    fade_out = false, -- Are we fading in or out?
    tick = 0
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    io.stdout:setvbuf("no") -- Don't buffer console output.

    local gameResources = gameResources
    gameResources.images.foxgirl = love.graphics.newImage('resources/fox n girl shadows.png')
end

function love.draw()
    local gameState = gameState

    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameResources.images.foxgirl, 0, 0)

    love.graphics.setColor(0, 0, 0, gameState.alpha)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function love.update(dt)
    local gameState = gameState

    gameState.tick = gameState.tick + dt
    if gameState.fade_out then
        gameState.alpha = gameState.alpha - dt
        if gameState.alpha < 0 then
            gameState.alpha = 0
            gameState.fade_out = false
        end
    else
        gameState.alpha = gameState.alpha + dt
        if gameState.alpha > 1 then
            gameState.alpha = 1
            gameState.fade_out = true
        end
    end
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end
