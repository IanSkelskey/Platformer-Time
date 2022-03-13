--[[
    FallState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's falling state.
]]

FallState = Class{
  __includes = BaseState,
  NAME = 'fall'
}

function FallState:init()
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_idle.png"), 32, 32, 2.5)
end

function FallState:enter(params)
  self.hero = params.hero

end

function FallState:exit()
  -- Perhaps this is where you call land...
end

function FallState:update(dt)
  self:physics()
end

function FallState:render()
  renderAnimation(self.animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end

function FallState:physics()
  controlled.grounded = false
end
