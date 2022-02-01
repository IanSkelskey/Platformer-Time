local curr_state = nil
local prev_state = nil

-- a hero should be passed in as a parameter so it can be renamed elsewhere
-- and for general reusability

function heroControls()
  trackStates()
  if curr_state.NAME == 'idle' then
    idleControls()
  elseif curr_state.NAME == 'walk' then
    walkControls()
  elseif curr_state.NAME == 'run' then
    runControls()
  elseif curr_state.NAME == 'jump' then
    jumpControls()
  end
  if love.keyboard.wasPressed('space') and debug_active then
    hero:respawn()
  end
  handleKeyReleases()

end

function idleControls()
  -- IDLESTATE KEYBOARD CONTROLS
  if love.keyboard.wasPressed('right') then
    hero.direction = 1
    hero.states:change('walk')

  elseif love.keyboard.wasPressed('left') then

    hero.direction = -1
    hero.states:change('walk')

  elseif love.keyboard.wasPressed('up') then

    hero.states:change('jump')
  end

end

function walkControls()
  -- WALKSTATE KEYBOARD CONTROLS

  if love.keyboard.isDown('left') and hero.direction == 1 and not love.keyboard.isDown('right') then
    hero.direction = -1
  end

  if love.keyboard.isDown('right') and hero.direction == -1 and not love.keyboard.isDown('left') then
    hero.direction = 1
  end

  -- if we somehow get to the walk state and neither left or right is pressed,
  -- leave the walk state.
  if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    hero.states:change('idle')
  end

  if love.keyboard.wasPressed('lshift') or love.keyboard.isDown('lshift') then
    hero.states:change('run')
  elseif love.keyboard.wasPressed('up') and hero.grounded then
    hero.states:change('jump')
  end

end

function runControls()
  -- RUNSTATE KEYBOARD CONTROLS
  if not love.keyboard.isDown('lshift') then
    hero.states:change('walk')
  end
  if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    hero.states:change('idle')
  end
  if love.keyboard.isDown('left') and hero.direction == 1 and not love.keyboard.isDown('right') then
    hero.direction = -1
  end
  if love.keyboard.isDown('right') and hero.direction == -1 and not love.keyboard.isDown('left') then
    hero.direction = 1
  end
  if love.keyboard.wasPressed('up') and hero.grounded then
    hero.states:change('jump')
  end
end

function jumpControls()

  if love.keyboard.isDown('left') then
    hero.direction = -1
    moveX(hero, hero.direction)
  elseif love.keyboard.isDown('right') then
    hero.direction = 1
    moveX(hero, hero.direction)
  end
end

function handleKeyReleases()
-- KEY RELEASED FUNCTIONALITY
  function love.keyreleased(key)

    if curr_state.NAME == 'idle' then

    elseif curr_state.NAME == 'walk' then
      if key == 'right' and hero.direction == 1 then
        if love.keyboard.isDown('left') then
          hero.direction = -1
        else
          hero.states:change('idle')
        end
      elseif key == 'left' and hero.direction == -1 then
        if love.keyboard.isDown('right') then
          hero.direction = 1
        else
          hero.states:change('idle')
        end
      end
    elseif curr_state.NAME == 'run' then

      if key == 'right' and hero.direction == 1 then
        if love.keyboard.isDown('left') then
          hero.direction = -1
        else
          hero.states:change('idle')
        end
      elseif key == 'left' and hero.direction == -1 then
        if love.keyboard.isDown('right') then
          hero.direction = 1
        else
          hero.states:change('idle')
        end
      elseif key == 'lshift' then
        hero.states:change('walk')
      end
    elseif curr_state.NAME == 'jump' then

    end

  end -- END KEYRELEASED

end

function trackStates()
  curr_state = hero.states.current
  prev_state = hero.states.previous
end
