Coin = Class{
  IMAGE = love.graphics.newImage("assets/images/coin.png"),
  SOUND = love.audio.newSource('assets/sounds/coin.wav', 'static'),
  SCORE_VALUE = 10
}

ActiveCoins = {}

function Coin:init(x, y)

  self.animation = newAnimation(love.graphics.newImage("assets/images/jakoin_spin.png"), 16, 16, 2)

  self.x = x
  self.y = y

  self.width = self.IMAGE:getWidth()
  self.height = self.IMAGE:getHeight()

  self.toBeRemoved = false

  self.scaleX = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x + self.width/2, self.y + self.height/2, "static")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.fixture:setSensor(true)

  table.insert(ActiveCoins, self)
end

function Coin:update(dt)
  self:checkRemove()
  updateAnimation(self.animation, dt)
end

function Coin:updateAll(dt)
  for i, v in ipairs(ActiveCoins) do
    v:update(dt)
  end
end

function Coin:render()
  renderAnimation(self.animation, self.x, self.y, 1)
end

function Coin:renderAll()
  for i, v in ipairs(ActiveCoins) do
    v:render()
  end
end

function Coin:remove()
  for i, instance in ipairs(ActiveCoins) do
    if instance == self then
      self.SOUND:stop()
      self.SOUND:play()
      self.physics.body:destroy()
      table.remove(ActiveCoins, i)
      hero:incrementCoins()
    end
  end
end

function Coin:removeAll()
  for i,v in ipairs(ActiveCoins) do
    v.physics.body:destroy()
  end

  ActiveCoins = {}
end

function Coin:checkRemove()

  if self.toBeRemoved then
    self:remove()
  end
end

function Coin:beginContact(a, b, collision)
  for i, instance in ipairs(ActiveCoins) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == hero.physics.fixture or b == hero.physics.fixture then
        instance.toBeRemoved = true
        return true
      end
    end
  end
end
