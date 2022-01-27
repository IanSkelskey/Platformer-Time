--[[
    WalkState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's walk state.
]]

WalkState = Class{__includes = BaseState}

function WalkState:init()
  self.NAME = 'walk'
  self.animation = newAnimation(love.graphics.newImage("images/finn_walk.png"), 32, 32, 1)
end

function WalkState:enter(params)

end

function WalkState:exit()

end

function WalkState:update(dt)

end

function WalkState:render()

end
