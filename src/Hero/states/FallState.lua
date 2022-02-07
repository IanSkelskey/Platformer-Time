--[[
    FallState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's idle state.
]]

FallState = Class{__includes = BaseState}

function FallState:init()
  self.NAME = 'fall'
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_idle.png"), 32, 32, 2.5)
end

function FallState:enter(params)

end

function FallState:exit()

end

function FallState:update(dt)

end

function FallState:render()

end
