Coin = Class{}

ActiveCoins = {}

function Coin:init(x, y)

  self.animation = newAnimation(love.graphics.newImage("assets/images/jakoin_spin.png"), 16, 16, 2)
  self.sound = love.audio.newSource('assets/sounds/coin.wav', 'static')

  self.x = x
  self.y = y

  self.image = love.graphics.newImage("assets/images/coin.png")
  self.width = 16
  self.height = 16

  self.toBeRemoved = false
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
  --print(self.x)
  --print(self.y)
  --self:spin(dt)
  self:checkRemove()
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

function Coin:remove()
  for i, instance in ipairs(ActiveCoins) do
    if instance == self then
      print("removing coin")
      self.sound:stop()
      self.sound:play()
      self.physics.body:destroy()
      table.remove(ActiveCoins, i)
      hero:incrementCoins()
    end
  end
end

function Coin:checkRemove()

  if self.toBeRemoved then
    print("found coin to remove")
    self:remove()
  end
end

function Coin:beginContact(a, b, collision)
  for i, instance in ipairs(ActiveCoins) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == hero.physics.fixture or b == hero.physics.fixture then
        print("colliding with coin")
        instance.toBeRemoved = true

        return true
      end
    end
  end
end
