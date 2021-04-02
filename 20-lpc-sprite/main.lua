-- Experiment 14 - Animated Sprite
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'
local LPCSprite = require 'lib/LPCSprite'

-- Actor class
--
-- The actor handles drawing the sprite, moving around, and animation.

local Actor = Class('Actor')
function Actor:initialize(sprite, framerate)
    self.framerate = (framerate or 100) / 1000
    self.ticks = 0
    self.sprite = sprite

    self.sprite:setFacing('away')
    self.sprite:setAnimation('spellcast')
end

function Actor:setFacing(facing)
    self.sprite:setFacing(facing)
end

function Actor:setAnimation(animation)
    self.sprite:setAnimation(animation)
end

function Actor:nextFrame()
    self.sprite:nextFrame()
end

function Actor:update(dt)
    -- Update the animation frames.
    self.ticks = self.ticks + dt

    if self.ticks > self.framerate then
        self:nextFrame()
        self.ticks = self.ticks - self.framerate
    end
end

function Actor:draw(x, y)
    -- Draw the actor's current frame at x,y.
    self.sprite:draw(x, y)
end

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
    quads = {},
}

-- Current state of the game.
gameState = {
    screen_width = love.graphics.getWidth(),
    screen_height = love.graphics.getHeight(),

    sara_sprite = nil,
    sara = nil, -- Our Actor.
    sara_x = 100,
    sara_y = 100,
    sara_animation = 1,

    keys = {}, -- Key states.
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    io.stdout:setvbuf("no") -- Don't buffer console output.

    local gameResources = gameResources
    gameResources.images.grass = love.graphics.newImage('resources/grass.png')
    gameResources.images.sara = love.graphics.newImage('resources/LPC_Sara/SaraFullSheet.png')
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationMono-Bold.ttf', 16)

    gameResources.quads.grass = love.graphics.newQuad(0, 0, gameResources.images.grass:getWidth(),
        gameResources.images.grass:getHeight(), gameResources.images.grass)

    gameState.sara_sprite = LPCSprite:new(gameResources.images.sara)
    gameState.sara = Actor:new(gameState.sara_sprite)

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
    local gameState = gameState

    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameState.grass_batch)

    -- Draw a rectangle to show which tile the actor's feet are in.
    love.graphics.setColor(1, 0, 0, 1)
    local tile_w = gameResources.images.grass:getWidth()
    local tile_h = gameResources.images.grass:getHeight()
    local tile_x = math.floor((gameState.sara_x + gameState.sara_sprite.feet_x) / tile_w) * tile_w
    local tile_y = math.floor((gameState.sara_y + gameState.sara_sprite.feet_y) / tile_h) * tile_h
    love.graphics.rectangle('line', tile_x, tile_y, tile_w, tile_h)

    gameState.sara:draw(gameState.sara_x, gameState.sara_y)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Use WASD or arrow keys to walk, Space to cycle animations.', 10, 10)
end

function love.update(dt)
    local gameState = gameState

    local go_up = gameState.keys['w'] or gameState.keys['up']
    local go_left = gameState.keys['a'] or gameState.keys['left']
    local go_down = gameState.keys['s'] or gameState.keys['down']
    local go_right = gameState.keys['d'] or gameState.keys['right']

    -- Yes this will look weird if you walk around while playing another
    -- animation. The point of this Experiment is just to play through the
    -- animations, not look right.
    if go_up then
        gameState.sara:setFacing('away')

        gameState.sara_y = gameState.sara_y - 1
    end
    if go_down then
        gameState.sara:setFacing('forward')

        gameState.sara_y = gameState.sara_y + 1
    end
    if go_left then
        gameState.sara:setFacing('left')

        gameState.sara_x = gameState.sara_x - 1
    end
    if go_right then
        gameState.sara:setFacing('right')

        gameState.sara_x = gameState.sara_x + 1
    end

    -- Clamp Sara's position.
    if gameState.sara_x < 0 then
        gameState.sara_x = 0
    elseif gameState.sara_x + gameState.sara_sprite.width > gameState.screen_width then
        gameState.sara_x = gameState.screen_width - gameState.sara_sprite.width
    end
    if gameState.sara_y < 0 then
        gameState.sara_y = 0
    elseif gameState.sara_y + gameState.sara_sprite.height > gameState.screen_height then
        gameState.sara_y = gameState.screen_height - gameState.sara_sprite.height
    end

    gameState.sara:update(dt)
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        gameState.sara_animation = gameState.sara_animation + 1
        if gameState.sara_animation > #gameState.sara_sprite.animation_order then
            gameState.sara_animation = 1
        else
            gameState.sara:setAnimation(gameState.sara_sprite.animation_order[gameState.sara_animation])
        end
    end

    gameState.keys[key] = false
end

function love.keypressed(key)
    gameState.keys[key] = true
end
