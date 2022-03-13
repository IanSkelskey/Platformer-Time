--[[
    Hero Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    The hero is the controllable character in a platformer.

]]

Hero = Class{
  WALK_SPEED = 60,
  RUN_SPEED = 100,
  JUMP_SPEED = -375
}

function Hero:init(x, y)

  self:setSpawnPoint(x,y)

  self.alive = true
  self.coins = 0
  self.score = 0
  self.health = {current = 5, max = 5}

  self.grounded = false
  self.direction = 1  -- to the right (Will be determined with constructor parameters)
  self.body_width = 10
  self.body_height = 20
  self.body_center_x = x
  self.body_center_y = y

  self.sprite_width = 32
  self.sprite_height = 32

  self.speeds = {dx = 0, dy = 0}

  self.physics = self:initializePhysics()
  self.states = self:initializeStateMachine()

  self:createControllers()

  -- Hero begins in idle state
  self.states:change('idle', {
    hero = self
  })
  -- Consider initializing in fall states
  -- self.states:change('fall')

end


function Hero:createControllers()
  self.debugger = HeroDebugger(self)
  self.inputController = NewHeroController(self)
  self.physicsController = NewHeroPhysics(self)
end

function Hero:takeDamage(amount)
  if self.health.current - amount > 0 then
    self.health.current = self.health.current - amount
    -- self.states:change('hurt')
  else
    self.health.current = 0
    self:die()
  end
end

function Hero:die()
  self.alive = false
end

function Hero:incrementCoins()
  self.coins = self.coins + 1
  self.score = self.score + Coin.SCORE_VALUE
end

function Hero:update(dt)
  self.states:update(dt)
  self:matchSpriteLocationToBody()
  self:respawnOnDeath()
  self.inputController:update()
  self.physicsController:update(dt)
end

function Hero:matchSpriteLocationToBody()
  self.sprite_x = self.body_center_x - self.sprite_width/2
  self.sprite_y = self.body_center_y - self.sprite_height/2
end

function Hero:render()
  self.states:render()
  if (debug_active) then
    self.debugger:render()
  end
end

-- Eventually to be tied to checkpoints
function Hero:respawnOnDeath()
  if not self.alive then
    self.physics.body:setPosition(self.last_spawn_location_x, self.last_spawn_location_y)
    self.health.current = self.health.max
    self.alive = true
    self.states:change('idle', {
      hero = self
    })
  end
end

-- Move the following 3 functions to NewHeroPhysics
function Hero:beginContact(a, b, collision)
  if self.grounded == true then return end
  local nx, ny = collision:getNormal()
  if a == self.physics.fixture then
    if ny > 0 then
      self:land(collision)
    end
  elseif b == self.physics.fixture then
    if ny < 0 then
      self:land(collision)
    end
  end
end
-- Landing needs refactoring maybe return a boolean?
function Hero:land(collision)
  self.currentGroundCollision = collision
  if (self.states.previous.NAME ~= nil and self.states.previous.NAME ~= 'jump') or self.states.current.NAME == 'jump' then
    self.states:change(self.states.previous.NAME, {
      hero = self
    })
  else
    self.states:change('idle', {
      hero = self
    })
  end
  self.speeds.dy = 0
  self.grounded = true
end

function Hero:endContact(a, b, collision)
  if a == self.physics.fixture or b == self.physics.fixture then
    if self.currentGroundCollision == collision then
      self.grounded = false
      -- Consider changing to the falling state when fully implemented
      -- self.states:change('fall')
    end
  end
end

-- This exists in basically everything with physics. Consider moving to a global physics file
-- and parameterizing it with physics constants (mass, gravity_scale, user_data, etc)
function Hero:initializePhysics()
  local physics = {}
  physics.body = love.physics.newBody(World, self.body_center_x, self.body_center_y, 'dynamic')
  physics.body:setFixedRotation(true)
  physics.shape = love.physics.newRectangleShape(self.body_width, self.body_height) -- By default, the local origin is located at the center of the rectangle as opposed to the top left for graphics.
  physics.fixture = love.physics.newFixture(physics.body, physics.shape)
  physics.fixture:setUserData('Hero')
  physics.body:setGravityScale(0)
  return physics
end

function Hero:setSpawnPoint(x,y)
  self.last_spawn_location_x = x
  self.last_spawn_location_y = y
end

function Hero:initializeStateMachine()
  -- initialize state machine with all state-returning functions
  local states = StateMachine {
      ['idle'] = function() return IdleState() end,
      ['walk'] = function() return WalkState() end,
      ['run'] = function() return RunState() end,
      ['sprint'] = function() return SprintState() end,
      ['jump'] = function() return JumpState() end,
      ['skid'] = function() return SkidState() end,
      ['fall'] = function() return FallState() end,
      ['attack'] = function() return AttackState() end
  }
  return states
end
