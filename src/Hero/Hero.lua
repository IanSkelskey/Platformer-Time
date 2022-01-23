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
]]

Hero = Class{}

function Hero:init()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Consider adding acceleration and friction

    --THESE ARE ACTUALLY SPRITE DIMENSIONS NOT CHARACTER HIT BOX. PLEASE FIX
    self.width = 32
    self.height = 32

    -- PLAYER SPAWN LOCATION (Will be determined with constructor parameters)
    self.x = 96 + self.width/2
    self.y = 0 + self.height/2

    -- Speeds are stored in a table to allow tweening
    self.speeds = {dx = 0, dy = 5}

    -- Player starts in an idle state and facing to the right
    self.state = 'idle'

     -- Player is initialized facing to the right.
    self.direction = 1  -- to the right (Will be determined with constructor parameters)

    -- Physics attribute table using love.physics
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, 'dynamic')
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(14, 22) -- Magic numbers (FIX)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    -- initialize state machine with all state-returning functions
    heroState = StateMachine {
        ['idle'] = function() return IdleState() end,
        ['walk'] = function() return WalkState() end,
        ['run'] = function() return RunState() end,
        ['sprint'] = function() return SprintState() end,
        ['jump'] = function() return JumpState() end,
        ['skid'] = function() return SkidState() end
    }

    heroState:change('idle')

end

-- Syncs hero physics body and image for display
-- Consider moving into heroPhysics.lua
function Hero:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.speeds.dx,self.speeds.dy)
end

function Hero:update(dt)

  updateAnimation(heroState.current.animation, dt)
  heroState:update(dt)

  self:syncPhysics()

  updatePhysics(hero, heroState.current, dt)

  -- reset keys pressed
  love.keyboard.keysPressed = {}

  -- Update global timer found in dependencies. This is used for timing and tweening
  Timer.update(dt)

end


-- Renders player based on state

function Hero:render()
  renderAnimation(heroState.current.animation, hero.x - hero.width/2, hero.y - hero.height/2, hero.direction)

end
