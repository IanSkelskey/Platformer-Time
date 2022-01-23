-- Constants that define a hero
-- Physics constants
local WALK_SPEED = 40
local RUN_SPEED = 80
-- local JUMP_SPEED = -4.5  --NOW IN JumpState
local GRAVITY = 20
-- Collision boundaries
local BOUNDING_WIDTH = 12
local BOUNDING_HEIGHT = 16

-- Rounding functions to avoid weird bluring from fractional x and y values
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

-- Physics for the hero are defined here.
function updatePhysics(char, curr_state, dt)
  -- Update x position based on dx and dt
  char.physics.body:setX(roundPositionX(char.physics.body:getX() + char.speeds.dx*dt))
  -- and for y direction
  char.physics.body:setY(roundPositionY(char.physics.body:getY() + char.speeds.dy))

  char.x = roundPositionX(char.x)
  char.y = roundPositionY(char.y)


  if curr_state.NAME == 'walk' then
    char.speeds.dx = char.direction * WALK_SPEED
  elseif curr_state.NAME == 'idle' then
    char.speeds.dx = 0
  elseif curr_state.NAME == 'run' then
    char.speeds.dx = char.direction * RUN_SPEED
  elseif curr_state.NAME == 'jump' then
    -- Apply gravity always
    char.speeds.dy = char.speeds.dy + GRAVITY * dt -- Above the ground (room to fall)
  end


end
