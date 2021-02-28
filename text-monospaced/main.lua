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
    buff = {}, -- Individual lines of text.
    buff_start = 1, -- Which line to start drawing at.
    max_lines = 5, -- Maximum number of lines to display.

    dy = 16 -- Height of the font.
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

    love.graphics.setColor(0, 0, 0, 1) -- black
    love.graphics.clear()

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Press [Space] to add text.', 10, 10)

    -- Draw the buffer.
    love.graphics.setColor(1, 1, 1, 1) -- white

    local gameState = gameState
    local delta = 0
    for idx = gameState.buff_start, math.min(#gameState.buff, gameState.buff_start + gameState.max_lines) do
        love.graphics.print(gameState.buff[idx], 100, 100 + delta)
        delta = delta + gameState.dy
    end
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        local gameState = gameState
        table.insert(gameState.buff, string.format('More text! %d', #gameState.buff))

        if #gameState.buff > gameState.max_lines then
            gameState.buff_start = gameState.buff_start + 1
        end
    end
end
