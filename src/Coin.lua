Coin = Class{}

ActiveCoins = {}

function Coin:init(x, y)

  self.x = x
  self.y = y

  self.image = love.graphics.newImage("images/coin.png")
  self.width = 16
  self.height = 16


  self.spinOffset = math.random(0,100)

  self.scaleX = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x, self.y, "static")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.fixture:setSensor(true)

  table.insert(ActiveCoins, self)
end

function Coin:spin(dt)
  self.scaleX = math.sin(love.timer.getTime() * 3 + self.spinOffset)
end

function Coin:update(dt)
  print(self.x)
  print(self.y)
  self:spin(dt)
end

function Coin:updateAll(dt)
  for i, v in ipairs(ActiveCoins) do
    v:update(dt)
  end
end

function Coin:render()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, 1, self.width/2, self.height/2)
end

function Coin:renderAll()
  for i, v in ipairs(ActiveCoins) do
    v:render()
  end
end
