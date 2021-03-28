-- Experiment 15 - Text Dropshadows
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

-- All the stuff we've loaded already.
gameResources = {
    fonts = {},
    images = {},
    quads = {},
}

-- Current state of the game.
gameState = {
}

-- Love callbacks.
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    local gameResources = gameResources
    gameResources.fonts.mono = love.graphics.newFont('resources/LiberationMono-Bold.ttf', 16)
end

function love.draw()
    local gameResources = gameResources

    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1) -- white
    love.graphics.setFont(gameResources.fonts.mono)
    love.graphics.print('Move your joystick, press Esc to exit.', 10, 10)

    love.graphics.print('Found ' .. love.joystick.getJoystickCount() .. ' joystick(s).', 10, 30)
    if love.joystick.getJoystickCount() > 0 then
        local joysticks = love.joystick.getJoysticks()
        love.graphics.print('Joystick #1:', 10, 50)
        love.graphics.print(joysticks[1]:getName(), 20, 70)
        love.graphics.print('Info: ' .. joysticks[1]:getDeviceInfo(), 20, 90)
        love.graphics.print('GUID: ' .. joysticks[1]:getGUID(), 20, 110)
        if joysticks[1]:isVibrationSupported() then
            love.graphics.print('Vibration is supported.', 20, 130)
        end

        local y = 170
        for i = 1, joysticks[1]:getAxisCount() do
            love.graphics.print('Axis ' .. i .. ': ' .. joysticks[1]:getAxis(i), 20, y)
            y = y + 20
        end
        y = y + 20

        for i = 1, joysticks[1]:getButtonCount() do
            if joysticks[1]:isDown(i) then
                love.graphics.print('Button ' .. i .. ': Down', 20, y)
            else
                love.graphics.print('Button ' .. i .. ': Up', 20, y)
            end
            y = y + 20
        end
        y = y + 20

        for i = 1, joysticks[1]:getHatCount() do
            love.graphics.print('Hat ' .. i .. ': ' .. joysticks[i]:getHat(i), 20, y)
        end
    end
end

-- Event generation.
function love.keyreleased(key)
    if key == 'escape' then
        love.event.quit()
    end
end
