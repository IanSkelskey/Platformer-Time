NewHeroController = Class{}

local RUN_KEY = 'lshift'
active_move_key = 'none'
run_toggle = false

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
    print('left')
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
