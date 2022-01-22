--[[
    JumpState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's jump state.
]]

JumpState = Class{__includes = BaseState}

local JUMP_SPEED = -6

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

  hero.y = hero.y - 1
  hero.speeds.dy = JUMP_SPEED
end

function JumpState:exit()

end

function JumpState:update(dt)
  updateAnimation(jump_anim, dt)

  jumpControls()
  handleKeyReleases()

  BaseState:matchStateToHero(hero)
end

function JumpState:render()
  renderAnimation(jump_anim, hero.x - hero.width/2, hero.y - hero.height/2, hero.direction)
end
