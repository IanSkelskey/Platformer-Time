--[[
    IdleState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's idle state.
]]

IdleState = Class{__includes = BaseState}

local idle_anim = newAnimation(love.graphics.newImage("images/finn_idle.png"), 32, 32, 2.5)

function IdleState:init()

end

function IdleState:enter(params)
  self.x = params.x
  self.y = params.y
  self.direction = params.direction
end

function IdleState:exit()

end

function IdleState:update(dt)
  updateAnimation(idle_anim, dt)

  if love.keyboard.wasPressed('right') then

    heroState:change('walk', {
        x = self.x,
        y = self.y,
        direction = 1
    })

  elseif love.keyboard.wasPressed('left') then

    heroState:change('walk', {
        x = self.x,
        y = self.y,
        direction = -1
    })

  end
end

function IdleState:render()
  renderAnimation(idle_anim, self.x, self.y, self.direction)
end
