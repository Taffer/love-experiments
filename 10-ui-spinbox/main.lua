-- Experiment 10 - UI Spinbox
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'

-- UI object base class
local UIBase = Class('UIBase')

function UIBase:initialize()
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0

    self.onClick = nil -- I've been clicked!
end

function UIBase:intersects(x, y)
    -- Does x,y intersect with the button?
    if x < self.x or y < self.y then
        return false
    end

    if x > self.x + self.width or y > self.y + self.height then
        return false
    end

    return true
end

function UIBase:onMousePress(x, y)
    if not self:intersects(x, y) then
        return
    end

    -- We're ignoring the button, click with anything.
    if self.onClick then
        self:onClick()
    end
end

-- ImageButton class
local ImageButton = Class('ImageButton', UIBase)

function ImageButton:initialize(x, y, texture, quad)
    self.x = x
    self.y = y
    self.texture = texture
    self.quad = quad

    local _, _, w, h = self.quad:getViewport()
    self.width = w
    self.height = h
end

function ImageButton:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.texture, self.quad, self.x, self.y)
end

-- Label class
local Label = Class('Label', UIBase)

function Label:initialize(x, y, text, font, texture, quad)
    self.x = x
    self.y = y
    self.text = text
    self.font = font
    self.texture = texture
    self.quad = quad

    local _, _, w, h = self.quad:getViewport()
    self.width = w
    self.height = h

    self.text_width = 0
    self.text_height = 0
    self.text_x = 0
    self.text_y = 0

    self:setText(text)
end

function Label:setText(text)
    self.text = text
    self.text_width = self.font:getWidth(self.text)
    self.text_height = self.font:getHeight()
    self.text_x = (self.width - self.text_width) / 2 -- offset by x,y to draw
    self.text_y = (self.height - self.text_height) / 2
end

function Label:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.texture, self.quad, self.x, self.y)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + self.text_x, self.y + self.text_y)
end

-- Spinner class
local Spinner = Class('Spinner', UIBase)

function Spinner:initialize(x, y, values, font, texture, left_quad, label_quad, right_quad)
    self.x = x
    self.y = y

    self.values = values
    self.current_value = 1

    local _, _, left_w,  left_h  = left_quad:getViewport()
    local _, _, label_w, label_h = label_quad:getViewport()
    local _, _, right_w, right_h = right_quad:getViewport()

    self.decrease_button = ImageButton:new(x, y + (label_h - left_h) / 2, texture, left_quad)
    self.decrease_button.onClick = function ()
        self.current_value = self.current_value - 1
        if self.current_value < 1 then
            self.current_value = #self.values
        end

        self.label:setText(self.values[self.current_value])
    end

    self.label = Label:new(x + left_w, y, self.values[self.current_value], font, texture, label_quad)

    self.increase_button = ImageButton:new(x + left_w + label_w, y + (label_h - right_h) / 2, texture, right_quad)
    self.increase_button.onClick = function ()
        self.current_value = self.current_value + 1
        if self.current_value > #self.values then
            self.current_value = 1
        end

        self.label:setText(self.values[self.current_value])
    end

    self.width = left_w + label_w + right_w
    self.height = math.max(label_h, left_h, right_h)
end

function Spinner:draw()
    self.decrease_button:draw()
    self.label:draw()
    self.increase_button:draw()
end

function Spinner:onMousePress(x, y)
    if not self:intersects(x, y) then
        return
    end

    self.decrease_button:onMousePress(x, y)
    self.increase_button:onMousePress(x, y)
end

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
    quads = {},
}

-- Current state of the game.
gameState = {
    spinner = nil
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    io.stdout:setvbuf("no") -- Don't buffer console output.

    local gameResources = gameResources
    gameResources.fonts.variable = love.graphics.newFont('resources/fonts/LiberationSerif-Bold.ttf', 16)

    gameResources.images.ui = love.graphics.newImage('resources/uipack/greenSheet.png')
    gameResources.quads.left_quad  = love.graphics.newQuad(378, 143,  39, 31, gameResources.images.ui)
    gameResources.quads.right_quad = love.graphics.newQuad(339, 143,  39, 31, gameResources.images.ui)
    gameResources.quads.label_quad = love.graphics.newQuad(  0, 192, 190, 45, gameResources.images.ui)

    -- Spinner!
    gameState.spinner = Spinner:new(100, 100, {'Value 1', 'Value Two', 'Three'},
        gameResources.fonts.variable, gameResources.images.ui,
        gameResources.quads.left_quad, gameResources.quads.label_quad, gameResources.quads.right_quad)
end

function love.draw()
    local gameResources = gameResources
    local gameState = gameState

    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.variable)
    love.graphics.print('Mouse click the buttons.', 10, 10)

    gameState.spinner:draw()
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    local gameState = gameState

    gameState.spinner:onMousePress(x, y, button)
end

