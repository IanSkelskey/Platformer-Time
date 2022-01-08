--[[
    RunState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's run state.
]]

RunState = Class{__includes = BaseState}

local run_anim = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, .7)

function RunState:init()

end

function RunState:enter(params)

end

function RunState:exit()

end

function RunState:update(dt)
  updateAnimation(run_anim, dt)
end

function RunState:render()
  renderAnimation(run_anim, self.x, self.y, self.direction)
end
