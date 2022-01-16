local curr_state = nil
local prev_state = nil

function idleControls()
  trackStates()
  -- IDLESTATE KEYBOARD CONTROLS
  if love.keyboard.wasPressed('right') then

    heroState:change('walk', {
        x = curr_state.x,
        y = curr_state.y,
        direction = 1,
        dx = curr_state.dx,
        dy = curr_state.dy
    })

  elseif love.keyboard.wasPressed('left') then

    heroState:change('walk', {
        x = curr_state.x,
        y = curr_state.y,
        direction = -1
    })

  elseif love.keyboard.wasPressed('up') then
    heroState:change('jump', {
      x = curr_state.x,
      y = curr_state.y,
      direction = curr_state.direction,
      dx = 0
    })
  end

end

function walkControls()
  trackStates()
  -- WALKSTATE KEYBOARD CONTROLS

  if love.keyboard.isDown('left') and curr_state.direction == 1 and not love.keyboard.isDown('right') then
    curr_state.direction = -1
  end

  if love.keyboard.isDown('right') and curr_state.direction == -1 and not love.keyboard.isDown('left') then
    curr_state.direction = 1
  end

  -- if we somehow get to the walk state and neither left or right is pressed,
  -- leave the walk state.
  if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    heroState:change('idle', {
        x = curr_state.x,
        y = curr_state.y,
        dx = 0,
        dy = 0,
        direction = curr_state.direction
      })
  end

  if love.keyboard.wasPressed('lshift') or love.keyboard.isDown('lshift') then
    heroState:change('run', {
      x = curr_state.x,
      y = curr_state.y,
      direction = curr_state.direction,
      dx = curr_state.dx,
      dy = curr_state.dy
    })
  elseif love.keyboard.wasPressed('up') then
    heroState:change('jump', {
      x = curr_state.x,
      y = curr_state.y,
      direction = curr_state.direction,
      dx = curr_state.dx,
      dy = curr_state.dy
    })
  end

end

function runControls()
  trackStates()
  -- RUNSTATE KEYBOARD CONTROLS
  if not love.keyboard.isDown('lshift') then
    heroState:change('walk', {
        x = curr_state.x,
        y = curr_state.y,
        direction = 1,
        dx = curr_state.dx,
        dy = curr_state.dy
    })
  end
  if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    heroState:change('idle', {
        x = curr_state.x,
        y = curr_state.y,
        dx = 0,
        dy = 0,
        direction = curr_state.direction
      })
  end
  if love.keyboard.isDown('left') and curr_state.direction == 1 and not love.keyboard.isDown('right') then
    curr_state.direction = -1
  end
  if love.keyboard.isDown('right') and curr_state.direction == -1 and not love.keyboard.isDown('left') then
    curr_state.direction = 1
  end
  if love.keyboard.wasPressed('up') then
    heroState:change('jump', {
      x = curr_state.x,
      y = curr_state.y,
      direction = curr_state.direction,
      dx = curr_state.dx,
      dy = curr_state.dy
    })
  end
end

function jumpControls()
  trackStates()
  -- JUMPSTATE KEYBOARD CONTROLS
  if curr_state.dy == 0 and curr_state.y == VIRTUAL_HEIGHT - 42 then
    heroState:change(prev_state.NAME, {
      x = curr_state.x,
      y = curr_state.y,
      direction = curr_state.direction
    })
  end
end

function handleKeyReleases()

-- KEY RELEASED FUNCTIONALITY
  function love.keyreleased(key)

    if curr_state.NAME == 'idle' then

    elseif curr_state.NAME == 'walk' then
      if key == 'right' and curr_state.direction == 1 then
        if love.keyboard.isDown('left') then
          curr_state.direction = -1
        else
          heroState:change('idle', {
              x = curr_state.x,
              y = curr_state.y,
              dx = 0,
              dy = 0
              -- direction = 1
            })
        end
      elseif key == 'left' and curr_state.direction == -1 then
        if love.keyboard.isDown('right') then
          curr_state.direction = 1
        else
          heroState:change('idle', {
              x = curr_state.x,
              y = curr_state.y,
              dx = 0,
              dy = 0,
              direction = -1
            })
        end
      end
    elseif curr_state.NAME == 'run' then

      if key == 'right' and curr_state.direction == 1 then
        if love.keyboard.isDown('left') then
          curr_state.direction = -1
        else
          heroState:change('idle', {
              x = curr_state.x,
              y = curr_state.y,
              dx = 0,
              dy = 0
              -- direction = 1
            })
        end
      elseif key == 'left' and curr_state.direction == -1 then
        if love.keyboard.isDown('right') then
          curr_state.direction = 1
        else
          heroState:change('idle', {
              x = curr_state.x,
              y = curr_state.y,
              dx = 0,
              dy = 0,
              direction = -1
            })
        end
      elseif key == 'lshift' then
        heroState:change('walk', {
          x = curr_state.x,
          y = curr_state.y,
          dx = curr_state.dx,
          dy = curr_state.dy,
          direction = curr_state.direction
        })
      end
    elseif curr_state.BANE == 'jump' then

    end

  end -- END KEYRELEASED

end

function trackStates()
  curr_state = heroState.current
  prev_state = heroState.previous
end
