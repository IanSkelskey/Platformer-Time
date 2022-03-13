HeroDebugger = Class{}

local controlled = nil

function HeroDebugger:init(char)
  controlled = char
end

function HeroDebugger:render()
    self:drawCollisionComponents()
    self:drawSpriteComponents()
    self:displayHUDInformation()
end

function HeroDebugger:drawSpriteComponents()
  self:drawSpriteCenter()
  self:drawSpriteOrigin()
  self:drawSpriteBounds()
end

function HeroDebugger:drawCollisionComponents()
  self:drawCollisionBounds()
  self:drawCollisionBoundsCenter()
end

function HeroDebugger:drawSpriteCenter()
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.points(controlled.body_center_x, controlled.body_center_y)
  love.graphics.setColor(1, 1, 1, 1)
end

function HeroDebugger:drawSpriteOrigin()
  love.graphics.setColor(1, 0, 0, 1) -- Black point.
  love.graphics.points(controlled.sprite_x, controlled.sprite_y)
  love.graphics.setColor(1, 1, 1, 1)
end

function HeroDebugger:drawSpriteBounds()
  love.graphics.setColor(1, 0, 0, .25)
  love.graphics.rectangle('fill', controlled.sprite_x, controlled.sprite_y, controlled.sprite_width, controlled.sprite_height)
  love.graphics.setColor(1, 1, 1, 1)
end

function HeroDebugger:drawCollisionBounds()
  love.graphics.setColor(0, 1, 0, .25)
  love.graphics.rectangle('fill', controlled.body_center_x - controlled.body_width/2, controlled.body_center_y-controlled.body_height/2, controlled.body_width, controlled.body_height)
  love.graphics.setColor(1, 1, 1, 1)
end

function HeroDebugger:drawCollisionBoundsCenter()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.points(controlled.body_center_x, controlled.body_center_y)
end

function HeroDebugger:displayHUDInformation()
  HeroCam:clear()
  -- simple FPS display across all states
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 15, VIRTUAL_HEIGHT - 10)
  love.graphics.print('Hero state: ' .. tostring(controlled.states.current.NAME), 15, VIRTUAL_HEIGHT - 20)
  love.graphics.print('grounded?: ' .. tostring(controlled.grounded), 15, VIRTUAL_HEIGHT - 30)

  love.graphics.print('Hero dx: ' .. tostring(controlled.speeds.dx), 108, VIRTUAL_HEIGHT - 10)
  love.graphics.print('Hero dy: ' .. tostring(math.ceil(controlled.speeds.dy)), 108, VIRTUAL_HEIGHT - 20)
  love.graphics.print('Hero Center Position: (' .. tostring(controlled.body_center_x) .. ', ' .. tostring(controlled.body_center_y .. ")"), 170, VIRTUAL_HEIGHT - 20)

  love.graphics.print('Hero Spawn Position: (' .. tostring(controlled.last_spawn_location_x) .. ', ' .. tostring(controlled.last_spawn_location_y .. ")"), 170, VIRTUAL_HEIGHT - 30)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts['medium'])
  HeroCam:apply()

end
