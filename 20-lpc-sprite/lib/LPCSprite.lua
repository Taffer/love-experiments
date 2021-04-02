-- Skelly LPC Sprite for animation.
--
-- This sets up a set of sprites, quads, etc. using the standard Liberated
-- Pixel Cup sprite format:
--
-- https://lpc.opengameart.org/static/lpc-style-guide/styleguide.html
--
-- Specifically:
-- * Each row is a complete animation cycle.
-- * Rows are mostly in groups of four based on facing = away, left, forward,
--   right.
-- * Animation rows are: Spellcast, Thrust, Walk, Slash, Shoot, Hurt (only one
--   facing for Hurt). We fake an Idle animation by cloning the first frame of
--   Walk.
-- * Are 64x64 on the sprite sheet.
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

local Class = require 'lib/middleclass'

-- Quads singleton, hopefully.
--
-- quads[animation][facing][frame] is an actual quad.
local lpcSpriteQuads = nil -- Quads singleton

local LPCSprite = Class('LPCSprite')
function LPCSprite:initialize(texture)
    self.facings = {
        away = 1,
        left = 2,
        forward = 3,
        right = 4
    }
    self.facing_order = {'away', 'left', 'forward', 'right'}
    self.animations = {
        spellcast = 1,
        thrust = 2,
        walk = 3,
        slash = 4,
        shoot = 5,
        hurt = 6,
        idle = 7
    }
    self.animation_order = {'spellcast', 'thrust', 'walk', 'slash', 'shoot', 'hurt', 'idle'}
    self.frames = {
        spellcast = 7,
        thrust = 8,
        walk = 9,
        slash = 6,
        shoot = 13,
        hurt = 6,
        idle = 1
    }

    self.width = 64 -- Standard for LPC sprite sheets.
    self.height = 64

    self.feet_x = self.width / 2 -- Where are the feet relative to 0,0?
    self.feet_y = self.height - 2


    self.facing = 'forward' -- Default facing and animation.
    self.animation = 'walk'
    self.frame = 1

    self.texture = texture
    if lpcSpriteQuads == nil then
        self:generateQuads()
    end
    self.quads = lpcSpriteQuads
end

function LPCSprite:generateQuads()
    lpcSpriteQuads = {}

    local y = 0
    for _, av in ipairs(self.animation_order) do
        lpcSpriteQuads[av] = {}

        if av ~= 'hurt' and av ~= 'idle' then
            for _, fv in ipairs(self.facing_order) do
                lpcSpriteQuads[av][fv] = {}

                for i = 1, self.frames[av] do
                    local x = (i - 1) * self.width
                    table.insert(lpcSpriteQuads[av][fv], love.graphics.newQuad(x, y, self.width, self.height, self.texture))
                end

                y = y + self.height
            end
        end
    end

    -- 'hurt' has to be special-cased because it only has one facing.
    y = self.texture:getHeight() - self.height
    for _, fv in ipairs(self.facing_order) do
        -- We'll lie and re-use these for all four facings.
        lpcSpriteQuads['hurt'][fv] = {}
    end
    for i = 1, self.frames['hurt'] do
        local x = (i - 1) * self.width
        local quad = love.graphics.newQuad(x, y, self.width, self.height, self.texture)
        for _, fv in ipairs(self.facing_order) do
            table.insert(lpcSpriteQuads['hurt'][fv], quad)
        end
    end

    -- 'idle' is a fake state that's just the first 'walk' frame.
    for _, fv in ipairs(self.facing_order) do
        lpcSpriteQuads['idle'][fv] = lpcSpriteQuads['walk'][fv]
    end
end

function LPCSprite:checkFrame()
    if self.frame > self.frames[self.animation] then
        self.frame = 1
    end
end

function LPCSprite:nextFrame()
    self.frame = self.frame + 1
    self:checkFrame()
end

function LPCSprite:setFacing(facing)
    self.facing = facing
    self:checkFrame()
end

function LPCSprite:setAnimation(animation)
    self.animation = animation
    self:checkFrame()
end

function LPCSprite:getQuad()
    return self.quads[self.animation][self.facing][self.frame]
end

function LPCSprite:draw(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.texture, self:getQuad(), x, y)
end

return LPCSprite
