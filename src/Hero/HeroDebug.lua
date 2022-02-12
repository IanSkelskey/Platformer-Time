function drawCenter(char)
  love.graphics.setColor(1, 0, 0) -- Black point.
  love.graphics.points(char.x, char.y)
  love.graphics.setColor(1, 1, 1)
end

function drawSpriteBounds(char)
  love.graphics.setColor(1, 0, 0, .25)
  love.graphics.rectangle('fill', char.sprite_x, char.sprite_y, char.sprite_width, char.sprite_height)
  love.graphics.setColor(1, 1, 1, 1)
end

function drawCollisionBounds(char)
  love.graphics.setColor(0, 1, 0, .25)
  love.graphics.rectangle('fill', char.body_x, char.body_y, char.body_width, char.body_height)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.points(char.physics.body:getX(), char.physics.body:getY())
  love.graphics.setColor(1, 1, 1, 1)
end
