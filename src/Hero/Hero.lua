--[[
    Hero Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    The hero is the controllable character in a platformer.
    A hero can:
      - idle
      - walk
      - run
      - jump
      - skid
      - spin
      - attack
      - die
      - hurt
      - fall
]]

Hero = Class{}

-- Declare and initialize spawn variables
local SPAWN_X = nil
local SPAWN_Y = nil

function Hero:init(x, y)

    self.alive = true
    self.coins = 0
    self.score = 0
    self.health = {current = 5, max = 5}

    -- PLAYER SPAWN LOCATION from parameters
    SPAWN_X = x
    SPAWN_Y = y
    self.x = x
    self.y = y

    -- player starts in the air
    self.grounded = false

    -- Sprite information
    self.sprite_width = 32
    self.sprite_height = 32
    self.sprite_x = self.x - self.sprite_width/2 + 2
    self.sprite_y = self.y - self.sprite_height/2

    -- Body info
    self.body_width = 10
    self.body_height = 20

     -- Player is initialized facing to the right.
    self.direction = 1  -- to the right (Will be determined with constructor parameters)

    -- Speeds are stored in a table to allow tweening
    self.speeds = {dx = 0, dy = 0}

    self.physics = self:initializePhysics()
    self.states = self:initializeStateMachine()

    -- Hero begins in idle state
    self.states:change('idle', {
      hero = self
    })
    -- Consider initializing in fall states
    -- self.states:change('fall')

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
  self.score = self.score + 10
end

function Hero:update(dt)

  self.states:update(dt)

  -- Move to state files individually
  self:updateSprite()

  -- Handle respawn on death
  self:respawn()

  -- reset keys pressed
  --love.keyboard.keysPressed = {}

end

function Hero:updateSprite()
  -- Update hero origin coordinates
  self.sprite_x = self.x - self.sprite_width/2 + 2
  self.sprite_y = self.y - self.sprite_height/2
end

function Hero:render()
  -- Renders correct hero animation based on state.
  self.states:render()

  self:debug()

end


-- Move to hero debug and refactor
function Hero:debug()
  if debug_active then
    --THIS IS BAD AND I HATE IT
    -- Update body coordinates (For Debug only!)
    self.body_x = self.physics.body:getX() - self.body_width/2
    self.body_y = self.physics.body:getY() - self.body_height/2

    drawCenter(self)
    drawSpriteBounds(self)
    drawCollisionBounds(self)
  end
end

-- Change name to respawn on death
-- Eventually to be tied to checkpoints
function Hero:respawn()
  if not self.alive then
    self.physics.body:setPosition(SPAWN_X, SPAWN_Y)
    self.health.current = self.health.max
    self.alive = true
    self.states:change('idle', {
      hero = self
    })
    self.speeds.dy = 5
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
  elseif self.states.current.NAME == 'run' or self.states.current.NAME == 'walk' then
    -- do nothing
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

function Hero:initializePhysics()
  -- Physics attribute table using love.physics
  local physics = {}
  physics.body = love.physics.newBody(World, self.x, self.y, 'dynamic')
  physics.body:setFixedRotation(true)
  physics.shape = love.physics.newRectangleShape(self.body_width, self.body_height) -- By default, the local origin is located at the center of the rectangle as opposed to the top left for graphics.
  physics.fixture = love.physics.newFixture(physics.body, physics.shape)
  physics.fixture:setUserData('Hero')
  physics.body:setGravityScale(0)
  return physics
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
