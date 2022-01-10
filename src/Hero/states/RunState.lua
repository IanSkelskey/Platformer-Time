--[[
    RunState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's run state.
]]

RunState = Class{__includes = BaseState}

local run_anim = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, .7)

function RunState:init()
  self.NAME = 'run'

end

function RunState:enter(params)
  self.x = params.x
  self.y = params.y
  self.direction = params.direction
  self.dx = params.dx
  self.dy = params.dy
end

function RunState:exit()

end

function RunState:update(dt)
  updatePhysics(hero, self, dt)
  updateAnimation(run_anim, dt)

  if love.keyboard.wasPressed('up') then
    heroState:change('jump', {
      x = self.x,
      y = self.y,
      direction = self.direction,
      dx = self.dx,
      dy = self.dy
    })
  end

  function love.keyreleased(key)
    if key == 'right' and self.direction == 1 then
      if love.keyboard.isDown('left') then
        self.direction = -1
      else
        heroState:change('idle', {
            x = self.x,
            y = self.y,
            dx = 0,
            dy = 0
            -- direction = 1
          })
      end
    elseif key == 'left' and self.direction == -1 then
      if love.keyboard.isDown('right') then
        self.direction = 1
      else
        heroState:change('idle', {
            x = self.x,
            y = self.y,
            dx = 0,
            dy = 0,
            direction = -1
          })
      end
    elseif key == 'lshift' then
      heroState:change('walk', {
        x = self.x,
        y = self.y,
        dx = self.dx,
        dy = self.dy,
        direction = self.direction
      })
  end
  end
end

function RunState:render()
  renderAnimation(run_anim, self.x, self.y, self.direction)
end
