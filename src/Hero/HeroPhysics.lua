-- Constants that define a hero
-- Physics constants
local WALK_SPEED = 40
local RUN_SPEED = 80
-- local JUMP_SPEED = -4.5  --NOW IN JumpState
local GRAVITY = 20
-- Collision boundaries
local BOUNDING_WIDTH = 12
local BOUNDING_HEIGHT = 16

function roundPositionX(coordinate)
  if hero.direction == 1 then
    return math.ceil(coordinate)
  else
    return math.floor(coordinate)
  end
end

function roundPositionY(coordinate)
  if hero.speeds.dy < 0 then
    return math.ceil(coordinate)
  else
    return math.floor(coordinate)
  end
end

function updatePhysics(char, curr_state, dt)

  -- Temporary way to stop at floor of 'level'
  -- need to define actual collision
  if char.y > VIRTUAL_HEIGHT - 42 then -- Below the ground
    char.speeds.dy = 0
    char.y = VIRTUAL_HEIGHT - 42
  elseif char.y == VIRTUAL_HEIGHT - 42 then -- On the ground
    char.speeds.dy = 0
  else
    -- Apply gravity always
    char.speeds.dy = char.speeds.dy + GRAVITY * dt -- Above the ground (room to fall)
  end




  -- Update x position based on dx and dt
  char.x = roundPositionX(char.x + char.speeds.dx*dt)
  -- and for y direction
  char.y = roundPositionY(char.y + char.speeds.dy)


  -- Make State Match Hero

  curr_state.x = char.x
  curr_state.y = char.y

  curr_state.dx = char.speeds.dx
  curr_state.dy = char.speeds.dy

  char.direction = curr_state.direction
  -- Update char physics based on states

  if curr_state.NAME == 'walk' then
    char.speeds.dx = char.direction * WALK_SPEED
  elseif curr_state.NAME == 'idle' then
    char.speeds.dx = 0
  elseif curr_state.NAME == 'run' then
    char.speeds.dx = char.direction * RUN_SPEED
  elseif curr_state.NAME == 'jump' then

  end


end
