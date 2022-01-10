--[[
    JumpState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's jump state.
]]

JumpState = Class{__includes = BaseState}

local JUMP_SPEED = -4.5

local jump_anim = newAnimation(love.graphics.newImage("images/finn_jump.png"), 32, 32, 1)

function JumpState:init()
  self.NAME = 'jump'
  self.sounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static')
  }
end

function JumpState:enter(params)
  self.sounds['jump']:stop()
  self.sounds['jump']:play()
  self.x = params.x
  self.y = params.y
  self.dx = params.dx
  self.direction = params.direction
  hero.y = hero.y - 1
  hero.speeds.dy = JUMP_SPEED
end

function JumpState:exit()

end

function JumpState:update(dt)
  updatePhysics(hero, self, dt)
  updateAnimation(jump_anim, dt)

  if self.dy == 0 then
    heroState:change(heroState.previous.NAME, {
      x = self.x,
      y = self.y,
      direction = self.direction
    })
  end
end

function JumpState:render()
  renderAnimation(jump_anim, self.x, self.y, self.direction)
end
