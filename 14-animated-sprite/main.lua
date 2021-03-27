-- Experiment 14 - Animated Sprite
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'

-- Actor class
--
-- The actor handles drawing the sprite, moving around, and animation.

local Actor = Class('Actor')

function Actor:initialize(resources, spritesheet, framerate)
    -- Assumes a standard Liberated Pixel Cup character spritesheet, see:
    -- https://lpc.opengameart.org/
    --
    -- Framerate is number of ms per frame, 100 (1/10th of a second) seems
    -- good.
    self.width = 64 -- standard for LPC sprites
    self.height = 64

    self.feet_x = self.width / 2 -- Where are the feet relative to 0,0?
    self.feet_y = self.height - 2

    self.texture = spritesheet
    self.framerate = (framerate or 100) / 1000
    self.ticks = 0

    self.animations = {
        idle = {
            -- LPC doesn't have an idle animation, so we'll just use the first
            -- frame from each facing's walk animation.
            back = {resources.quads.sara_walk_up[1]},
            left = {resources.quads.sara_walk_left[1]},
            front = {resources.quads.sara_walk_down[1]},
            right = {resources.quads.sara_walk_right[1]},
        },
        walk = {
            back = resources.quads.sara_walk_up,
            left = resources.quads.sara_walk_left,
            front = resources.quads.sara_walk_down,
            right = resources.quads.sara_walk_right,
        },
    }

    self.state = 'idle'
    self.facing = 'front' -- 'back', 'left', 'front', right'
    self.frame = 1 -- current animation frame
    self.frames = self.animations[self.state][self.facing]
end

function Actor:setFacing(facing)
    self.facing = facing
end

function Actor:setState(state)
    self.state = state
    self.frames = self.animations[state][self.facing]
    if self.frame > #self.frames then
        self.frame = 1
    end
end

function Actor:update(dt)
    -- Update the animation frames.
    self.ticks = self.ticks + dt

    if self.ticks > self.framerate then
        self.frame = self.frame + 1
        if self.frame > #self.frames then
            self.frame = 1
        end
        self.ticks = self.ticks - self.framerate
    end
end

function Actor:draw(x, y)
    -- Draw the actor's current frame at x,y.
    love.graphics.draw(self.texture, self.frames[self.frame], x, y)
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

    sara = nil, -- Our Actor.
    sara_x = 100,
    sara_y = 100,

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

    -- Walking is sprite group #3; so y starts at 3 * 64 = 512.
    -- There are 9 frames per walk row.
    --
    -- I could combine these four loops but I wanted separate tables for each
    -- walk cycle.
    local sara_walk_up = {}
    local y = 512
    for i = 0, 8 do
        local x = 64 * i
        table.insert(sara_walk_up, love.graphics.newQuad(x, y, 64, 64, gameResources.images.sara))
    end
    gameResources.quads.sara_walk_up = sara_walk_up

    y = y + 64
    local sara_walk_left = {}
    for i = 0, 8 do
        local x = 64 * i
        table.insert(sara_walk_left, love.graphics.newQuad(x, y, 64, 64, gameResources.images.sara))
    end
    gameResources.quads.sara_walk_left = sara_walk_left

    y = y + 64
    local sara_walk_down = {}
    for i = 0, 8 do
        local x = 64 * i
        table.insert(sara_walk_down, love.graphics.newQuad(x, y, 64, 64, gameResources.images.sara))
    end
    gameResources.quads.sara_walk_down = sara_walk_down

    y = y + 64
    local sara_walk_right = {}
    for i = 0, 8 do
        local x = 64 * i
        table.insert(sara_walk_right, love.graphics.newQuad(x, y, 64, 64, gameResources.images.sara))
    end
    gameResources.quads.sara_walk_right = sara_walk_right

    gameState.grass_batch = love.graphics.newSpriteBatch(gameResources.images.grass, 880)
    gameState.grass_batch:clear()
    for y = 0, 720, 32 do
        for x = 0, (1280 - 32), 32 do
            gameState.grass_batch:add(gameResources.quads.grass, x, y)
        end
    end

    gameState.sara = Actor:new(gameResources, gameResources.images.sara)
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
    local tile_x = math.floor((gameState.sara_x + gameState.sara.feet_x) / tile_w) * tile_w
    local tile_y = math.floor((gameState.sara_y + gameState.sara.feet_y) / tile_h) * tile_h
    love.graphics.rectangle('line', tile_x, tile_y, tile_w, tile_h)

    love.graphics.setColor(1, 1, 1, 1)
    gameState.sara:draw(gameState.sara_x, gameState.sara_y)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Use WASD or arrow keys to walk.', 10, 10)
end

function love.update(dt)
    local gameState = gameState

    local go_up = gameState.keys['w'] or gameState.keys['up']
    local go_left = gameState.keys['a'] or gameState.keys['left']
    local go_down = gameState.keys['s'] or gameState.keys['down']
    local go_right = gameState.keys['d'] or gameState.keys['right']

    if not (go_up or go_left or go_down or go_right) then
        gameState.sara:setState('idle') -- default state
    end

    if go_up then
        gameState.sara:setFacing('back')
        gameState.sara:setState('walk')

        gameState.sara_y = gameState.sara_y - 1
    end
    if go_left then
        gameState.sara:setFacing('left')
        gameState.sara:setState('walk')

        gameState.sara_x = gameState.sara_x - 1
    end
    if go_down then
        gameState.sara:setFacing('front')
        gameState.sara:setState('walk')

        gameState.sara_y = gameState.sara_y + 1
    end
    if go_right then
        gameState.sara:setFacing('right')
        gameState.sara:setState('walk')

        gameState.sara_x = gameState.sara_x + 1
    end

    -- Clamp Sara's position.
    if gameState.sara_x < 0 then
        gameState.sara_x = 0
    elseif gameState.sara_x + gameState.sara.width > gameState.screen_width then
        gameState.sara_x = gameState.screen_width - gameState.sara.width
    end
    if gameState.sara_y < 0 then
        gameState.sara_y = 0
    elseif gameState.sara_y + gameState.sara.height > gameState.screen_height then
        gameState.sara_y = gameState.screen_height - gameState.sara.height
    end

    gameState.sara:update(dt)
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end

    gameState.keys[key] = false
end

function love.keypressed(key)
    gameState.keys[key] = true
end
