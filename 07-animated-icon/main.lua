-- Experiment 6 - UI Dialog
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},

    quads = {},
    robot_walk = {} -- Robot walking animation frames.
}

-- Current state of the game.
gameState = {
    robot_x = 100,
    robot_y = 100,

    tick = 1,
    tick_time = 0.1,
    timer = 0,

    margin = 1
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.images.robot = love.graphics.newImage('resources/character_robot_sheet.png')

    -- Co-ordinates from character_robot_sheet.xml.
    local q = gameResources.quads
    q.walk0 = love.graphics.newQuad(  0, 512, 96, 128, gameResources.images.robot)
    q.walk1 = love.graphics.newQuad( 96, 512, 96, 128, gameResources.images.robot)
    q.walk2 = love.graphics.newQuad(192, 512, 96, 128, gameResources.images.robot)
    q.walk3 = love.graphics.newQuad(288, 512, 96, 128, gameResources.images.robot)
    q.walk4 = love.graphics.newQuad(384, 512, 96, 128, gameResources.images.robot)
    q.walk5 = love.graphics.newQuad(480, 512, 96, 128, gameResources.images.robot)
    q.walk6 = love.graphics.newQuad(576, 512, 96, 128, gameResources.images.robot)
    q.walk7 = love.graphics.newQuad(672, 512, 96, 128, gameResources.images.robot)

    gameResources.robot_walk = { q.walk0, q.walk1, q.walk2, q.walk3, q.walk4, q.walk5, q.walk6, q.walk7 }
end

function love.draw()
    local gameResources = gameResources
    local gameState = gameState

    love.graphics.clear(0, 0, 0, 1) -- black

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameResources.images.robot, gameResources.robot_walk[gameState.tick],
        gameState.robot_x, gameState.robot_y)

    love.graphics.setColor(0, 1, 0, 1) -- green
    love.graphics.rectangle('line', gameState.robot_x - gameState.margin, gameState.robot_y - gameState.margin,
        96 + 2 * gameState.margin, 128 + 2 * gameState.margin)
end

function love.update(dt)
    local gameResources = gameResources
    local gameState = gameState

    gameState.timer = gameState.timer + dt
    if gameState.timer > gameState.tick_time then
        gameState.timer = gameState.timer - gameState.tick_time

        gameState.tick = gameState.tick + 1
        if gameState.tick > #gameResources.robot_walk then
            gameState.tick = 1
        end
    end
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end
