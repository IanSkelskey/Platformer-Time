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
    -- PLAYER SPAWN LOCATION from parameters
    SPAWN_X = x
    SPAWN_Y = y
    self.x = x
    self.y = y

    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

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
    self.speeds = {dx = 0, dy = 5}

    -- Need to add guides/outlines as overlays to represent hero sprite and body respectively
    -- Physics attribute table using love.physics
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, 'dynamic')
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.body_width, self.body_height) -- By default, the local origin is located at the center of the rectangle as opposed to the top left for graphics.
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.fixture:setUserData('Hero')

    -- initialize state machine with all state-returning functions
    self.states = StateMachine {
        ['idle'] = function() return IdleState() end,
        ['walk'] = function() return WalkState() end,
        ['run'] = function() return RunState() end,
        ['sprint'] = function() return SprintState() end,
        ['jump'] = function() return JumpState() end,
        ['skid'] = function() return SkidState() end
    }

    -- Hero begins in idle state
    self.states:change('idle')

end

function Hero:update(dt)

  self:updateSprite()

  -- Updates animation frame over time based on current state
  updateAnimation(self.states.current.animation, dt)

  updatePhysics(self, self.states.current, dt)

  -- Updated controls organization... not a fan still
  heroControls()

  -- reset keys pressed
  love.keyboard.keysPressed = {}

  -- Update global timer found in dependencies. This is used for timing and tweening
  Timer.update(dt)

end

function Hero:updateSprite()
  -- Update hero origin coordinates
  self.sprite_x = self.x - self.sprite_width/2 + 2
  self.sprite_y = self.y - self.sprite_height/2
end

function Hero:render()
  -- Renders correct hero animation based on state.
  renderAnimation(self.states.current.animation, self.sprite_x, self.sprite_y, self.direction)

  self:debug()

end



function Hero:debug()
  if debug_active then
    --THIS IS BAD AND I HATE IT

    -- Update body coordinates (For Debug only!)
    self.body_x = self.physics.body:getX() - self.body_width/2
    self.body_y = self.physics.body:getY() - self.body_height/2

    self:drawCenter()
    self:drawSpriteBounds()
    self:drawCollisionBounds()


  end
end

function Hero:drawCenter()
  love.graphics.setColor(1, 0, 0) -- Black point.
  love.graphics.points(self.x, self.y)
  love.graphics.setColor(1, 1, 1)
end

function Hero:drawSpriteBounds()
  love.graphics.setColor(1, 0, 0, .25)
  love.graphics.rectangle('fill', self.sprite_x, self.sprite_y, self.sprite_width, self.sprite_height)
  love.graphics.setColor(1, 1, 1, 1)
end

function Hero:drawCollisionBounds()
  love.graphics.setColor(0, 1, 0, .25)
  love.graphics.rectangle('fill', self.body_x, self.body_y, self.body_width, self.body_height)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.points(self.physics.body:getX(), self.physics.body:getY())
  love.graphics.setColor(1, 1, 1, 1)
end


function Hero:respawn()
    self.physics.body:setPosition(SPAWN_X, SPAWN_Y)
    self.states:change('idle')
    self.speeds.dy = 5
end

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

function Hero:land(collision)
  self.currentGroundCollision = collision
  if (self.states.previous.NAME ~= nil and self.states.previous.NAME ~= 'jump') or self.states.current.NAME == 'jump' then
    print('self.states.previous.NAME ~= nil or == jump')
    self.states:change(self.states.previous.NAME)
  elseif self.states.current.NAME == 'run' or self.states.current.NAME == 'walk' then
    -- do nothing
  else
    self.states:change('idle')
  end
  self.speeds.dy = 0
  self.grounded = true
end

function Hero:endContact(a, b, collision)
  if a == self.physics.fixture or b == self.physics.fixture then
    if self.currentGroundCollision == collision then
      self.grounded = false
    end
  end
end
