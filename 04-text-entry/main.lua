-- Experiment 2 - Monospaced Text
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
}

-- Current state of the game.
gameState = {
    buff = {},        -- Individual lines of text.

    max_lines = 5,    -- Maximum number of lines to display.
    max_columns = 20, -- Maximum number of columns to display.
    margin = 1,       -- Pixels of margin between the text and its rectangle.

    dy = 0, -- Height of the font.
    dx = 0, -- "Em" width of the font (all characters, as it's monospaced).

    text_idx = 1, -- Index into the text resource.

    text = {}, -- Completed lines of text (you hit Enter).
    cursor = "" -- Incomplete line of text.
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationMono-Bold.ttf', 16)

    local gameState = gameState
    gameState.dy = gameResources.fonts.mono:getHeight()
    gameState.dx = gameResources.fonts.mono:getWidth('M')
end

function love.draw()
    local gameResources = gameResources

    local text_x = 100 -- Location of the text area.
    local text_y = 100

    love.graphics.setColor(0, 0, 0, 1) -- black
    love.graphics.clear()

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Type to add text, press Enter to complete a line.', 10, 10)

    -- Draw a rectangle so we can see if we go over the text area.
    local gameState = gameState
    love.graphics.setColor(0, 1, 0, 1) -- green
    love.graphics.rectangle("line", text_x - gameState.margin, text_y - gameState.margin,
        gameState.dx * gameState.max_columns + gameState.margin * 2, gameState.dy * gameState.max_lines + gameState.margin * 2)

    -- Draw the buffer.
    love.graphics.setColor(1, 1, 1, 1) -- white

    local delta = 0
    local buff_start = 1
    local buff_end = #gameState.buff
    if #gameState.buff >= gameState.max_lines then
        buff_start = buff_end - gameState.max_lines + 2
    end

    for idx = buff_start, buff_end do
        love.graphics.print(gameState.buff[idx], text_x, text_y + delta)
        delta = delta + gameState.dy
    end

    if gameState.cursor:len() > 0 then
        love.graphics.print(gameState.cursor, text_x, text_y + delta)
    end
end

-- Trim whitespace from a string.
local function trim(str)
    return str:match( "^%s*(.-)%s*$" )
end

-- Split a string near width characters.
local function splitAt(str, width)
    local parts = {}
    local tmp_str = ""
    for i in str:gmatch('%S+') do
        if tmp_str:len() + i:len() < width then
            tmp_str = tmp_str .. ' ' .. i
        else
            table.insert(parts, trim(tmp_str))
            tmp_str = trim(i)
        end
    end
    if tmp_str:len() > 0 then
        table.insert(parts, tmp_str)
    end

    return parts
end

-- Add text to the display buffer.
local function addText(text)
    local gameState = gameState

    -- If the line is more than gameState.max_columns, we need to split it.
    if text:len() > gameState.max_columns then
        local parts = splitAt(text, gameState.max_columns)
        for _, v in ipairs(parts) do
            table.insert(gameState.buff, v)
        end
    else
        table.insert(gameState.buff, text)
    end
end

-- Event generation.
function love.keypressed(key)
    if key ~= 'escape' then
        local gameState = gameState

        if key == 'return' then
            table.insert(gameState.buff, gameState.cursor)
            gameState.cursor = ''
        elseif key == 'space' then
            gameState.cursor = gameState.cursor .. ' '
        else
            gameState.cursor = gameState.cursor .. key
        end
    end
end

function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end
