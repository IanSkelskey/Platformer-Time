NewHeroController = Class{}

local RUN_KEY = 'lshift'
local active_move_key = 'none'
local run_toggle = false

-- Hero to control goes here.
local controlled = nil

function NewHeroController:init(char)
  controlled = char
end

function NewHeroController:update()

  -- Solution to make controls emulate a d-pad or joystick.
  -- Only one direction at a time,
  if love.keyboard.wasPressed('right') then
    print('right')
    active_move_key = 'right'
    controlled.direction = 1
  elseif love.keyboard.wasPressed('left') then
    active_move_key = 'left'
    controlled.direction = -1
  end

  if love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    active_move_key = 'right'
    controlled.direction = 1
  end

  if love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    active_move_key = 'left'
    controlled.direction = -1
  end

  if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    active_move_key = 'none'
  end

  if love.keyboard.isDown(RUN_KEY) then
    run_toggle = true
  else
    run_toggle = false
  end

end

function NewHeroController:idle()
  -- IDLESTATE KEYBOARD CONTROLS
  if active_move_key == 'right' then
    controlled.states:change('walk')
  elseif active_move_key == 'left' then
    controlled.states:change('walk')
  end

  if love.keyboard.wasPressed('up') and controlled.grounded then
    controlled.states:change('jump')
  end

end

function NewHeroController:walk()
  -- WALKSTATE KEYBOARD CONTROLS
  if active_move_key == 'none' then
    controlled.states:change('idle')
  end

  if run_toggle then
    controlled.states:change('run')
  elseif love.keyboard.wasPressed('up') and controlled.grounded then
    controlled.states:change('jump')
  end

end

function NewHeroController:run()
  -- RUNSTATE KEYBOARD CONTROLS
  if not run_toggle then
    controlled.states:change('walk')
  end
  if active_move_key == 'none' then
    controlled.states:change('idle')
  end
  if love.keyboard.wasPressed('up') and controlled.grounded then
    controlled.states:change('jump')
  end
end

-- THIS NEEDS FIXING
function NewHeroController:jump()
  if active_move_key == 'left' then
    controlled.direction = -1
    moveX() -- move to state files?
  elseif active_move_key == 'right' then
    controlled.direction = 1
    moveX() -- move to state files?
  end
end
