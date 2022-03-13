Spike = Class{
  IMAGE = love.graphics.newImage("assets/images/spike.png"),
  DMG_VALUE = 1
}

ActiveSpikes = {}

function Spike:init(x, y)

  self.x = x
  self.y = y

  self.width = self.IMAGE:getWidth()
  self.height = self.IMAGE:getHeight()

  self.scaleX = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x + self.width/2, self.y + self.height/2, "static")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.fixture:setSensor(true)

  table.insert(ActiveSpikes, self)
end

function Spike:update(dt)

end

function Spike:updateAll(dt)
  for i, v in ipairs(ActiveSpikes) do
    v:update(dt)
  end
end

function Spike:render()
  love.graphics.draw(self.IMAGE, self.x, self.y, 0, self.scale, self.scale)
end

function Spike:renderAll()
  for i, v in ipairs(ActiveSpikes) do
    v:render()
  end
end

function Spike:removeAll()
  for i,v in ipairs(ActiveSpikes) do
    v.physics.body:destroy()
  end

  ActiveSpikes = {}
end

function Spike:beginContact(a, b, collision)
  for i, instance in ipairs(ActiveSpikes) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == hero.physics.fixture or b == hero.physics.fixture then
        print("colliding with Spike")
        hero:takeDamage(Spike.DMG_VALUE)

        return true
      end
    end
  end
end
