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
  walkControls()
  handleKeyReleases()

  BaseState:matchStateToHero(hero)
end

function WalkState:render()
  renderAnimation(walk_anim, self.x, self.y, self.direction)
end
