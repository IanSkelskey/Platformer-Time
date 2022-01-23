--[[
    JumpState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's jump state.
]]

JumpState = Class{__includes = BaseState}

local JUMP_SPEED = -6

function JumpState:init()
  self.NAME = 'jump'
  self.sounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static')
  }
  self.animation = newAnimation(love.graphics.newImage("images/finn_jump.png"), 32, 32, 1)
end

function JumpState:enter(params)
  self.sounds['jump']:stop()
  self.sounds['jump']:play()

  hero.y = hero.y - 1
  hero.speeds.dy = JUMP_SPEED
end

function JumpState:exit()

end

function JumpState:update(dt)

  jumpControls()
  handleKeyReleases()

end

function JumpState:render()

end
