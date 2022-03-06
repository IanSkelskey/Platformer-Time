--[[
    IdleState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's idle state.
]]

IdleState = Class{__includes = BaseState}

function IdleState:init()
  self.NAME = 'idle'
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_idle.png"), 32, 32, 2.5)
end

function IdleState:enter(params)
  self.hero = params.hero
end

function IdleState:exit()

end

function IdleState:update(dt)
  updateAnimation(self.animation, dt)
  self:physics()
  self:controls()
end

function IdleState:render()
  renderAnimation(self.animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end

function IdleState:controls()
  -- IDLESTATE KEYBOARD CONTROLS
  if active_move_key == 'right' or active_move_key == 'left' then  -- Consider adding function to track active move key and make hero direction changes in states instead
    print('changing to walk')
    self.hero.states:change('walk', {
      hero = self.hero
    })
  end

  if love.keyboard.wasPressed('up') and self.hero.grounded then
    self.hero.states:change('jump', {
      hero = self.hero
    })
  end

  if love.keyboard.wasPressed('space') then
    print('pressed space')
    self.hero.states:change('attack', {
      hero = self.hero
    })
  end

end

-- Execute continuously in update during idle state
function IdleState:physics()
  -- controlled.grounded = true
  self.hero.speeds.dx = 0
end
