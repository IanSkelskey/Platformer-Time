--[[
    SkidState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's skid state.
]]

SkidState = Class{__includes = BaseState}

function SkidState:init()
  self.NAME = 'skid'
  self.animation = newAnimation(love.graphics.newImage("images/finn_sprites/finn_turn.png"), 32, 32, .4)
  -- add skid sound?
end

function SkidState:enter(params)

end

function SkidState:exit()

end

function SkidState:update(dt)

end

function SkidState:render()

end
