NewHeroController = Class{}

local RUN_KEY = 'lshift'
active_move_key = 'none' -- should not be global
run_toggle = false -- should not be global

local controlled = nil

function NewHeroController:init(char)
  controlled = char
end

function NewHeroController:update()
  if love.keyboard.wasPressed('right') then
    active_move_key = 'right'
  elseif love.keyboard.wasPressed('left') then
    active_move_key = 'left'
  end

  if love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    active_move_key = 'right'
  end

  if love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
    active_move_key = 'left'
  end

  if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    active_move_key = 'none'
  end

  self:updateDirection()

  self:listenForRunToggle()

  if love.keyboard.wasPressed('g') then
    controlled.grounded = not controlled.grounded
  end

end

function NewHeroController:listenForRunToggle()
  if love.keyboard.isDown(RUN_KEY) then
    run_toggle = true
  else
    run_toggle = false
  end
end


function NewHeroController:updateDirection()
  if active_move_key == 'left' then controlled.direction = -1 end
  if active_move_key == 'right' then controlled.direction = 1 end
end
