--[[
    IdleState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's idle state.
]]

IdleState = Class{__includes = BaseState}

local idle_anim = newAnimation(love.graphics.newImage("images/finn_idle.png"), 32, 32, 2.5)



function IdleState:init()
  self.NAME = 'idle'
end

function IdleState:enter(params)

end

function IdleState:exit()

end

function IdleState:update(dt)

  updateAnimation(idle_anim, dt)

  idleControls()
  handleKeyReleases()

  BaseState:matchStateToHero(hero) -- Move to heroPhysics?

end

function IdleState:render()
  renderAnimation(idle_anim, hero.x, hero.y, hero.direction)
end
