-- Experiment 18 - Tilemap Layers
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'

-- Map class
local Map = Class('Map')

function Map:initialize(mapData)
    self.layers = mapData.layers

    -- Texture atlas
    --
    -- Normally we could load it directly from the map like this:
    --
    -- self.atlas = love.graphics.newImage('resources/' .. mapData.tilesets[1].image)
    --
    -- but the terrain-map-v7.png is not friendly to GPUs; it's 512 pixels
    -- wide (good), but almost 32,000 pixels tall (bad!).
    self.atlas = love.graphics.newImage('resources/terrain-map-v7-repacked.png')
    self.atlasWidth = self.atlas:getWidth()
    self.atlasHeight = self.atlas:getHeight()

    self.quads = {}

    -- Map constants.
    self.mapWidth = mapData.width
    self.mapHeight = mapData.height

    self.tileWidth = mapData.tilewidth
    self.tileHeight = mapData.tileheight
    self.tileSpacing = mapData.spacing or 0

    -- Create quads for the sprites on the atlas:
    for y = 0, (self.atlasHeight / self.tileHeight) - 1 do
        for x = 0, self.atlasWidth / self.tileWidth - 1 do
            local atlas_x = x * self.tileWidth + x * self.tileSpacing
            local atlas_y = y * self.tileHeight + y * self.tileSpacing
            table.insert(self.quads, love.graphics.newQuad(atlas_x, atlas_y, self.tileWidth, self.tileHeight, self.atlas))
        end
    end
end

function Map:render(batch, view_x, view_y, view_width, view_height)
    love.graphics.setColor(1, 1, 1, 1) -- white

    batch:clear()

    for l in ipairs(self.layers) do
        local gameMap = self.layers[l].data

        for y = 0, view_height - 1 do
            for x = 0, view_width - 1 do
                local quad = gameMap[x + view_x + (y + view_y) * self.mapWidth + 1]
                if quad > 0  and quad < #self.quads then
                    batch:add(self.quads[quad], x * self.tileWidth, y * self.tileHeight)
                end
            end
        end
    end

    batch:flush()

    love.graphics.draw(batch)
end

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
    quads = {},

    map = dofile('resources/map.lua'),
}

-- Current state of the game.
gameState = {
    view_x = 0, -- In tiles.
    view_y = 0,
    view_width = math.floor(love.graphics.getWidth() / gameResources.map.tilewidth),
    view_height = math.floor(love.graphics.getHeight() / gameResources.map.tileheight),

    batch = nil, -- SpriteBatch for drawing, created in love.load()
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    io.stdout:setvbuf("no") -- Don't buffer console output.

    local gameResources = gameResources
    local gameState = gameState

    gameResources.fonts.variable = love.graphics.newFont('resources/fonts/LiberationSerif-Bold.ttf', 16)

    -- Create the map.
    gameResources.map = Map:new(gameResources.map)

    -- Visible tiles * number of layers.
    gameState.batch = love.graphics.newSpriteBatch(gameResources.map.atlas, gameState.view_width * gameState.view_height)
end

function love.draw()
    local gameState = gameState

    love.graphics.clear(0, 0, 0, 1)

    gameResources.map:render(gameState.batch, gameState.view_x, gameState.view_y, gameState.view_width, gameState.view_height)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gameResources.fonts.variable)
    love.graphics.print('Press arrow keys or WASD.', 10, 10)
end

-- Event generation.
function love.keyreleased(key)
    local gameResources = gameResources
    local gameState = gameState

    if gameResources.map == nil then
        return
    end

    if key == 'escape' then
        love.event.quit()
    elseif key == 'right' or key == 'd' then
        gameState.view_x = gameState.view_x + 1
        if gameState.view_x + gameState.view_width > gameResources.map.mapWidth then
            gameState.view_x = gameResources.map.mapWidth - gameState.view_width
        end
    elseif key == 'left' or key == 'a' then
        gameState.view_x = gameState.view_x - 1
        if gameState.view_x < 0 then
            gameState.view_x = 0
        end
    elseif key == 'down' or key == 's' then
        gameState.view_y = gameState.view_y + 1
        if gameState.view_y + gameState.view_height > gameResources.map.mapHeight then
            gameState.view_y = gameResources.map.mapHeight - gameState.view_height
        end
    elseif key == 'up' or key == 'w' then
        gameState.view_y = gameState.view_y - 1
        if gameState.view_y < 0 then
            gameState.view_y = 0
        end
    end
end
