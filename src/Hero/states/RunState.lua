--[[
    RunState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's run state.
]]

RunState = Class{__includes = BaseState}

local run_anim = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, .7)

function RunState:init()
  self.NAME = 'run'

end

function RunState:enter(params)
  self.x = params.x
  self.y = params.y
  self.direction = params.direction
  self.dx = params.dx
  self.dy = params.dy
end

function RunState:exit()

end

function RunState:update(dt)
  updatePhysics(hero, self, dt)
  updateAnimation(run_anim, dt)

  runControls()
  handleKeyReleases()

  BaseState:matchStateToHero(hero)
end

function RunState:render()
  renderAnimation(run_anim, self.x, self.y, self.direction)
end
