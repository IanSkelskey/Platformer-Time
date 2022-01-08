--[[
    SkidState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's skid state.
]]

SkidState = Class{__includes = BaseState}

local skid_anim = newAnimation(love.graphics.newImage("images/finn_turn.png"), 32, 32, .4)

function SkidState:init()

end

function SkidState:enter(params)
  self.x = params.x
  self.y = params.y
  self.direction = params.direction
end

function SkidState:exit()

end

function SkidState:update(dt)
  updateAnimation(skid_anim, dt)
end

function SkidState:render()
  renderAnimation(skid_anim, self.x, self.y, self.direction)
end
