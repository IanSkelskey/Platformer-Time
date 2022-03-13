--[[
    AttackState Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer hero's idle state.
]]

AttackState = Class{
  __includes = BaseState,
  NAME = 'attack'
}

function AttackState:init()
  self.animation = newAnimation(love.graphics.newImage("assets/images/finn_sprites/finn_attack.png"), 32, 32, 0.5)
end

function AttackState:enter(params)
  self.hero = params.hero
  if self.hero.states.previous.NAME ~= 'jump' then
    Timer.tween(.4, self.hero.speeds, {dx = 0}, 'quad', function() self.hero.speeds.dx = 0 end)
  end
  Timer.after(.5, function() self.hero.states:change('idle', { hero = self.hero }) end)
end

function AttackState:exit()

end

function AttackState:update(dt)
  updateAnimation(self.animation, dt)
end

function AttackState:render()
  renderAnimation(self.animation, self.hero.sprite_x, self.hero.sprite_y, self.hero.direction)
end
