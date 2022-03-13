--[[
    JumpState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's jump state.
]]

JumpState = Class{
  __includes = BaseState,
  NAME = 'jump',
  SOUND = love.audio.newSource('assets/sounds/jump.wav', 'static') --https://simon-develop.itch.io/jump-sound-100-free
}

function JumpState:init()
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_jump.png"), 32, 32, 1)
end

function JumpState:enter(params)
  self.hero = params.hero
  self.SOUND:stop()
  self.SOUND:play()
  self:jumpEntryPhysics()
end

function JumpState:exit()

end

function JumpState:update(dt)
  updateAnimation(self.animation, dt)
  self:midJumpPhysics()
  self:controls()
end

function JumpState:render()
  renderAnimation(self.animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end

-- THIS NEEDS FIXING
function JumpState:controls()
  if active_move_key == 'left' then
    self.hero.direction = -1
  elseif active_move_key == 'right' then
    self.hero.direction = 1
  end

  if love.keyboard.wasPressed('space') then
    self.hero.states:change('attack', {
      hero = self.hero
    })
  end
end

-- Execute once when entering the jump state
function JumpState:jumpEntryPhysics()
  self.hero.speeds.dy = self.hero.JUMP_SPEED
  self.hero.grounded = false
end

-- Execute continuously in update during jump state
function JumpState:midJumpPhysics()

  if self.hero.states.previous.NAME == 'idle' then
    if active_move_key ~= 'none' then self.hero.speeds.dx = self.hero.direction * self.hero.WALK_SPEED end
  elseif self.hero.states.previous.NAME == 'walk' then
    self.hero.speeds.dx = self.hero.direction * self.hero.WALK_SPEED
  elseif self.hero.states.previous.NAME == 'run' then
    self.hero.speeds.dx = self.hero.direction * self.hero.RUN_SPEED
  end
end
