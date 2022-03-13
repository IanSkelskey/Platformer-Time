Ogre = Class{DMG_VALUE = 1}

ActiveOgres = {}

function Ogre:init(x, y)

  -- self.animation = newAnimation(love.graphics.newImage("assets/images/jakoin_spin.png"), 16, 16, 2)
  -- self.sound = love.audio.newSource('assets/sounds/Ogre.wav', 'static')

  self.x = x
  self.y = y

  self.image = love.graphics.newImage("assets/images/ogre.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.scale = 1

  self.physics = {}
  self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  self.physics.body:setFixedRotation(true)
  self.physics.fixture:setUserData('Ogre')
  --self.physics.fixture:setSensor(true)
  self.physics.body:setMass(0.5)
  --self.physics.body:setGravityScale(0)

  table.insert(ActiveOgres, self)
end

function Ogre:update(dt)
  self:syncPhysics()
  -- updateAnimation(self.animation, dt)
end

function Ogre:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
end

function Ogre:updateAll(dt)
  for i, v in ipairs(ActiveOgres) do
    v:update(dt)
  end
end

function Ogre:render()
  love.graphics.draw(self.image, self.x - self.width/2, self.y - self.height/2, 0, self.scale, self.scale)
  --renderAnimation(self.animation, self.x, self.y, 1)
end

function Ogre:renderAll()
  for i, v in ipairs(ActiveOgres) do
    v:render()
  end
end

function Ogre:removeAll()
  for i,v in ipairs(ActiveOgres) do
    v.physics.body:destroy()
  end

  ActiveOgres = {}
end

function Ogre:beginContact(a, b, collision)
  for i, instance in ipairs(ActiveOgres) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == hero.physics.fixture or b == hero.physics.fixture then
        hero:takeDamage(Ogre.DMG_VALUE)
        return true
      end
    end
  end
end
