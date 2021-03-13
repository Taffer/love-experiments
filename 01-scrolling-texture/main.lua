-- Experiment 1 - Scrolling Texture
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
    sprite2_y = 100,

    quad = nil
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.images.robot = love.graphics.newImage('resources/character_robot_jump.png')
    gameResources.images.robot:setWrap('repeat')
    gameState.quad = love.graphics.newQuad(0, 0,
        gameResources.images.robot:getWidth(), gameResources.images.robot:getHeight(),
        gameResources.images.robot:getWidth(), gameResources.images.robot:getHeight())

    local gameState = gameState
    gameState.max_y = gameResources.images.robot:getHeight()
end

function love.draw()
    local gameResources = gameResources
    local gameState = gameState

    -- Normal sprite
    love.graphics.draw(gameResources.images.robot, gameState.sprite1_x, gameState.sprite1_y)

    -- Animate the texture.
    -- Using a quad's viewport is better than making a new quad.
    gameState.quad:setViewport(0, 0 + gameState.dy,
        gameResources.images.robot:getWidth(), gameResources.images.robot:getHeight(),
        gameResources.images.robot:getWidth(), gameResources.images.robot:getHeight())
    love.graphics.draw(gameResources.images.robot, gameState.quad, gameState.sprite2_x, gameState.sprite2_y)
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
