--[[
    JumpState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's jump state.
]]

JumpState = Class{__includes = BaseState}

local jump_anim = newAnimation(love.graphics.newImage("images/finn_jump.png"), 32, 32, 1)

function JumpState:init()

end

function JumpState:enter(params)
  self.x = params.x
  self.y = params.y
  self.direction = params.direction
end

function JumpState:exit()

end

function JumpState:update(dt)
  updateAnimation(jump_anim, dt)
end

function JumpState:render()
  renderAnimation(jump_anim, self.x, self.y, self.direction)
end
