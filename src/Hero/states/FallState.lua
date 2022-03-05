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
  heroPhysics:fall()
end

function FallState:exit()
  -- Perhaps this is where you call land...
end

function FallState:update(dt)
  -- Animation as needed
end

function FallState:render()
  -- Render Animation Here
end
