--[[
    WalkState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's walk state.
]]

WalkState = Class{__includes = BaseState}

local WALK_SPEED = 60

function WalkState:init()
  self.NAME = 'walk'
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_walk.png"), 32, 32, 1)
end

function WalkState:enter(params)
  self.hero = params.hero
end

function WalkState:exit()

end

function WalkState:update(dt)
  updateAnimation(self.animation, dt)
  self:physics()
  self:controls()
end

function WalkState:render()
  renderAnimation(self.animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end

function WalkState:controls()
  -- WALKSTATE KEYBOARD CONTROLS
  if active_move_key == 'none' then
    print('returning to idle')
    self.hero.states:change('idle', {
      hero = self.hero
    })
  end

  if run_toggle then
    self.hero.states:change('run', {
      hero = self.hero
    })
  elseif love.keyboard.wasPressed('up') and self.hero.grounded then
    print('jump from walk')
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

-- Execute continuously in update during walk state
function WalkState:physics()
  -- This may work to keep the hero grounded once the fall state is implemented.       !!!!
  -- Same goes for idle and run
  -- controlled.grounded = true
  self.hero.speeds.dx = self.hero.direction * WALK_SPEED
end
