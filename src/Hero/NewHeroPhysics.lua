NewHeroPhysics = Class{}

-- Constants that define a controlled
-- Physics constants
local WALK_SPEED = 60
local RUN_SPEED = 100
-- local ACCELERATION = 500
-- local FRICTION = 400

local GRAVITY = 1000

-- Abbreviate relevant hero physics attributes
local controlled = nil
local body = nil
local dx = nil
local dy = nil
local grounded = nil
local direction = nil
local prev_state_name = nil
local curr_state_name = nil

function NewHeroPhysics:init(char)
  controlled = char
  body = controlled.physics.body
end

function NewHeroPhysics:update(dt)
  prev_state_name = controlled.states.previous.NAME
  curr_state_name = controlled.states.current.NAME
  -- Update certain attributes for convenience
  -- NOT TO BE USED TO UPDATE HERO ATTRIBUTES
  dx = controlled.speeds.dx
  dy = controlled.speeds.dy
  grounded = controlled.grounded
  direction = controlled.direction

  -- Update hero position to match its physics body as we update it.
  controlled.x, controlled.y = controlled.physics.body:getPosition()
  -- Get linear velocities for body from hero speed table
  body:setLinearVelocity(dx, dy)

-- Apply gravity when player is off the ground
  if not grounded then
    controlled.speeds.dy = dy + GRAVITY * dt -- Above the ground (room to fall)
  else
    controlled.speeds.dy = 0
  end

end
