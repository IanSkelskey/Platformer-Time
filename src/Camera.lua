local Camera = {
  x = 0,
  y = 0,
  scale = 1,
}

function Camera:apply()
  love.graphics.push()
  love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
  love.graphics.pop()
end

function Camera:setPosition(x, y)
  self.x = x - VIRTUAL_WIDTH/2
  self.y = y
end

return Camera
