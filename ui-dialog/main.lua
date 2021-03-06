-- Experiment 6 - UI Dialog
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},

    text = {
        'HONK!',
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

-- Draw a UI around the text area. Co-ords are for the *internal* area, where
-- text is going to be drawn by someone else.
local function draw_ui(x, y, w, h)
    local gameState = gameState

    local honk = gameResources.images.honk
    local honk_scale = 0.25 -- HONK is too big at 282x282
    local honk_width = honk:getWidth() * honk_scale
    local honk_x = x - gameState.margin - honk_width
    local honk_y = y - gameState.margin

    local background = gameResources.images.wood
    local wood_x_scale = (honk:getWidth() * honk_scale + w + 2 * gameState.margin) / background:getWidth()
    local wood_y_scale = math.max(honk:getHeight() * honk_scale + 2 * gameState.margin, h + 2 * gameState.margin)
        / background:getHeight()

    local ui = gameResources.images.ui
    -- These quads are a bit painful, the original isn't set up as a texture
    -- atlas.
    --
    -- top-left corner piece: 856,189, 24x24
    -- top-middle: 893,189, 73x24
    -- top-rignt: 978,189, 24x24
    -- middle-left: 856,227, 24x55
    -- middle-right: 978,227, 24x55
    -- bottom-left: 856,294, 24x24
    -- bottom-middle: 893,294, 73x24
    -- bottom-right: 978,294, 24x24
    local corner_wh = 24
    local middle_width = 73
    local middle_height = 55
    local tl = love.graphics.newQuad(856, 189, corner_wh, corner_wh, ui)
    local tm = love.graphics.newQuad(893, 189, middle_width, corner_wh, ui)
    local tr = love.graphics.newQuad(978, 189, corner_wh, corner_wh, ui)
    local ml = love.graphics.newQuad(856, 227, corner_wh, middle_height, ui)
    local mr = love.graphics.newQuad(978, 227, corner_wh, middle_height, ui)
    local bl = love.graphics.newQuad(856, 294, corner_wh, corner_wh, ui)
    local bm = love.graphics.newQuad(893, 294, middle_width, corner_wh, ui)
    local br = love.graphics.newQuad(978, 294, corner_wh, corner_wh, ui)

    love.graphics.setColor(1, 1, 1, 1)

    -- Draw the background.
    love.graphics.draw(background, honk_x, honk_y, 0, wood_x_scale, wood_y_scale)

    -- HONK!
    love.graphics.draw(honk, honk_x, honk_y, 0, honk_scale, honk_scale)

    -- Draw some decoration.
    local w1 = corner_wh
    local h1 = corner_wh
    local w_scale = (w + honk_width) / middle_width
    local h_scale = h / middle_height
    love.graphics.draw(ui, tl, x - w1 - honk_width, y - h1)
    love.graphics.draw(ui, tm, x - honk_width,      y - h1, 0, w_scale, 1)
    love.graphics.draw(ui, tr, x + w,               y - h1)

    love.graphics.draw(ui, ml, x - w1 - honk_width, y,      0, 1,       h_scale)
    love.graphics.draw(ui, mr, x + w,               y,      0, 1,       h_scale)

    love.graphics.draw(ui, bl, x - w1 - honk_width, y + h)
    love.graphics.draw(ui, bm, x - honk_width,      y + h,  0, w_scale, 1)
    love.graphics.draw(ui, br, x + w,               y + h)
end

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.fonts.variable = love.graphics.newFont('resources/fonts/LiberationSerif-Bold.ttf', 16)
    gameResources.images.honk = love.graphics.newImage('resources/HONK.png')
    gameResources.images.wood = love.graphics.newImage('resources/rpg_gui_v1/wood background.png')
    gameResources.images.ui = love.graphics.newImage('resources/rpg_gui_v1/RPG_GUI_v1.png')

    local gameState = gameState
    gameState.dy = gameResources.fonts.variable:getHeight()
    gameState.dx = gameResources.fonts.variable:getWidth('M')
    gameState.max_width = gameState.max_columns * gameState.dx
end

function love.draw()
    local gameResources = gameResources

    local text_x = 300 -- Location of the text area.
    local text_y = 100

    love.graphics.clear(0, 0, 0, 1) -- black

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.variable)
    love.graphics.print('Press [Space] to add text.', 10, 10)

    draw_ui(text_x - gameState.margin, text_y - gameState.margin,
        gameState.dx * gameState.max_columns, gameState.dy * gameState.max_lines)

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
    local space = gameResources.fonts.variable:getWidth(' ')
    for i in str:gmatch('%S+') do
        if gameResources.fonts.variable:getWidth(tmp_str) + gameResources.fonts.variable:getWidth(i) + space < width then
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
    if gameResources.fonts.variable:getWidth(text) > gameState.max_width then
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
