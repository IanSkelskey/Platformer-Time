--[[
    RunState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's run state.
]]

RunState = Class{__includes = BaseState}

function RunState:init()
  self.NAME = 'run'
  self.animation = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, .7)

end

function RunState:enter(params)

end

function RunState:exit()

end

function RunState:update(dt)

  runControls()
  handleKeyReleases()

end

function RunState:render()

end
