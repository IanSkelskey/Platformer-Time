local curr_state = nil
local prev_state = nil

function idleControls()
  trackStates()
  -- IDLESTATE KEYBOARD CONTROLS
  if love.keyboard.wasPressed('right') then
    hero.direction = 1
    heroState:change('walk')

  elseif love.keyboard.wasPressed('left') then

    hero.direction = -1
    heroState:change('walk')

  elseif love.keyboard.wasPressed('up') then

    heroState:change('jump')
  end

end

function walkControls()
  trackStates()
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
    heroState:change('idle')
  end

  if love.keyboard.wasPressed('lshift') or love.keyboard.isDown('lshift') then
    heroState:change('run')
  elseif love.keyboard.wasPressed('up') then
    heroState:change('jump')
  end

end

function runControls()
  trackStates()
  -- RUNSTATE KEYBOARD CONTROLS
  if not love.keyboard.isDown('lshift') then
    heroState:change('walk')
  end
  if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    heroState:change('idle')
  end
  if love.keyboard.isDown('left') and hero.direction == 1 and not love.keyboard.isDown('right') then
    hero.direction = -1
  end
  if love.keyboard.isDown('right') and hero.direction == -1 and not love.keyboard.isDown('left') then
    hero.direction = 1
  end
  if love.keyboard.wasPressed('up') then
    heroState:change('jump')
  end
end

function jumpControls()
  trackStates()
  -- JUMPSTATE KEYBOARD CONTROLS
  if hero.dy == 0 and hero.y == VIRTUAL_HEIGHT - 42 then
    heroState:change(prev_state.NAME)
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
          heroState:change('idle')
        end
      elseif key == 'left' and hero.direction == -1 then
        if love.keyboard.isDown('right') then
          hero.direction = 1
        else
          heroState:change('idle')
        end
      end
    elseif curr_state.NAME == 'run' then

      if key == 'right' and hero.direction == 1 then
        if love.keyboard.isDown('left') then
          hero.direction = -1
        else
          heroState:change('idle')
        end
      elseif key == 'left' and hero.direction == -1 then
        if love.keyboard.isDown('right') then
          hero.direction = 1
        else
          heroState:change('idle')
        end
      elseif key == 'lshift' then
        heroState:change('walk')
      end
    elseif curr_state.NAME == 'jump' then

    end

  end -- END KEYRELEASED

end

function trackStates()
  curr_state = heroState.current
  prev_state = heroState.previous
end
