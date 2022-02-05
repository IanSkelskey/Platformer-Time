-- Constants that define a char
-- Physics constants
local WALK_SPEED = 60
local RUN_SPEED = 100
-- local ACCELERATION = 500
-- local FRICTION = 400
local JUMP_SPEED = -375
local GRAVITY = 1000

-- Physics for the char are defined here.
function updatePhysics(char, curr_state, dt)

  -- originally sync physics from tutorial by devjeeper
  char.x, char.y = char.physics.body:getPosition()
  char.physics.body:setLinearVelocity(char.speeds.dx,char.speeds.dy)

  if not char.grounded then
    -- Apply gravity when player is off the ground
    char.speeds.dy = char.speeds.dy + GRAVITY * dt -- Above the ground (room to fall)
  end

  statePhysics(char, curr_state.NAME, dt)

end

function statePhysics(char, char_state_name, dt)
  if char_state_name == 'walk' or char_state_name == 'run' then
    moveX(char, char.direction) --move to state files?
  elseif char_state_name == 'idle' then
    char.speeds.dx = 0
  elseif char_state_name == 'jump' then
    if char.grounded then
      char.states:change(char.states.previous.NAME)
    end
  end
end

function jump(char)
  char.y = char.y - 1
  char.speeds.dy = JUMP_SPEED
  char.grounded = false
end

function moveX(char, direction)
  if char.states.current.NAME == 'walk' then
    char.speeds.dx = char.direction * WALK_SPEED
  elseif char.states.current.NAME == 'run' then
    char.speeds.dx = char.direction * RUN_SPEED
elseif char.states.current.NAME == 'jump' then
    if char.states.previous.NAME == 'walk' or char.states.previous.NAME == 'idle' then
      char.speeds.dx = char.direction * WALK_SPEED
    elseif char.states.previous.NAME == 'run' then
      char.speeds.dx = char.direction * RUN_SPEED
    end
  end
end
