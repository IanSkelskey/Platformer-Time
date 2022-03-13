--[[
    WalkState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's walk state.
]]

WalkState = Class{
  __includes = BaseState,
  NAME = 'walk'
}

function WalkState:init()
  self.animations = {
    ['main'] = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_walk.png"), 32, 32, 1),
    ['turning'] = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_midturn.png"), 32, 32, .12)
  }

  self.current_animation = self.animations['main']
end

function WalkState:enter(params)
  self.hero = params.hero
end

function WalkState:exit()

end

function WalkState:update(dt)
  updateAnimation(self.current_animation, dt)
  self:physics()
  self:controls()
end

function WalkState:render()
  renderAnimation(self.current_animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end

function WalkState:controls()
  if self:turning() then
    self.current_animation = self.animations['turning']
    Timer.after(.12, function() self.current_animation = self.animations['main'] end)
  end

  if active_move_key == 'none' then
    self.hero.states:change('idle', {
      hero = self.hero
    })
  end

  if run_toggle then
    self.hero.states:change('run', {
      hero = self.hero
    })
  elseif love.keyboard.wasPressed('up') and self.hero.grounded then
    self.hero.states:change('jump', {
      hero = self.hero
    })
  end

  if love.keyboard.wasPressed('space') then
    self.hero.states:change('attack', {
      hero = self.hero
    })
  end

end

function WalkState:turning()
  if active_move_key == 'right' and self.hero.direction == -1 then
      print('changing direction')
      return true
  end
  if active_move_key == 'left' and self.hero.direction == 1 then
    print('changing direction')
    return true
  else
    return false
  end
end

-- Execute continuously in update during walk state
function WalkState:physics()
  -- This may work to keep the hero grounded once the fall state is implemented.       !!!!
  -- Same goes for idle and run
  -- controlled.grounded = true
  self.hero.speeds.dx = self.hero.direction * self.hero.WALK_SPEED
end
