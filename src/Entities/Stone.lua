Stone = Class{}

ActiveStones = {}

function Stone:init(x, y)

  -- self.animation = newAnimation(love.graphics.newImage("assets/images/jakoin_spin.png"), 16, 16, 2)
  -- self.sound = love.audio.newSource('assets/sounds/Stone.wav', 'static')

  self.x = x
  self.y = y

  self.image = love.graphics.newImage("assets/images/stone.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.scale = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x + self.width/2, self.y - self.height/2, "dynamic")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.body:setFixedRotation(true)
  self.physics.body:setMass(0.5)

  table.insert(ActiveStones, self)
end

function Stone:update(dt)
  self:syncPhysics()
  -- updateAnimation(self.animation, dt)
end

function Stone:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
end

function Stone:updateAll(dt)
  for i, v in ipairs(ActiveStones) do
    v:update(dt)
  end
end

function Stone:render()
  love.graphics.draw(self.image, self.x - self.width/2, self.y - self.height/2, 0, self.scale, self.scale)
  --renderAnimation(self.animation, self.x, self.y, 1)
end

function Stone:removeAll()
  for i,v in ipairs(ActiveStones) do
    v.physics.body:destroy()
  end

  ActiveStones = {}
end

function Stone:renderAll()
  for i, v in ipairs(ActiveStones) do
    v:render()
  end
end
