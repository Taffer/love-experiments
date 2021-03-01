-- Experiment 3 - Variable Width Text
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},

    text = {
        'Next is too long:',
        'The quick brown fox jumps over the lazy dog.',
        'Better split.',
        'That text was too long. What about this line?',
        'Oops, so was that.',
        'We need to fix it.'
    }
}

-- Current state of the game.
gameState = {
    buff = {},        -- Individual lines of text.

    max_lines = 5,    -- Maximum number of lines to display.
    max_columns = 20, -- Maximum number of columns to display.
    max_width = 0,    -- max_columns * the font's em width.
    margin = 1,       -- Pixels of margin between the text and its rectangle.

    dy = 0, -- Height of the font.
    dx = 0, -- "Em" width of the font

    text_idx = 1 -- Index into the text resource.
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationSerif-Bold.ttf', 16)

    local gameState = gameState
    gameState.dy = gameResources.fonts.mono:getHeight()
    gameState.dx = gameResources.fonts.mono:getWidth('M')
    gameState.max_width = gameState.max_columns * gameState.dx
end

function love.draw()
    local gameResources = gameResources

    local text_x = 100 -- Location of the text area.
    local text_y = 100

    love.graphics.setColor(0, 0, 0, 1) -- black
    love.graphics.clear()

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Press [Space] to add text.', 10, 10)

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
    if #gameState.buff > gameState.max_lines then
        buff_start = buff_end - gameState.max_lines + 1
    end

    for idx = buff_start, buff_end do
        love.graphics.print(gameState.buff[idx], text_x, text_y + delta)
        delta = delta + gameState.dy
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
    local gameResources = gameResources
    local space = gameResources.fonts.mono:getWidth(' ')
    for i in str:gmatch('%S+') do
        if gameResources.fonts.mono:getWidth(tmp_str) + gameResources.fonts.mono:getWidth(i) + space < width then
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
    local gameResources = gameResources

    -- If the line is more than gameState.max_width, we need to split it.
    if gameResources.fonts.mono:getWidth(text) > gameState.max_width then
        local parts = splitAt(text, gameState.max_width)
        for _, v in ipairs(parts) do
            table.insert(gameState.buff, v)
        end
    else
        table.insert(gameState.buff, text)
    end
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        local gameState = gameState
        local gameResources = gameResources

        addText(gameResources.text[gameState.text_idx])

        -- Next line of test text, or go back to the start.
        gameState.text_idx = gameState.text_idx + 1
        if gameState.text_idx > #gameResources.text then
            gameState.text_idx = 1
        end
    end
end
