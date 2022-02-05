Coin = Class{}

ActiveCoins = {}

function Coin:init(x, y)

  self.animation = newAnimation(love.graphics.newImage("images/jakoin_spin.png"), 16, 16, 2)

  self.x = x
  self.y = y

  self.image = love.graphics.newImage("images/coin.png")
  self.width = 16
  self.height = 16


  -- self.spinOffset = math.random(0,100)

  self.scaleX = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x, self.y, "static")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.fixture:setSensor(true)

  self.POINT_VALUE = 10

  table.insert(ActiveCoins, self)
end

-- function Coin:spin(dt)
--   self.scaleX = math.sin(love.timer.getTime() * 3 + self.spinOffset)
-- end

function Coin:update(dt)
  print(self.x)
  print(self.y)
  --self:spin(dt)
  updateAnimation(self.animation, dt)
end

function Coin:updateAll(dt)
  for i, v in ipairs(ActiveCoins) do
    v:update(dt)
  end
end

function Coin:render()
  renderAnimation(self.animation, self.x - self.width/2, self.y-self.height/2, 1)
end

function Coin:renderAll()
  for i, v in ipairs(ActiveCoins) do
    v:render()
  end
end
