-- Experiment 1 - Sprite Rotation
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {}
}

-- Current state of the game.
gameState = {
    dy = 0, -- Animated texture y offset.
    max_y = 0, -- Max dy before we have to reset it to 0.

    sprite1_x = 100, -- Draw the normal sprite here.
    sprite1_y = 100,

    sprite2_x = 200, -- Draw the animated sprite here.
    sprite2_y = 100
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.images.robot = love.graphics.newImage('resources/character_robot_jump.png')
    gameResources.images.robot2y = love.graphics.newImage('resources/character_robot_jump-2y.png')

    local gameState = gameState
    gameState.max_y = gameResources.images.robot2y:getHeight() / 2
end

function love.draw()
    local gameResources = gameResources
    local gameState = gameState

    -- Normal sprite
    love.graphics.draw(gameResources.images.robot, gameState.sprite1_x, gameState.sprite1_y)

    -- Animate the texture.
    -- Is using a quad's viewport better than making a new quad?
    local quad = love.graphics.newQuad(0, 0 + gameState.dy,
        gameResources.images.robot2y:getWidth(), gameResources.images.robot2y:getHeight() / 2,
        gameResources.images.robot2y:getWidth(), gameResources.images.robot2y:getHeight())
    love.graphics.draw(gameResources.images.robot2y, quad, gameState.sprite2_x, gameState.sprite2_y)
end

function love.update(dt)
    -- Rotate the sprite one pixel per 1/60 seconds.
    local gameState = gameState

    gameState.dy = gameState.dy + dt * 60
    if gameState.dy > gameState.max_y then
        gameState.dy = 0
    end
end

-- Event generation.
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
