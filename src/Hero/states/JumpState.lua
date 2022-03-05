--[[
    JumpState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's jump state.
]]

JumpState = Class{__includes = BaseState}

function JumpState:init()
  self.NAME = 'jump'
  self.sounds = {
    ['jump'] = love.audio.newSource('assets/sounds/jump.wav', 'static')
  }
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_jump.png"), 32, 32, 1)
end

function JumpState:enter(params)
  self.sounds['jump']:stop()
  self.sounds['jump']:play()

  heroPhysics:jump()
end

function JumpState:exit()

end

function JumpState:update(dt)
  heroPhysics:jumping()
  heroController:jump()
end

function JumpState:render()

end
