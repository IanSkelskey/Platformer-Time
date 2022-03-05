NewHeroPhysics = Class{}

-- Constants that define a controlled
-- Physics constants
local WALK_SPEED = 60
local RUN_SPEED = 100
-- local ACCELERATION = 500
-- local FRICTION = 400
local JUMP_SPEED = -375
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

-- Execute once when entering the jump state
function NewHeroPhysics:jump()
  controlled.y = controlled.y - 1
  controlled.speeds.dy = JUMP_SPEED
  controlled.grounded = false
end

-- Execute continuously in update during jump state
function NewHeroPhysics:jumping()

  if prev_state_name == 'idle' then

  elseif prev_state_name == 'walk' then
    controlled.speeds.dx = direction * WALK_SPEED
  elseif prev_state_name == 'run' then
    controlled.speeds.dx = direction * RUN_SPEED
  end
end

function NewHeroPhysics:fall()
  controlled.grounded = false
end

-- Execute continuously in update during walk state
function NewHeroPhysics:walk()
  -- This may work to keep the hero grounded once the fall state is implemented.       !!!!
  -- Same goes for idle and run
  -- controlled.grounded = true
  controlled.speeds.dx = direction * WALK_SPEED
end

-- Execute continuously in update during run state
function NewHeroPhysics:run()
  -- controlled.grounded = true
  controlled.speeds.dx = direction * RUN_SPEED
end

-- Execute continuously in update during idle state
function NewHeroPhysics:idle()
  -- controlled.grounded = true
  controlled.speeds.dx = 0
end

-- LEGACY FUNCTION. PLEASE REPLACE AND DELETE
function moveX()
  if curr_state_name == 'jump' then
    if prev_state_name == 'walk' or prev_state_name == 'idle' then
      controlled.speeds.dx = direction * WALK_SPEED
    elseif prev_state_name == 'run' then
      controlled.speeds.dx = direction * RUN_SPEED
    end
  end
end
