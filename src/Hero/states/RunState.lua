--[[
    RunState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's run state.
]]

RunState = Class{
  __includes = BaseState,
  NAME = 'run'
}

function RunState:init()
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_run.png"), 32, 32, .7)
end

function RunState:enter(params)
  self.hero = params.hero
end

function RunState:exit()

end

function RunState:update(dt)
  updateAnimation(self.animation, dt)
  self:physics()
  self:controls()
end

function RunState:render()
  renderAnimation(self.animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end

function RunState:controls()
  if not run_toggle then
    self.hero.states:change('walk', {
      hero = self.hero
    })
  end
  if active_move_key == 'none' then
    self.hero.states:change('idle', {
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

-- Execute continuously in update during run state
function RunState:physics()
  -- controlled.grounded = true
  self.hero.speeds.dx = self.hero.direction * self.hero.RUN_SPEED
end
