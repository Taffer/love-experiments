-- Experiment 15 - Text Dropshadows
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
    grass_batch = nil,

    variable_height = 0,
    mono_height = 0,
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    local gameState = gameState
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationMono-Bold.ttf', 16)
    gameResources.fonts.variable = love.graphics.newFont('resources/LiberationSerif-Bold.ttf', 16)
    gameState.mono_height = gameResources.fonts.mono:getHeight() * gameResources.fonts.mono:getLineHeight()
    gameState.variable_height = gameResources.fonts.variable:getHeight() * gameResources.fonts.variable:getLineHeight()

    gameResources.images.grass = love.graphics.newImage('resources/grass.png')
    gameResources.quads.grass = love.graphics.newQuad(0, 0, gameResources.images.grass:getWidth(),
        gameResources.images.grass:getHeight(), gameResources.images.grass)

    gameState.grass_batch = love.graphics.newSpriteBatch(gameResources.images.grass, 880)
    gameState.grass_batch:clear()
    for y = 0, 720, 32 do
        for x = 0, (1280 - 32), 32 do
            gameState.grass_batch:add(gameResources.quads.grass, x, y)
        end
    end
end

function love.draw()
    local gameResources = gameResources

    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.draw(gameState.grass_batch)

    -- Variable width font. ---------------------------------------------------
    local y = 10
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.variable)
    love.graphics.print('Plain white text is hard to read on a light background.', 10, y)

    -- Drop-shadow at 0, +1:
    y = y + gameState.variable_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.variable)
    local text = "Single pixel lower drop-shadow, hopefully it's better."
    love.graphics.print(text, 10, y + 1)
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Drop-shadow at +1, +1:
    y = y + gameState.variable_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.variable)
    text = "Single pixel lower-right drop-shadow, hopefully it's better."
    love.graphics.print(text, 11, y + 1)
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Double drop-shadow at 0, +1 and +1, +1
    y = y + gameState.variable_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.variable)
    text = "Double pixel lower and lower-right drop-shadow, hopefully it's better."
    for i = 0, 1 do
        love.graphics.print(text, 10 + i, y + 1)
    end
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Triple drop-shadow at (-1, +1), (0, +1) and (+1, +1)
    y = y + gameState.variable_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.variable)
    text = "Triple pixel lower-left, lower, and lower-right drop-shadow, hopefully it's better."
    for i = -1, 1 do
        love.graphics.print(text, 10 + i, y + 1)
    end
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Go nuts, draw at one pixel all around.
    y = y + gameState.variable_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.variable)
    text = "Four drop-shadows, one in each corner, this is the best."
    for dy = -1, 1, 2 do
        for dx = -1, 1, 2 do
            love.graphics.print(text, 10 + dx, y + dy)
        end
    end
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Mono width font. -------------------------------------------------------
    y = y + gameState.mono_height * 1.5
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Plain white text is hard to read on a light background.', 10, y)

    -- Drop-shadow at 0, +1:
    y = y + gameState.mono_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    text = "Single pixel lower drop-shadow, hopefully it's better."
    love.graphics.print(text, 10, y + 1)
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Drop-shadow at +1, +1:
    y = y + gameState.mono_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    text = "Single pixel lower-right drop-shadow, hopefully it's better."
    love.graphics.print(text, 11, y + 1)
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Double drop-shadow at 0, +1 and +1, +1
    y = y + gameState.mono_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    text = "Double pixel lower and lower-right drop-shadow, hopefully it's better."
    for i = 0, 1 do
        love.graphics.print(text, 10 + i, y + 1)
    end
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Triple drop-shadow at (-1, +1), (0, +1) and (+1, +1)
    y = y + gameState.mono_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    text = "Triple pixel lower-left, lower, and lower-right drop-shadow, hopefully it's better."
    for i = -1, 1 do
        love.graphics.print(text, 10 + i, y + 1)
    end
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)

    -- Go nuts, draw at one pixel all around.
    y = y + gameState.mono_height * 1.5
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    text = "Four drop-shadows, one in each corner, this is the best."
    for dy = -1, 1, 2 do
        for dx = -1, 1, 2 do
            love.graphics.print(text, 10 + dx, y + dy)
        end
    end
    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.print(text, 10, y)
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end
