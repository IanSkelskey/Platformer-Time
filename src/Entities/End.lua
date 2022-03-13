End = Class{
  IMAGE = love.graphics.newImage("assets/images/end.png")
}

ActiveEnds = {}

function End:init(x, y)

  self.x = x
  self.y = y

  self.width = self.IMAGE:getWidth()
  self.height = self.IMAGE:getHeight()

  self.scaleX = 1

  -- Consider breaking out into function initializePhysics(Entity)
  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x + self.width/2, self.y + self.height/2, "static")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.fixture:setSensor(true)

  self.POINT_VALUE = 10

  table.insert(ActiveEnds, self)
end

function End:update(dt)

end

function End:updateAll(dt)
  for i, v in ipairs(ActiveEnds) do
    v:update(dt)
  end
end

function End:render()
  love.graphics.draw(self.IMAGE, self.x, self.y, 0, self.scale, self.scale)
end

function End:renderAll()
  for i, v in ipairs(ActiveEnds) do
    v:render()
  end
end

function End:remove()
  for i, instance in ipairs(ActiveEnds) do
    if instance == self then
      self.physics.body:destroy()
      table.remove(ActiveEnds, i)
    end
  end
end

function End:removeAll()
  for i,v in ipairs(ActiveEnds) do
    v.physics.body:destroy()
  end

  ActiveEnds = {}
end

function End:beginContact(a, b, collision)
  for i, instance in ipairs(ActiveEnds) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == hero.physics.fixture or b == hero.physics.fixture then
        print("colliding with End")
        Map:next()
        return true
      end
    end
  end
end
