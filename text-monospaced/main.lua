-- Experiment 2 - Monospaced Text
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
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationMono-Bold.ttf', 16)
end

function love.draw()
    local gameResources = gameResources

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Hello world!', 100, 100)
end

function love.update(dt)

end

-- Event generation.
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
