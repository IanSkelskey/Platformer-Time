--[[
    SprintState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's sprint state.
]]

SprintState = Class{__includes = BaseState}

local sprint_anim = newAnimation(love.graphics.newImage("images/finn_sprites/finn_run.png"), 32, 32, .6)

function SprintState:init()

end

function SprintState:enter(params)

end

function SprintState:exit()

end

function SprintState:update(dt)
  updateAnimation(sprint_anim, dt)
end

function SprintState:render()
  renderAnimation(sprint_anim, self.x, self.y, self.direction)
end
