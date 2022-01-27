-- Constants that define a hero
-- Physics constants
local WALK_SPEED = 40
local RUN_SPEED = 80
local ACCELERATION = 500
local FRICTION = 400
local JUMP_SPEED = -375
local GRAVITY = 1000
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
  --char.physics.body:setX(roundPositionX(char.physics.body:getX() + char.speeds.dx*dt))
  -- and for y direction
  --char.physics.body:setY(roundPositionY(char.physics.body:getY() + char.speeds.dy))

  --char.x = roundPositionX(char.x)
  --char.y = roundPositionY(char.y)

  if not hero.grounded then
    -- Apply gravity when player is off the ground
    hero.speeds.dy = hero.speeds.dy + GRAVITY * dt -- Above the ground (room to fall)
  end

  statePhysics(char, curr_state.NAME, dt)



end

function statePhysics(hero, hero_state_name, dt)
  if hero_state_name == 'walk' then
    hero.speeds.dx = hero.direction * WALK_SPEED
  elseif hero_state_name == 'idle' then
    hero.speeds.dx = 0
  elseif hero_state_name == 'run' then
    hero.speeds.dx = hero.direction * RUN_SPEED
  elseif hero_state_name == 'jump' then
    if hero.speeds.dy == 0 then
      hero.states:change(hero.states.previous.NAME)
    end
  end
end

function jump(hero)
  hero.y = hero.y - 1
  hero.speeds.dy = JUMP_SPEED
  hero.grounded = false
end
