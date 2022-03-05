Enemy = Class{DMG_VALUE = 1}

ActiveEnemys = {}

function Enemy:init(x, y)

  -- self.animation = newAnimation(love.graphics.newImage("assets/images/jakoin_spin.png"), 16, 16, 2)
  -- self.sound = love.audio.newSource('assets/sounds/Enemy.wav', 'static')

  self.x = x
  self.y = y

  self.image = love.graphics.newImage("assets/images/enemy.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.scale = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.body:setFixedRotation(true)
  self.physics.fixture:setUserData('Enemy')
  --self.physics.fixture:setSensor(true)
  self.physics.body:setMass(0.5)
  --self.physics.body:setGravityScale(0)

  table.insert(ActiveEnemys, self)
end

function Enemy:update(dt)
  self:syncPhysics()
  -- updateAnimation(self.animation, dt)
end

function Enemy:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
end

function Enemy:updateAll(dt)
  for i, v in ipairs(ActiveEnemys) do
    v:update(dt)
  end
end

function Enemy:render()
  love.graphics.draw(self.image, self.x - self.width/2, self.y - self.height/2, 0, self.scale, self.scale)
  --renderAnimation(self.animation, self.x, self.y, 1)
end

function Enemy:renderAll()
  for i, v in ipairs(ActiveEnemys) do
    v:render()
  end
end

function Enemy:removeAll()
  for i,v in ipairs(ActiveEnemys) do
    v.physics.body:destroy()
  end

  ActiveEnemys = {}
end

function Enemy:beginContact(a, b, collision)
  for i, instance in ipairs(ActiveEnemys) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == hero.physics.fixture or b == hero.physics.fixture then
        print("colliding with Enemy")
        hero:takeDamage(Enemy.DMG_VALUE)

        return true
      end
    end
  end
end
