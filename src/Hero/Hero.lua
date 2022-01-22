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
    -- self.image = gCharFrames['finn'][1]
    self.x = VIRTUAL_WIDTH / 2 - 16
    self.y = VIRTUAL_HEIGHT / 2 - 16

    -- Consider adding acceleration and friction

    self.width = 32
    self.height = 32

    self.current_frame = 1
    -- self.dx = 0
    -- self.dy = 0

    self.speeds = {dx = 0, dy = 0}

    -- Player starts in an idle state and facing to the right
    -- Store states in a table or... use a statemachine file... statemachine is probably better
     self.state = 'idle'
    -- self.previous state

    self.direction = 1  -- to the right

    --

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, 'dynamic')
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
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

    heroState:change('idle', {
        x = self.x,
        y = self.y,
        direction = self.direction,
        dx = self.dx,
        dy = self.dy
    })

end

function Hero:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.speeds.dx,self.speeds.dy)
end

function Hero:update(dt)

  heroState:update(dt)
  self:syncPhysics()

  --LEGACY PHSYICS
  updatePhysics(hero, heroState.current, dt)

  -- reset keys pressed
  love.keyboard.keysPressed = {}

  -- Update global timer found in dependencies. This is used for timing and tweening
  Timer.update(dt)

end


-- Renders player based on state

function Hero:render()

  heroState:render()

end
