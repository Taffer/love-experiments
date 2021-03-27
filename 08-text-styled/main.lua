-- Experiment 8 - Styled Text
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'

-- Simple class for tracking styled text.
local StyledText = Class('StyledText')

function StyledText:initialize(text, font, colour)
    if #colour ~= 4 then
        print('StyledText created with incorrect colour!')
    end

    self.text = text
    self.font = font
    self.colour = colour -- pass in {r, g, b, a} or draw() will crash
end

function StyledText:getHeight()
    return self.font:getHeight()
end

function StyledText:getWidth()
    return self.font:getWidth(self.text)
end

function StyledText:draw(x, y)
    love.graphics.setColor(self.colour)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, x, y)
end

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
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationMono-Bold.ttf', 16)
    gameResources.fonts.variable = love.graphics.newFont('resources/LiberationSerif-Bold.ttf', 16)

    local gameState = gameState
    gameState.dy = math.max(gameResources.fonts.mono:getHeight(), gameResources.fonts.variable:getHeight())
    gameState.dx = math.max(gameResources.fonts.mono:getWidth('M'), gameResources.fonts.variable:getWidth('M'))
    gameState.max_width = gameState.max_columns * gameState.dx
end

function love.draw()
    local gameResources = gameResources

    local text_x = 100 -- Location of the text area.
    local text_y = 100

    love.graphics.clear(0, 0, 0, 1) -- black

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.variable)
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
        local x_delta = 0
        for i in ipairs(gameState.buff[idx]) do
            gameState.buff[idx][i]:draw(text_x + x_delta, text_y + delta)
            x_delta = x_delta + gameState.buff[idx][i]:getWidth()
        end
        delta = delta + gameState.dy
    end
end

-- Add text to the display buffer.
local function addText(text)
    local gameState = gameState
    local gameResources = gameResources

    -- Split the line into several chunks so we can give them random font and
    -- colour.
    local width = 0
    local pieces = {}
    for i in text:gmatch('%S+') do
        i = i .. ' '
        local font
        if math.random() > 0.5 then
            font = gameResources.fonts.variable
        else
            font = gameResources.fonts.mono
        end
        local rgba = {
            math.random() * 0.5 + 0.5,
            math.random() * 0.5 + 0.5,
            math.random() * 0.5 + 0.5,
            1,
        }

        local styled = StyledText:new(i, font, rgba)

        if width + styled:getWidth() < gameState.max_width then
            table.insert(pieces, styled)
            width = width + styled:getWidth()
        else
            table.insert(gameState.buff, pieces)
            pieces = {styled,}
            width = styled:getWidth()
        end
    end
    if #pieces > 0 then
        table.insert(gameState.buff, pieces)
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
