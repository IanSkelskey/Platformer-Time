local curr_state = nil
local prev_state = nil

-- a hero should be passed in as a parameter so it can be renamed elsewhere
-- and for general reusability
local active_move_key = 'none'
local is_running = false
function heroControls()
  -- Solution to make controls emulate a d-pad or joystick.
  -- Only one direction at a time,
  if love.keyboard.wasPressed('right') then
    active_move_key = 'right'
  elseif love.keyboard.wasPressed('left') then
    active_move_key = 'left'
  end

  if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    active_move_key = 'none'
  end

  if love.keyboard.isDown('lshift') then
    is_running = true
  else
    is_running = false
  end

  trackStates()

  chooseStateControls()

  -- Consider adding this back in.. need to rename
  -- respawn to respawn on death or something...
  if love.keyboard.wasPressed('space') and debug_active then
    hero:respawn()
  end


end

function idleControls()
  -- IDLESTATE KEYBOARD CONTROLS
  if active_move_key == 'right' then
    hero.direction = 1
    hero.states:change('walk')

  elseif active_move_key == 'left' then

    hero.direction = -1
    hero.states:change('walk')

  end

  if love.keyboard.wasPressed('up') then
    hero.states:change('jump')
  end

end

function walkControls()
  -- WALKSTATE KEYBOARD CONTROLS

  if active_move_key == 'left' then
    hero.direction = -1
  end

  if active_move_key == 'right' then
    hero.direction = 1
  end

  -- if we somehow get to the walk state and neither left or right is pressed,
  -- leave the walk state.
  if active_move_key == 'none' then
    hero.states:change('idle')
  end

  if is_running then
    hero.states:change('run')
  elseif love.keyboard.wasPressed('up') and hero.grounded then
    hero.states:change('jump')
  end

end

function runControls()
  -- RUNSTATE KEYBOARD CONTROLS
  if not is_running then
    hero.states:change('walk')
  end
  if active_move_key == 'none' then
    hero.states:change('idle')
  end
  if active_move_key == 'left' then
    hero.direction = -1
  end
  if active_move_key == 'right' then
    hero.direction = 1
  end
  if love.keyboard.wasPressed('up') and hero.grounded then
    hero.states:change('jump')
  end
end

function jumpControls()

  if active_move_key == 'left' then
    hero.direction = -1
    moveX(hero, hero.direction) -- move to state files?
  elseif active_move_key == 'right' then
    hero.direction = 1
    moveX(hero, hero.direction) -- move to state files?
  end
end

function trackStates()
  curr_state = hero.states.current
  prev_state = hero.states.previous
end

function chooseStateControls()
  if curr_state.NAME == 'idle' then
    idleControls()
  elseif curr_state.NAME == 'walk' then
    walkControls()
  elseif curr_state.NAME == 'run' then
    runControls()
  elseif curr_state.NAME == 'jump' then
    jumpControls()
  end
end
