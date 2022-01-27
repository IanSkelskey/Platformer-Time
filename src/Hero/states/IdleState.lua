--[[
    IdleState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's idle state.
]]

IdleState = Class{__includes = BaseState}

function IdleState:init()
  self.NAME = 'idle'
  self.animation = newAnimation(love.graphics.newImage("images/finn_idle.png"), 32, 32, 2.5)
end

function IdleState:enter(params)

end

function IdleState:exit()

end

function IdleState:update(dt)

end

function IdleState:render()

end
