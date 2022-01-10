--[[
    WalkState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's walk state.
]]

WalkState = Class{__includes = BaseState}

local walk_anim = newAnimation(love.graphics.newImage("images/finn_walk.png"), 32, 32, 1)



function WalkState:init()
  self.NAME = 'walk'
end

function WalkState:enter(params)
  self.x = params.x
  self.y = params.y
  self.direction = params.direction
end

function WalkState:exit()

end

function WalkState:update(dt)
  updateAnimation(walk_anim, dt)
  updatePhysics(hero, self, dt)

  -- if we somehow get to the walk state and neither left or right is pressed,
  -- leave the walk state.
  if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    heroState:change('idle', {
        x = self.x,
        y = self.y,
        dx = 0,
        dy = 0,
        direction = self.direction
      })
  end

  if love.keyboard.wasPressed('lshift') or love.keyboard.isDown('lshift') then
    heroState:change('run', {
      x = self.x,
      y = self.y,
      direction = self.direction,
      dx = self.dx,
      dy = self.dy
    })
  elseif love.keyboard.wasPressed('up') then
    heroState:change('jump', {
      x = self.x,
      y = self.y,
      direction = self.direction,
      dx = self.dx,
      dy = self.dy
    })
  end


  local function love.keyreleased(key)
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
    end
  end


end

function WalkState:render()
  renderAnimation(walk_anim, self.x, self.y, self.direction)
end
