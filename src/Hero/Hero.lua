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

function Hero:init()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Consider adding acceleration and friction

    --THESE ARE ACTUALLY SPRITE DIMENSIONS NOT CHARACTER HIT BOX. PLEASE FIX
    self.width = 32
    self.height = 32

    self.body_width = 14
    self.body_height = 19

    -- PLAYER SPAWN LOCATION (Will be determined with constructor parameters)
    self.x = 96 + self.width/2
    self.y = 0 + self.height/2

    -- Initialize hero origin coordinates, adjusted for box2d
    self.x_origin = self.x - self.width/2
    self.y_origin = self.y - self.height/2

    -- Body is a set distance from sprite borders
    self.body_x = self.x_origin + 6
    self.body_y = self.y_origin + 7

    -- Speeds are stored in a table to allow tweening
    self.speeds = {dx = 0, dy = 5}

    -- Player starts in an idle state and facing to the right
    --self.state = 'idle'

     -- Player is initialized facing to the right.
    self.direction = 1  -- to the right (Will be determined with constructor parameters)

    -- Need to add guides/outlines as overlays to represent hero sprite and body respectively
    -- Physics attribute table using love.physics
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, 'dynamic')
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.body_width, self.body_height) -- Magic numbers (FIX)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

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

-- Syncs hero physics body and image for display
-- Consider moving into heroPhysics.lua
function Hero:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.speeds.dx,self.speeds.dy)
end

function Hero:update(dt)

  -- Update hero origin coordinates
  self.x_origin = self.x - self.width/2
  self.y_origin = self.y - self.height/2

  -- Update body coordinates
  self.body_x = self.x_origin + 6
  self.body_y = self.y_origin + 7

  -- Updates animation frame over time based on current state
  updateAnimation(self.states.current.animation, dt)

  -- Update physics (needs combining/ reorganizing)
  self:syncPhysics()
  updatePhysics(hero, self.states.current, dt)

  -- Updated controls organization... not a fan still
  heroControls()

  -- reset keys pressed
  love.keyboard.keysPressed = {}

  -- Update global timer found in dependencies. This is used for timing and tweening
  Timer.update(dt)

end

function Hero:render()
  -- Renders correct hero animation based on state.
  renderAnimation(self.states.current.animation, self.x_origin, self.y_origin, self.direction)
  if debug_active then
    self:drawCenter()
    self:drawSpriteBounds()
    self:drawCollisionBounds()
    self:ProtectFromFall()
  end

end


function Hero:drawCenter()
  love.graphics.setColor(1, 0, 0) -- Black point.
  love.graphics.points(roundPositionX(self.x), roundPositionY(self.y))
  love.graphics.setColor(1, 1, 1)
end

function Hero:drawSpriteBounds()
  love.graphics.setColor(1, 0, 0, .25)
  love.graphics.rectangle('fill', roundPositionX(self.x_origin), roundPositionY(self.y_origin), self.width, self.height)
  love.graphics.setColor(1, 1, 1, 1)
end

function Hero:drawCollisionBounds()
  love.graphics.setColor(0, 1, 0, .25)
  love.graphics.rectangle('fill', roundPositionX(self.body_x), roundPositionY(self.body_y), self.body_width, self.body_height)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.points(roundPositionX(self.physics.body:getX()), roundPositionY(self.physics.body:getY()))
  love.graphics.setColor(1, 1, 1, 1)
end

function Hero:ProtectFromFall()
  if self.y > 256 then
    self.physics.body:setPosition(96 + self.width/2, 0 + self.height/2)
    self.states:change('idle')
    self.speeds.dy = 5
  end
end
