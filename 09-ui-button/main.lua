-- Experiment 9 - UI Button
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'

-- Button class
local Button = Class('Button')

function Button:initialize(x, y, text, resources)
    self.x = x
    self.y = y
    self.text = text
    self.ui_texture = gameResources.images.ui
    self.button_normal = gameResources.quads.button_normal
    self.button_selected = gameResources.quads.button_selected

    local _, _, w, h = self.button_normal:getViewport()
    self.width = w
    self.height = h

    self.font = resources.fonts.variable
    self.text_width = self.font:getWidth(self.text)
    self.text_height = self.font:getHeight()
    self.text_x = (self.width - self.text_width) / 2 -- offset by x,y to draw
    self.text_y = (self.height - self.text_height) / 2

    self.selected = false
    self.intersected = false
end

function Button:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.font)

    if self.selected then
        love.graphics.draw(self.ui_texture, self.button_selected, self.x, self.y)
    else
        love.graphics.draw(self.ui_texture, self.button_normal, self.x, self.y)
    end

    love.graphics.print(self.text, self.x + self.text_x, self.y + self.text_y)

    if self.intersected then
        love.graphics.setColor(0, 1, 0, 1) -- green
        love.graphics.rectangle('line', self.x - 1, self.y - 1, self.width + 2, self.height + 2)
    end
end

function Button:intersects(x, y)
    -- Does x,y intersect with the button?
    if x < self.x or y < self.y then
        return false
    end

    if x > self.x + self.width or y > self.y + self.height then
        return false
    end

    return true
end

function Button:onMouseMove(x, y)
    if not self:intersects(x, y) then
        self.intersected = false
        return
    end

    self.intersected = true
end

function Button:onMousePress(x, y, _)
    if not self:intersects(x, y) then
        return
    end

    -- We're ignoring the button, click with anything.
    self.selected = true
end

function Button:onMouseRelease(x, y, _)
    if not self:intersects(x, y) then
        return
    end

    -- We're ignoring the button, click with anything.
    self.selected = false
end

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
    quads = {},
}

-- Current state of the game.
gameState = {
    ui = {}, -- UI objects
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.fonts.variable = love.graphics.newFont('resources/fonts/LiberationSerif-Bold.ttf', 16)

    gameResources.images.ui = love.graphics.newImage('resources/rpg_gui_v1/RPG_GUI_v1.png')
    gameResources.quads.button_normal = love.graphics.newQuad(11, 124, 289, 59, gameResources.images.ui)
    gameResources.quads.button_selected = love.graphics.newQuad(11, 202, 289, 59, gameResources.images.ui)

    -- Let's make two buttons.
    local gameState = gameState
    local button = Button:new(100, 100, 'Button 1', gameResources)
    table.insert(gameState.ui, button)
    button = Button:new(250, 250, '# Two', gameResources)
    table.insert(gameState.ui, button)
end

function love.draw()
    local gameResources = gameResources
    local gameState = gameState

    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.variable)
    love.graphics.print('Mouse over or click.', 10, 10)

    for i in ipairs(gameState.ui) do
        gameState.ui[i]:draw()
    end
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousemoved(x, y, dx, dy, isTouch)
    local gameState = gameState

    for i in ipairs(gameState.ui) do
        gameState.ui[i]:onMouseMove(x, y)
    end
end

function love.mousepressed(x, y, button, isTouch, presses)
    local gameState = gameState

    for i in ipairs(gameState.ui) do
        gameState.ui[i]:onMousePress(x, y, button)
    end
end

function love.mousereleased(x, y, button, isTouch, presses)
    local gameState = gameState

    for i in ipairs(gameState.ui) do
        gameState.ui[i]:onMouseRelease(x, y, button)
    end
end
