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
  
end

function WalkState:exit()

end

function WalkState:update(dt)

  updateAnimation(walk_anim, dt)
  walkControls()
  handleKeyReleases()

  BaseState:matchStateToHero(hero)
end

function WalkState:render()
  renderAnimation(walk_anim, hero.x, hero.y, hero.direction)
end
